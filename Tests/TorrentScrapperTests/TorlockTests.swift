import XCTest
@testable import TorrentScrapper

class TorlockTests: XCTestCase {

  let torlock = Torlock()

  func test_searchText() {
    let result = try? self.torlock.search(text: "euphoria")
    
    XCTAssertEqual(result?.absoluteString, "https://www.torlock.com/all/torrents/euphoria.html")
  }

  func test_searchText_withSpaces() {
    let result = try? self.torlock.search(text: "euphoria s01e01")

    XCTAssertEqual(result?.absoluteString, "https://www.torlock.com/all/torrents/euphoria-s01e01.html")
  }

}
