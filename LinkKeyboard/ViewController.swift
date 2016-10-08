
import UIKit
import LinksGetter

class ViewController: UIViewController {

  @IBOutlet var tableView: UITableView!

  private var tableViewController: UITableViewController!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44

    let tableViewController = UITableViewController()
    tableViewController.tableView = tableView
    tableViewController.refreshControl = refreshControl()
    self.tableViewController = tableViewController
  }

  private func refreshControl() -> UIRefreshControl {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
    return refreshControl
  }

  private var links: [NSURL] {
    get {
      return getLinks()
    }
    set(newLinks) {
      setLinks(newLinks)
    }
  }

  private func presentInvalidURLAlert(URL: String) {
    let alert = UIAlertController(title: "Entered URL \"\(URL)\" is not valid", message: nil, preferredStyle: .Alert)
    let action = UIAlertAction(title: "Ok", style: .Default) {[weak self] action in
      self?.dismissViewControllerAnimated(true, completion: nil)
    }
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
  }

  private func addLink(linkString: String) {
    guard let link = linkString.URL() else {
      self.presentInvalidURLAlert(linkString)
      return
    }
    links = links + [link]
    let indexPath = NSIndexPath(forRow: links.count - 1, inSection: 0)
    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
  }

  @IBAction func addTapped(sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add a new link", message: nil, preferredStyle: .Alert)
    alert.addTextFieldWithConfigurationHandler { textField in
      textField.placeholder = "Link"
      textField.keyboardType = .URL
      textField.autocapitalizationType = .None
      textField.autocorrectionType = .No
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { [weak self] _ in
      self?.dismissViewControllerAnimated(true, completion: nil)
    }
    alert.addAction(cancelAction)
    let action = UIAlertAction(title: "Ok", style: .Default) { action in
      if let link = alert.textFields?.first?.text {
        self.addLink(link)
      }
    }
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
  }

  private func buttonItem(item: UIBarButtonSystemItem) -> UIBarButtonItem {
    return UIBarButtonItem(barButtonSystemItem: item,
                           target: self,
                           action: #selector(editTapped))
  }

  @objc
  @IBAction func editTapped(sender: UIBarButtonItem) {
    if tableView.editing {
      let item = buttonItem(.Edit)
      navigationItem.setLeftBarButtonItem(item, animated: true)
      tableView.setEditing(false, animated: true)
    } else {
      let item = buttonItem(.Done)
      navigationItem.setLeftBarButtonItem(item, animated: true)
      tableView.setEditing(true, animated: true)
    }
  }

  @objc
  private func refresh(control: UIRefreshControl) {
    tableView.reloadData()
    control.endRefreshing()
  }

}

extension ViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return links.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("URLCell", forIndexPath: indexPath)
    cell.textLabel?.text = links[indexPath.row].absoluteString
    return cell
  }

  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    switch editingStyle {
    case .Delete:
      links.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    default:
      preconditionFailure()
    }
  }

  func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

  func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    (links[sourceIndexPath.row], links[destinationIndexPath.row])
    = (links[destinationIndexPath.row], links[sourceIndexPath.row])
  }
}

extension ViewController: UITableViewDelegate {
}
