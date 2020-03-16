import Foundation
import SwiftSoup

class Rarbg {
  
  private let domain = "https://rarbgunblock.com"
  private let searchPath = "/torrents.php?search="
  private let searchParams = "&order=seeders&by=DESC"
  
}

// MARK: - TorrentProvider
extension Rarbg: TorrentProvider {
  
  var name: String { "Rarbg" }
  
  func searchURL(text: String) throws -> URL? {
    if text.isEmpty {
      return nil
    }
    
    let escapedText = text.replacingOccurrences(of: " ", with: "+")
    let string = self.domain + self.searchPath + escapedText + self.searchParams

    guard let url = URL(string: string) else {
      throw TorrentError.invalidUrl(string)
    }

    return url
  }
  
  func parseList(doc: Document) throws -> [TorrentResult] {
    let table = try doc.select("table.lista2t")
    for row in try table.select("tr.lista2") {
      if let result = try self.parseResult(row: row) {
        return [result]
      }
    }
    
    return []
  }
  
  func parseDetail(doc: Document) throws -> TorrentResult? {
    guard let table = try doc.select("table.lista").first() else {
      return nil
    }
    guard let cell = try table.select("td.lista").first() else {
      return nil
    }
    
    let magnetLink = try cell.select("a")[1].attr("href")
    
    return TorrentResult(
      name: "",
      detailPageURL: nil,
      magnetURL: URL(string: magnetLink)
    )
  }
}

// MARK: - Private
extension Rarbg {
  
  private func parseResult(row: Element) throws -> TorrentResult? {
    guard let link = try row.select("td")[1].select("a").first() else {
      return nil
    }
    
    let name = try link.attr("title")
    let relativeLink = try link.attr("href")
    let absoluteLink = self.domain + relativeLink
    
    return TorrentResult(
      name: name,
      detailPageURL: URL(string: absoluteLink),
      magnetURL: nil
    )
  }
}
