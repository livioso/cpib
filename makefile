all: prepare build_vm build_compiler

clean:
	@rm -rf ./bin/

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

compile_example_1:
	@echo "Compiling example 1..."
	./bin/compiler/iml_compiler ./TestSources/test-01.iml

compile_example_2:
	@echo "Compiling example 2..."
	./bin/compiler/iml_compiler ./TestSources/test-02-error.iml

run_example_1:
	@echo "Running example 1..."
	@cd ./bin/vm
	@cat ./bin/intermediate/example1.intermediate | java Machine

run_example_vmtest:
	@echo "$ cat ../intermediate/vmtest.intermediate | java Machine"
	@touch ./bin/intermediate/vmtest.intermediate
	@echo "0, AllocBlock 5," > ./bin/intermediate/vmtest.intermediate
	@echo "1, AllocBlock 5," >> ./bin/intermediate/vmtest.intermediate
	@echo "2, Stop" >> ./bin/intermediate/vmtest.intermediate
	@cd ./bin/vm/; \
		cat ../intermediate/vmtest.intermediate | java Machine
