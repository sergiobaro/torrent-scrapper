import Foundation

protocol TorrentLogger {

  func log(_ string: String)
}

class TerminalTorrentLogger: TorrentLogger {

  func log(_ string: String) {
    print(" * " + string)
  }
}
