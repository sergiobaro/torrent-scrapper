import Foundation
import SwiftSoup

public struct TorrentResult {
  let name: String
  let detailPageURL: URL?
  let magnetURL: URL?
}

public enum TorrentError: Error {
  case invalidUrl(String)
}

protocol TorrentProvider {
  func searchURL(text: String) throws -> URL?
  func parseList(doc: Document) throws -> [TorrentResult]
  func parseDetail(doc: Document) throws -> TorrentResult?
}

public class TorrentScrapper {

  private let provider: TorrentProvider
  private let logger: TorrentLogger

  init(provider: TorrentProvider, logger: TorrentLogger) {
    self.provider = provider
    self.logger = logger
  }

  public func search(text: String) throws {
    guard let url = try self.provider.searchURL(text: text) else {
      self.logger.log("Empty search.")
      return
    }

    self.logger.log("Search: " + text)

    let document = try self.downloadPage(url: url)

    let torrents = try self.provider.parseList(doc: document)
    if torrents.isEmpty {
      self.logger.log("No torrent found.")
      return
    }

    self.logger.log("Found \(torrents.count) torrents.")

    for torrent in torrents {
      self.logger.log("Found: " + torrent.name)
      try self.processDetail(result: torrent)
    }
  }
}

// MARK: Private
extension TorrentScrapper {

  private func processDetail(result: TorrentResult) throws {
    // magnet link
    if let magnetURL = result.magnetURL {
      self.logger.log("Opening magnet link")
      self.shell("open", magnetURL.absoluteString)

      return
    }

    // detail page
    if let detailPageURL = result.detailPageURL {
      let detailDoc = try self.downloadPage(url: detailPageURL)
      guard let detailResult = try self.provider.parseDetail(doc: detailDoc) else {
        self.logger.log("No detail found.")
        return
      }

      try self.processDetail(result: detailResult)
    }
  }

  @discardableResult
  private func shell(_ args: String...) -> Int32 {
    let task = Process()

    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()

    return task.terminationStatus
  }

  private func downloadPage(url: URL) throws -> Document {
    self.logger.log("Downloading: \(url.absoluteString)")

    let html = try String(contentsOf: url)
    return try SwiftSoup.parse(html)
  }
}
