all: prepare build_vm build_compiler

prepare:
	@mkdir -p ./bin/vm
	@mkdir -p ./bin/compiler
	@mkdir -p ./bin/intermediate

build_compiler: prepare
	@echo "Compiling compiler..."
	@swiftc \
		./Compiler/Compiler/main.swift \
		./Compiler/Compiler/parser/*.swift \
		./Compiler/Compiler/scanner/*.swift \
		./Compiler/Compiler/extensions/*.swift \
		-o ./bin/compiler/iml_compiler

build_vm: prepare
	@echo "Compiling vm..."
	@javac -nowarn \
		-d ./bin/vm \
		-sourcepath ./VirtualMachine/src/ \
		./VirtualMachine/src/*.java \
		./VirtualMachine/src/vm/*.java

run_example_1:
	@echo "Running example 1..."
	./bin/compiler/iml_compiler ./TestSources/test-01.iml

run_example_2:
	@echo "Running example 2..."
	./bin/compiler/iml_compiler ./TestSources/test-02-error.iml
