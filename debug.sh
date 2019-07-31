#!/usr/bin/env bash

swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.12"
.build/debug/torrent-scrapper $@