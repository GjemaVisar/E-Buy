import UIKit
import SDWebImage

class HomePageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var productsTableView: UITableView!
    
    private var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.dataSource = self
        productsTableView.delegate = self
        //Fetch products from DB
        products = DataBaseManager.shared.getAllProducts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCustomCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        cell.buttonActionHandler = { [weak self] _ in
            guard let self = self else { return }
            // Call the insertProductIntoCart function
            _ = DataBaseManager.shared.insertProductIntoCart(product: product)
            self.showAlert(message: "Product inserted into cart", title: "Success")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func showAlert(message: String,title: String) {
        let alert = UIAlertController(title: title,  message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
