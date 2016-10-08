
import UIKit
import LinksGetter

protocol KeyboardViewDelegate: class {
  func viewDidPressNext()
  func viewDidPressBackspace()
  func viewDidSelectURLString(URL: String)
}

class KeyboardView: UIView {

  weak var delegate: KeyboardViewDelegate?

  class func view() -> KeyboardView? {
    return NSBundle.mainBundle().loadNibNamed("KeyboardView", owner: self, options: nil).last as? KeyboardView
  }

  @IBAction func nextPressed(sender: UIButton) {
    delegate?.viewDidPressNext()
  }

  @IBAction func backspacePressed(sender: UIButton) {
    delegate?.viewDidPressBackspace()
  }
}

extension KeyboardView: UICollectionViewDataSource {

  func registerNib(collectionView view: UICollectionView) {
    var onceToken: dispatch_once_t = 0
    dispatch_once(&onceToken) {
      let nib = UINib(nibName: "LinkCollectionViewCell", bundle: nil)
      view.registerNib(nib, forCellWithReuseIdentifier: "LinkCell")

      let effect = UIBlurEffect(style: .Light)
      let blurredView = UIVisualEffectView(effect: effect)
      view.backgroundView = blurredView

      let layout = view.collectionViewLayout as! UICollectionViewFlowLayout
      layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
  }

  func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    registerNib(collectionView: collectionView)
    return getLinks().count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LinkCell", forIndexPath: indexPath) as! LinkCollectionViewCell
    cell.URLString = getLinks()[indexPath.row].absoluteString
    return cell
  }

}

extension KeyboardView: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LinkCollectionViewCell
    delegate?.viewDidSelectURLString(cell.URLString)
  }
}

extension KeyboardView: UICollectionViewDelegateFlowLayout {

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let linkString = getLinks()[indexPath.row].absoluteString
    let layout = collectionViewLayout as! UICollectionViewFlowLayout

    let labelWidth = layout.itemSize.width - LinkCollectionViewCell.xMargin
    var height = linkString.heightWithConstrainedWidth(labelWidth, font:LinkCollectionViewCell.labelFont) + LinkCollectionViewCell.yMargin
    if height <= layout.itemSize.height {
      height = layout.itemSize.height
    } else {
      let maxHeight = layout.itemSize.height * 2 + layout.minimumLineSpacing
      height = maxHeight
    }

    let rect = CGRect(origin: CGPointZero, size: CGSize(width: labelWidth, height: height))
    return CGRectIntegral(rect).size
  }

}
