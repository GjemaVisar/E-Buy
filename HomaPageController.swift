import UIKit

class HomePageController: UIViewController, UITableViewDataSource{
    
    @IBOutlet var productsTableView: UITableView!
    
    private var products: [DataBaseManager.Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.dataSource = self
       
       
    
        
        // Register your custom cell class
        
        
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
        return cell
    }
   
}



