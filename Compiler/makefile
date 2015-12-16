all: build test1

build:
	@swiftc ./Compiler/main.swift ./Compiler/parser/*.swift ./Compiler/scanner/*.swift ./Compiler/extensions/*.swift -o imlCompiler

test1:
	./imlCompiler ./TestSources/test-01.iml

test2:
	./imlCompiler ./TestSources/test-02-error.iml
