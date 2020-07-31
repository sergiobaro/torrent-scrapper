import TorrentScrapper

let torrentScrapper = TorrentScrapperFactory.makeRarbg()
try torrentScrapper.search(text: CommandLine.arguments.dropFirst().joined(separator: " "))


