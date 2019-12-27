import Foundation

public class TorrentScrapperFactory {

  public static func makeTorlock() -> TorrentScrapper {
    return TorrentScrapper(
      provider: Torlock(),
      logger: TerminalTorrentLogger()
    )
  }
  
  public static func makeRarbg() -> TorrentScrapper {
    return TorrentScrapper(
      provider: Rarbg(),
      logger: TerminalTorrentLogger()
    )
  }
  
  public static func makeMagnetTdl() -> TorrentScrapper {
    return TorrentScrapper(
      provider: MagnetTdl(),
      logger: TerminalTorrentLogger()
    )
  }
}
