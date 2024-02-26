import UIKit

class ProductCustomCell: UITableViewCell {
    //Outlets establishing connection with storyboard
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var removeFromCartButton: UIButton!
    
    var buttonActionHandler: ((UIButton) -> Void)?
    
    func configure(with product: Product) {
        productTitle.text = product.title
        productPrice.text = "Price: " + String(product.price) + "$"
        
        // Load image asynchronously
        if let url = URL(string: product.image) {
            productImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    // When button tapped action handeler (for all buttons)
    @IBAction func buttonTapped(_ sender: UIButton) {
        buttonActionHandler?(sender)
    }
    
    // Adujsting product title label
    override func awakeFromNib() {
        super.awakeFromNib()
        productTitle.numberOfLines = 0
        productTitle.lineBreakMode = .byWordWrapping
        productTitle.adjustsFontSizeToFitWidth = true
        productTitle.minimumScaleFactor = 0.8
    }
}
