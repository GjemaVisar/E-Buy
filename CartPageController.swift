import UIKit

class CartPageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet var totalPriceLabel: UILabel!
    
    private var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        // Fetch data from the database
        updateCart()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch data from the database every time the view appears
        updateCart()
    }
    
    
    func updateCart() {
        products = DataBaseManager.shared.getAllCartProducts()
        // Calculate total price
        let totalPrice = products.reduce(0) { $0 + $1.price }
        totalPriceLabel.text = "Total Price: " + String(format: "%.2f", totalPrice) + "$"
        // Reload the data in the cartTableView on the main thread
        DispatchQueue.main.async {
            self.cartTableView.reloadData()
            
            // Check if the cart is empty and the table view is visible, then present alert
            if self.cartTableView.visibleCells.isEmpty && totalPrice == 0 {
                self.showAlert(message: "To buy, add products to cart from the home page", title: "No Products Added")
            }
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCustomCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        cell.buttonActionHandler = { [weak self] sender in
            guard let self = self else { return }
            if sender == cell.removeFromCartButton {
                self.removeFromCartButtonTapped(for: product)
            } else if sender == cell.buyButton {
                self.buyButtonPressed(for: product)
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func buyButtonPressed(for product: Product) {
        if product.quantity > 0 {
            // Update quantity in the database
            DataBaseManager.shared.decrementProductQuantity(productName: product.title)
            _ = DataBaseManager.shared.deleteProductFromCart(productId: product.id)
            showAlert(message: "Product bought successesfully", title: "Success")
            updateCart()
        } else {
                showAlert(message: "Product is out of stock", title: "Error")
        }
    }
    
    
    func removeFromCartButtonTapped(for product: Product) {
        if DataBaseManager.shared.deleteProductFromCart(productId: product.id) {
           showAlert(message: "Product removed successfully", title: "Success")
            updateCart()
        }
    }
    
    
    func showAlert(message: String,title: String) {
        let alert = UIAlertController(title: title,  message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
