all: build test

build:
	@swiftc ./Compiler/main.swift ./Compiler/parser/*.swift ./Compiler/scanner/*.swift ./Compiler/extensions/*.swift -o imlCompiler

test:
	./imlCompiler ./TestSources/test-01.iml

