#! /bin/bash

iconv -t utf-8 cpib_HS-2015_TeamBB_SB_V1.markdown | pandoc --highlight-style=tango -o cpib_HS-2015_TeamBB_SB_V1.pdf | iconv -f utf-8

