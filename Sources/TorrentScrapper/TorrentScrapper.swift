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

// MARK: - Private
private extension TorrentScrapper {

  func processDetail(result: TorrentResult) throws {
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
  func shell(_ args: String...) -> Int32 {
    let task = Process()

    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()

    return task.terminationStatus
  }

  func downloadPage(url: URL) throws -> Document {
    self.logger.log("Downloading: \(url.absoluteString)")
    
    let (data, _, _) = self.downloadPageSync(url: url)
    let html = String(data: data!, encoding: .utf8)!
    
    return try SwiftSoup.parse(html)
  }
  
  func downloadPageSync(url: URL) -> (Data?, URLResponse?, Error?) {
    var result: (Data?, URLResponse?, Error?)
    
    let semaphore = DispatchSemaphore(value: 0)
    
    var request = URLRequest(url: url)
    request.addValue("text/html", forHTTPHeaderField: "Accept")
    request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36", forHTTPHeaderField: "User-Agent")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      result = (data, response, error)
      semaphore.signal()
    }
    task.resume()
    
    semaphore.wait()
    
    return result
  }
}
