import XCTest
@testable import TorrentScrapper

class RarbgTests: XCTestCase {
  
  let rarbg = Rarbg()
  
  func test_searchEmpty() {
    let url = try? self.rarbg.searchURL(text: "")
    
    XCTAssertNil(url)
  }
  
  func test_searchText() {
    let url = try? self.rarbg.searchURL(text: "britannia")
    
    XCTAssertEqual(url?.absoluteString, "https://rarbgunblock.com/torrents.php?search=britannia&order=seeders&by=DESC")
  }
  
  func test_searchText_withSpaces() {
    let url = try? self.rarbg.searchURL(text: "britannia s02")
    
    XCTAssertEqual(url?.absoluteString, "https://rarbgunblock.com/torrents.php?search=britannia+s02&order=seeders&by=DESC")
  }
  
}
