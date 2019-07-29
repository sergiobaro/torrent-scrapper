import Foundation
import SwiftSoup

class Torlock {

  private let domain = "https://www.torlock.com"
  private let searchPath = "/all/torrents"
  private let searchSuffix = ".html"
  
}

extension Torlock: TorrentProvider {

  func search(text: String) throws -> URL {
    let escapedText = text.replacingOccurrences(of: " ", with: "-")
    let urlString = domain + searchPath + "/" + escapedText + searchSuffix

    guard let url = URL(string: urlString) else {
      throw TorrentError.invalidUrl(urlString)
    }

    return url
  }

  func parse(doc: Document) throws -> [TorrentResult] {
    var result = [TorrentResult]()

    for div in try doc.select("div.panel.panel-default") {
      for table in try div.select(".table.table-striped.table-bordered.table-hover.table-condensed") {
        for row in try table.select("tr") {
          if let nameLink = try row.select("td").first()?.select("a").first() {
            let relativeLink = try nameLink.attr("href")

            let link = self.domain + relativeLink
            let name = try nameLink.text()
            let date = try row.select("td.td").first()?.text()
            let size = try row.select("td.ts").first()?.text()
            let seeds = try row.select("td.tul").first()?.text()
            let peers = try row.select("td.tdl").first()?.text()
            let health = try self.parseHealth(row: row)

            print("Link: \(link)")
            print("Name: \(name)")
            print("Date: \(String(describing: date))")
            print("Size: \(String(describing: size))")
            print("Seeds: \(String(describing: seeds))")
            print("Peers: \(String(describing: peers))")
            print("Health: \(String(describing: health))")
          }
        }
      }
    }

    return result
  }

  private func parseHealth(row: Element) throws -> Int? {
    guard let health = try row.select("td img.th").first()?.attr("src") else {
      return nil
    }

    let regex = try NSRegularExpression(pattern: "/images/health(\\d).jpg", options: [])

    let match = regex.firstMatch(in: health, options: [], range: NSRange(location: 0, length: health.count))

    guard let healthRange = match?.range(at: 1) else {
      return nil
    }

    let healthString = health[Range(healthRange, in: health)!]

    return Int(String(healthString))
  }
}
