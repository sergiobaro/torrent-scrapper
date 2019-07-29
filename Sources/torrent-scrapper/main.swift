import TorrentScrapper


let torlock = TorrentScrapperFactory.makeTorlock()

_ = try torlock.search(text: "euphoria")
