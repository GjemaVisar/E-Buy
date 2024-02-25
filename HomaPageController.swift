import UIKit
import SDWebImage

class HomePageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var productsTableView: UITableView!
    
    private var products: [DataBaseManager.Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.dataSource = self
        productsTableView.delegate = self
        // Fetch data from the database
        products = DataBaseManager.shared.getAllProducts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCustomCell
        let product = products[indexPath.row]
        cell.productTitle.text = product.title
        cell.productPrice.text = "Price: " + String(product.price)
        cell.addToCartButtonTapped = {
                // Call the insertProductIntoCart function
                 DataBaseManager.shared.insertProductIntoCart(product: product)
               
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
