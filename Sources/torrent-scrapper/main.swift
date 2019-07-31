import TorrentScrapper

let torlock = TorrentScrapperFactory.makeTorlock()
try torlock.search(text: CommandLine.arguments.dropFirst().joined(separator: " "))


