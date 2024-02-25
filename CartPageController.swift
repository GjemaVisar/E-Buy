import UIKit

class CartPageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var cartTableView: UITableView!

    private var products: [DataBaseManager.Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        // Fetch data from the database
        products = DataBaseManager.shared.getAllCartProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Fetch data from the database every time the view appears
        products = DataBaseManager.shared.getAllCartProducts()

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
                // Remove the product from the local array
                self.products.remove(at: indexPath.row)

                // Reload the data in the cartTableView on the main thread
                DispatchQueue.main.async {
                    self.cartTableView.reloadData()
                }
            }
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
}
