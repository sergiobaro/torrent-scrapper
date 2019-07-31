import Foundation
import SwiftSoup

class Torlock {

  private let domain = "https://www.torlock.com"
  private let searchPath = "/all/torrents"
  private let searchExtension = ".html"
  private let searchParams = "?sort=seeds&order=desc"
  
}

// MARK: - TorrentProvider
extension Torlock: TorrentProvider {

  func searchURL(text: String) throws -> URL {
    let escapedText = text.replacingOccurrences(of: " ", with: "-")
    let string = self.domain + self.searchPath + "/" + escapedText + self.searchExtension + self.searchParams

    guard let url = URL(string: string) else {
      throw TorrentError.invalidUrl(string)
    }

    return url
  }

  func parseList(doc: Document) throws -> TorrentResult? {
    for div in try doc.select("div.panel.panel-default") {
      for table in try div.select(".table.table-striped.table-bordered.table-hover.table-condensed") {
        for row in try table.select("tr") {
          if let result = try self.parseResult(row: row) {
            return result
          }
        }
      }
    }

    return nil
  }

  func parseDetail(doc: Document) throws -> TorrentResult? {
    let table = try doc.select(".table.table-condensed").first()
    let name = try table?.select("h4").first()?.text()
    let magnetLink = try table?.select("h4 a").first()?.attr("href")

    return TorrentResult(
      name: name ?? "",
      detailPageURL: nil,
      magnetURL: magnetLink.flatMap({ URL(string: $0) })
    )
  }

}

// MARK: - Private
extension Torlock {

  private func parseResult(row: Element) throws -> TorrentResult? {
    if let nameLink = try row.select("td").first()?.select("a").first() {
      let relativeLink = try nameLink.attr("href")

      let link = self.domain + relativeLink
      let name = try nameLink.text()

      return TorrentResult(
        name: name,
        detailPageURL: URL(string: link),
        magnetURL: nil
      )
    }

    return nil
  }
}
