
import Foundation

let sharedDefaultsSuiteName = "group.LinkKeyboard"

public func getLinks() -> [NSURL] {
  guard let defaults = NSUserDefaults(suiteName: sharedDefaultsSuiteName) else {
    print("Defaults not initialized")
    return []
  }
  guard let linkStrings = defaults.arrayForKey("links") else {
    print("links not found")
    return []
  }
  return linkStrings.map { (string) -> NSURL in
    return NSURL(string: string as! String)!
  }
}

public func setLinks(links: [NSURL]) {
  guard let defaults = NSUserDefaults(suiteName: sharedDefaultsSuiteName)
    else {
      print("Defaults not initialized")
      return
  }
  let newLinkStrings = links.map({ $0.absoluteString })
  defaults.setObject(newLinkStrings, forKey: "links")
}

public func addLink(link: NSURL) {
  setLinks(getLinks() + [link])
}
