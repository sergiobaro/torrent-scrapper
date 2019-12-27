import XCTest
import SwiftSoup
@testable import TorrentScrapper

class MagnetTdlTests: XCTestCase {
  
  let magnetTdl = MagnetTdl()
  
  // MARK: - Search Text
  
  func test_searchEmpty() {
    let result = try? self.magnetTdl.searchURL(text: "")
    
    XCTAssertNil(result)
  }
  
  func test_searchText() {
    let result = try? self.magnetTdl.searchURL(text: "euphoria")
    
    XCTAssertEqual(result?.absoluteString, "https://www.magnetdl.com/e/euphoria/se/desc/")
  }

  func test_searchText_withSpaces() {
    let result = try? self.magnetTdl.searchURL(text: "the witcher")

    XCTAssertEqual(result?.absoluteString, "https://www.magnetdl.com/t/the-witcher/se/desc/")
  }

  func test_searchText_withUppercaseCharacters() {
    let result = try? self.magnetTdl.searchURL(text: "The Witcher 1080p")

    XCTAssertEqual(result?.absoluteString, "https://www.magnetdl.com/t/the-witcher-1080p/se/desc/")
  }
  
  // MARK: - Parse List
  
  func test_parseList() {
    let doc = self.loadDoc(resource: "MagnetTdl.html")
    let result = try? self.magnetTdl.parseList(doc: doc)
    
    XCTAssertEqual(result?.count, 1)
    
    let first = result?.first
    XCTAssertEqual(first?.name, "The.Witcher.US.S01.COMPLETE.1080p.WEB.x264-STRiFE [TGx]")
    XCTAssertNotNil(first?.detailPageURL)
    XCTAssertNotNil(first?.magnetURL)
  }
  
  // MARK: - Helpers
  
  private func loadDoc(resource: String) -> Document {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: resource, withExtension: nil)!
    let data = try! Data(contentsOf: url)
    let html = String(data: data, encoding: .utf8)!
    
    return try! SwiftSoup.parse(html)
  }
}
