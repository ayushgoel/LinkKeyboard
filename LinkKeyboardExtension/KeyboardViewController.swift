
import UIKit

class KeyboardViewController: UIInputViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    inputView!.backgroundColor = UIColor.clearColor()
    if let keyboardView = KeyboardView.view() {
      keyboardView.delegate = self
      keyboardView.translatesAutoresizingMaskIntoConstraints = false
      self.inputView!.addSubview(keyboardView)

      let cl = NSLayoutConstraint(item: keyboardView, attribute: .Leading, relatedBy: .Equal, toItem: keyboardView.superview, attribute: .Leading, multiplier: 1, constant: 0)
      let cr = NSLayoutConstraint(item: keyboardView, attribute: .Trailing, relatedBy: .Equal, toItem: keyboardView.superview, attribute: .Trailing, multiplier: 1, constant: 0)
      let ct = NSLayoutConstraint(item: keyboardView, attribute: .Top, relatedBy: .Equal, toItem: keyboardView.superview, attribute: .Top, multiplier: 1, constant: 0)
      let cb = NSLayoutConstraint(item: keyboardView, attribute: .Bottom, relatedBy: .Equal, toItem: keyboardView.superview, attribute: .Bottom, multiplier: 1, constant: 0)

      self.inputView!.addConstraints([cl, cr, ct, cb])
    }

  }

  override func textDidChange(textInput: UITextInput?) {
    let proxy = self.textDocumentProxy
    let textColor = proxy.keyboardAppearance == UIKeyboardAppearance.Dark ? UIColor.whiteColor() : UIColor.blackColor()
    print(textColor)
  }

}

extension KeyboardViewController: KeyboardViewDelegate {
  func viewDidPressNext() {
    self.advanceToNextInputMode()
  }

  func viewDidPressBackspace() {
    self.textDocumentProxy.deleteBackward()
  }

  func viewDidSelectURLString(URL: String) {
    textDocumentProxy.insertText(URL)
  }
}
