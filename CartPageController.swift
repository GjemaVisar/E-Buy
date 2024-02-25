import UIKit

class CartPageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet var totalPriceLabel: UILabel!

    private var products: [DataBaseManager.Product] = []

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
        let totalPrice = String(format: "%.2f", products.reduce(0) { $0 + $1.price })

        totalPriceLabel.text = "Total Price: " + totalPrice + "$"
        // Reload the data in the cartTableView on the main thread
        DispatchQueue.main.async {
            self.cartTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCustomCell
        let product = products[indexPath.row]
        cell.productTitle.text = product.title
        cell.productPrice.text = "Price: " + String(product.price)
        cell.removeFromCartButtonTapped = {
            // Call the deleteProductFromCart function
            if DataBaseManager.shared.deleteProductFromCart(productId: product.id) {
                // Update the cart and total price
                self.updateCart()
            }
        }
        cell.buyButtonTapped = { [weak self] in
                   self?.buyButtonPressed(for: product)
               }

        if let url = URL(string: product.image) {
            if let data = try? Data(contentsOf: url) {
                cell.productImage.image = UIImage(data: data)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func buyButtonPressed(for product: DataBaseManager.Product) {
            if product.quantity > 0 {
                // Update quantity in the database
                DataBaseManager.shared.decrementProductQuantity(productName: product.title)
                DataBaseManager.shared.deleteProductFromCart(productId: product.id)
                // Update cart and total price
                updateCart()
            } else {
                showAlert(message: "Product is out of stock")
            }
        }
        
        func showAlert(message: String) {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
