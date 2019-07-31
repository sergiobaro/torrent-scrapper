import Foundation

public class TorrentScrapperFactory {

  public static func makeTorlock() -> TorrentScrapper {
    return TorrentScrapper(
      provider: Torlock(),
      logger: TerminalTorrentLogger()
    )
  }
}
