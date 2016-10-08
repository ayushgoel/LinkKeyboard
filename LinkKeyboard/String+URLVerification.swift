
import Foundation

private let detector = try! NSDataDetector(types: NSTextCheckingType.Link.rawValue)

extension String {
  func URL() -> NSURL? {
    let textRange = NSMakeRange(0, self.characters.count)
    guard let URLResult = detector.firstMatchInString(self, options: [], range: textRange) else {
      return nil
    }
    guard NSEqualRanges(URLResult.range, textRange) else {
      return nil
    }
    return NSURL(string: self)
  }
}
