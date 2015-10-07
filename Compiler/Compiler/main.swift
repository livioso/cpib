//
//  main.swift
//  Compiler
//
//  Created by Livio Bieri on 30/09/15.
//  Copyright (c) 2015 Livio Bieri. All rights reserved.
//

import Foundation

print("IML Compiler 👻")

var terminal = Terminal.IDENT
print(terminal)
print(terminal)


var scanner: ScannerStateMachine = ScannerStateMachine()
var characters: [Character] = Array("a = 921".characters)
scanner.scan(characters)

var c: Character = "a"
print(" isLiteral \(c.isLiteral())")
c = "Z"
print(" isLiteral \(c.isLiteral())")
c = ";"
print(" isLiteral \(c.isLiteral())")
c = "."
print(" isLiteral \(c.isLiteral())")



//scanner.scan("~/Dropbox/FHNW/cpib/__underconstruction/cpib-github/Compiler/TestSources/test-01.iml")

