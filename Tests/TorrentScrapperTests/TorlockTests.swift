import XCTest
@testable import TorrentScrapper

class TorlockTests: XCTestCase {

  let torlock = Torlock()

  func test_searchText() {
    let result = try? self.torlock.searchURL(text: "euphoria")
    
    XCTAssertEqual(result?.absoluteString, "https://www.torlock2.com/all/torrents/euphoria.html?sort=seeds&order=desc")
  }

  func test_searchText_withSpaces() {
    let result = try? self.torlock.searchURL(text: "euphoria s01e01")

    XCTAssertEqual(result?.absoluteString, "https://www.torlock2.com/all/torrents/euphoria-s01e01.html?sort=seeds&order=desc")
  }

}
