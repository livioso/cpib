//
//  main.swift
//  Compiler
//
//  Created by Livio Bieri on 30/09/15.
//  Copyright (c) 2015 Livio Bieri. All rights reserved.
//

import Foundation

print("IML Compiler 👻")

var terminal = Terminal.COMMENT
print(terminal)
print(terminal.rawValue)

var scanner = Scanner()
scanner.scan("~/Dropbox/FHNW/cpib/__underconstruction/cpib-github/Compiler/TestSources/test-01.iml")

