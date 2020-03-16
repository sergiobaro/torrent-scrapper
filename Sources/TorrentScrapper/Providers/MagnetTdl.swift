import Foundation
import SwiftSoup

class MagnetTdl {
  
  let domain = "https://www.magnetdl.com"
  let searchParams = "/se/desc/"
  
}

extension MagnetTdl: TorrentProvider {
  
  var name: String { "MagnetTDL" }
  
  func searchURL(text: String) throws -> URL? {
    guard text.count > 1 else {
      return nil
    }
    
    let search = text
      .trimmingCharacters(in: .whitespaces)
      .lowercased()
      .replacingOccurrences(of: " ", with: "-")
    
    let string = "\(self.domain)/\(search.first!)/\(search)\(self.searchParams)"
    
    return URL(string: string)
  }
  
  func parseList(doc: Document) throws -> [TorrentResult] {
    let table = try doc.select("table.download").first()
    guard let rows = try table?.select("tr") else {
      return []
    }
    
    for row in rows {
      let nameAnchor = try row.select("td.n a")
      if nameAnchor.isEmpty() {
        continue
      }
      
      let name = try nameAnchor.text()
      let relativeLink = try nameAnchor.attr("href")
      let absoluteLink = self.domain + relativeLink
      let magnetLink = try row.select("td.m a").attr("href")
      
      let result = TorrentResult(
        name: name,
        detailPageURL: URL(string: absoluteLink),
        magnetURL: URL(string: magnetLink)
      )
      
      return [result]
    }
    
    return []
  }
  
  func parseDetail(doc: Document) throws -> TorrentResult? {
    return nil
  }
}
