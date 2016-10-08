
import XCTest

class LinkKeyboardUITests: XCTestCase {

  let app = XCUIApplication()

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    setupSnapshot(app)
    app.launch()
  }

  private func tapButton(tag: String) {
    let button = app.buttons[tag]
    let buttonExists = NSPredicate(format: "exists == true")
    expectationForPredicate(buttonExists, evaluatedWithObject: button, handler: nil)
    waitForExpectationsWithTimeout(5, handler: nil)
    print("Going to tap \(button)")
    button.tap()
  }

  private func tapAddButton() {
    tapButton("Add")
  }

  private func tapEditButton() {
    tapButton("Edit")
  }

  private func addLink(link: String) {
    tapAddButton()

    let alert = app.alerts
    let alertExists = NSPredicate(format: "element.exists == true")
    expectationForPredicate(alertExists, evaluatedWithObject: alert, handler: nil)
    waitForExpectationsWithTimeout(5, handler: nil)

    app.textFields.element.tap()
    app.typeText(link)
    app.buttons["Ok"].tap()

    let alertNotExists = NSPredicate(format: "element.exists == false")
    expectationForPredicate(alertNotExists, evaluatedWithObject: alert, handler: nil)
    waitForExpectationsWithTimeout(5, handler: nil)
  }

  func testCreateSnapshots() {
    XCTAssertEqual(app.tables.count, 1)

    tapAddButton()

    let alert = app.alerts
    let alertExists = NSPredicate(format: "element.exists == true")
    expectationForPredicate(alertExists, evaluatedWithObject: alert, handler: nil)
    waitForExpectationsWithTimeout(5, handler: nil)
    app.textFields.element.tap()
    app.typeText("https://www.apple.com")

    snapshot("AddLinkInApp")

    app.buttons["Ok"].tap()
    let alertNotExists = NSPredicate(format: "element.exists == false")
    expectationForPredicate(alertNotExists, evaluatedWithObject: alert, handler: nil)
    waitForExpectationsWithTimeout(5, handler: nil)

    addLink("https://github.com/ayushgoel/AGEmojiKeyboard")
    addLink("https://itunes.apple.com/us/app/accelerate-speed-up-your-reading/id888585920")
    addLink("mailto:ayush@riva.co")
    addLink("https://twitter.com/named_none/")
    addLink("http://www.techmyway.com/")
    addLink("http://blog.techmyway.com/me.html")
    addLink("https://in.linkedin.com/in/ayushgoel")
    addLink("https://itunes.apple.com/us/app/checkvistle-checkvist-on-go/id995611134")
    addLink("https://github.com/ayushgoel/")
    addLink("http://stackoverflow.com/users/1685709/ayush-goel")
    addLink("https://itunes.apple.com/us/artist/ayush-goel/id888585923")
    addLink("http://blog.techmyway.com/2016/04/22/using-fastlane-to-submit-builds-for-external-testing.html")
    addLink("http://www.facebook.com/meayushgoel")
    addLink("http://www.twitter.com/checkvistle")
    addLink("http://www.instagram.com/meayushgoel")

    app.tables.cells.elementBoundByIndex(3).swipeLeft()
    snapshot("LinksTable")

    tapEditButton()
    snapshot("LinksTableEdit")

    print("Change Keyboard to LinkKeyboard")
    tapAddButton()
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 30))
    snapshot("LinkKeyboard")
  }
}
