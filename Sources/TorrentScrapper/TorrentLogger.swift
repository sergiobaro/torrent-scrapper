import Foundation

protocol TorrentLogger {

  func info(_ message: String)
  func warn(_ message: String)
  func error(_ message: String)
}

class TerminalTorrentLogger: TorrentLogger {
  
  let colorfulLogger = ColorfulLogger()

  func info(_ message: String) {
    self.colorfulLogger.log(message: message)
  }
  
  func warn(_ message: String) {
    self.colorfulLogger.log(message: message, with: .yellow)
  }
  
  func error(_ message: String) {
    self.colorfulLogger.log(message: message, with: .red)
  }
}

class ColorfulLogger {
  
  enum Color: Int {
    case black = 30
    case red = 31
    case green = 32
    case yellow = 33
    case blue = 34
    case magenta = 35
    case cyan = 36
    case white = 37
  }
  
  func log(message: String, with color: Color? = nil) {
    print("\(string(with: color))\(message)")
  }
  
  private func string(with color: Color? = nil) -> String {
    guard let color = color else { return "" }
    return"\u{001B}[;\(color.rawValue)m"
  }
}
