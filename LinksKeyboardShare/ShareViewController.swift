
import UIKit
import MobileCoreServices
import LinksGetter

class ShareViewController: UIViewController {

  @IBOutlet var containerView: UIView!

  @IBOutlet var centerYConstraint: NSLayoutConstraint!
  @IBOutlet var cancelButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet var addButtonWidthConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.centerYConstraint.constant = -self.view.bounds.height
    view.layoutIfNeeded()
    UIView.animateWithDuration(0.7,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .CurveEaseIn,
      animations: { [weak self] in
        self?.centerYConstraint.constant = 0
        self?.view.layoutIfNeeded()
      },
      completion: nil)
  }

  private func removeContainer(completion: () -> Void) {
    UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: { [weak self] in
      self?.centerYConstraint.constant = (self?.view.bounds.height)!
      self?.view.layoutIfNeeded()
      }) { (completed) -> Void in
        if completed {
          completion()
        }
    }
  }

  private func coverButton2WithButton1(button1Constraint: NSLayoutConstraint, button2Constraint: NSLayoutConstraint, completion: () -> Void) {
    assert(button1Constraint.constant == button2Constraint.constant)
    UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: { [weak self] in
      button1Constraint.constant = 2 * button1Constraint.constant
      button2Constraint.constant = 0
      self?.view.layoutIfNeeded()
    }) { (completed) -> Void in
      if completed {
        completion()
      }
    }
  }

  @IBAction func cancelTapped(button: UIButton) {
    let error = NSError(domain: "LinkKeyboardErrorDomain", code: 0, userInfo: nil)
    coverButton2WithButton1(self.cancelButtonWidthConstraint, button2Constraint: self.addButtonWidthConstraint) { [weak self] in
      self?.removeContainer() { [weak self] in
        self?.extensionContext?.cancelRequestWithError(error)
      }
    }
  }

  @IBAction func addTapped(button: UIButton) {
    if let context = extensionContext {
      for item in context.inputItems {
        if let anyAttachments = (item as? NSExtensionItem)?.attachments {
          for itemProvider in anyAttachments {
            guard let provider = itemProvider as? NSItemProvider else {
              continue
            }
            if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
              provider.loadItemForTypeIdentifier(kUTTypeURL as String, options: nil, completionHandler: { (item, error) in
                guard let link = item as? NSURL else {
                  return
                }
                addLink(link)
              })
            }
          }
        }
      }
    }
    coverButton2WithButton1(self.addButtonWidthConstraint, button2Constraint: self.cancelButtonWidthConstraint) { [weak self] in
      self?.removeContainer() { [weak self] in
        self?.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
      }
    }
  }

}
