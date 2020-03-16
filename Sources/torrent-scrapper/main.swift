import TorrentScrapper

let torlock = TorrentScrapperFactory.makeRarbg()
try torlock.search(text: CommandLine.arguments.dropFirst().joined(separator: " "))


