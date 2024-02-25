import UIKit

class ProductCustomCell: UITableViewCell {

    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productImage: UIImageView!

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
