
import UIKit

class LinkCollectionViewCell: UICollectionViewCell {

  static let labelFont = UIFont.systemFontOfSize(UIFont.systemFontSize())

  static let xMargin: CGFloat = 10
  static let yMargin: CGFloat = 10

  @IBOutlet private weak var URLLabel: UILabel!

  @IBOutlet private weak var leadingSpaceLayoutContraint: NSLayoutConstraint!
  @IBOutlet private weak var topSpaceLayoutContraint: NSLayoutConstraint!
  @IBOutlet private weak var trailingSpaceLayoutContraint: NSLayoutConstraint!
  @IBOutlet private weak var bottomSpaceLayoutContraint: NSLayoutConstraint!

  var URLString: String {
    get {
      return URLLabel.text!
    }
    set(newString) {
      URLLabel.text = newString
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    URLLabel.font = LinkCollectionViewCell.labelFont
    leadingSpaceLayoutContraint.constant = LinkCollectionViewCell.xMargin / 2
    trailingSpaceLayoutContraint.constant = LinkCollectionViewCell.xMargin / 2
    topSpaceLayoutContraint.constant = LinkCollectionViewCell.yMargin / 2
    bottomSpaceLayoutContraint.constant = LinkCollectionViewCell.yMargin / 2
  }

}
