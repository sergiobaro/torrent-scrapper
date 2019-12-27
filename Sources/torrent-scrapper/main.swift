import TorrentScrapper

let torlock = TorrentScrapperFactory.makeMagnetTdl()
try torlock.search(text: CommandLine.arguments.dropFirst().joined(separator: " "))


