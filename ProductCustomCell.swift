import UIKit

class ProductCustomCell: UITableViewCell {

    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var buyButton: UIButton!
    var buyButtonTapped: (() -> Void)?

       @IBAction func onBuyButtonTapped(_ sender: Any) {
           buyButtonTapped?()
           let alertController = UIAlertController(title: "Product Bought",
                                                           message: "Product bought successfully!",
                                                           preferredStyle: .alert)

                   let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alertController.addAction(okAction)

                   // Get the current view controller to present the alert
                   if let currentViewController = UIApplication.shared.keyWindow?.rootViewController {
                       currentViewController.present(alertController, animated: true, completion: nil)
                   }
       }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Enable multiline for productTitle
        productTitle.numberOfLines = 0
        productTitle.lineBreakMode = .byWordWrapping
        
        // Adjust font size to fit the content
        productTitle.adjustsFontSizeToFitWidth = true
        productTitle.minimumScaleFactor = 0.8 // You can adjust this value as needed
    }
}
