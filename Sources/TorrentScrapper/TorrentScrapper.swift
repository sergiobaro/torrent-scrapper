import Foundation
import SwiftSoup

public struct TorrentResult {
  let name: String
  let link: String
  let added: Date
  let size: Int
  let seeds: Int
  let peers: Int
  let health: Int
}

public enum TorrentError: Error {
  case invalidUrl(String)
}

protocol TorrentProvider {

  func search(text: String) throws -> URL
  func parse(doc: Document) throws -> [TorrentResult]

}

public class TorrentScrapper {

  private let provider: TorrentProvider

  init(provider: TorrentProvider) {
    self.provider = provider
  }

  public func search(text: String) throws -> [TorrentResult] {
    let url = try self.provider.search(text: text)
    let html = try String(contentsOf: url)
    let doc = try SwiftSoup.parse(html)

    return try self.provider.parse(doc: doc)
  }

}
