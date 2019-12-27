#!/usr/bin/env bash

swift build
.build/debug/torrent-scrapper $@
