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
		./Compiler/Compiler/*.swift \
		./Compiler/Compiler/parser/*.swift \
		./Compiler/Compiler/scanner/*.swift \
		./Compiler/Compiler/extensions/*.swift \
		./Compiler/Compiler/codegen/*.swift \
		-o ./bin/compiler/iml_compiler

build_vm: prepare
	@echo "Compiling vm..."
	@javac -nowarn \
		-d ./bin/vm \
		-sourcepath ./VirtualMachine/src/ \
		./VirtualMachine/src/*.java \
		./VirtualMachine/src/vm/*.java

compile_example_1:
	@echo "Compilinng example 1..."
	./bin/compiler/iml_compiler ./TestSources/test-01.iml ./bin/intermediate/test-01.intermediate

compile_example_2:
	@echo "Compiling example 2..."
	./bin/compiler/iml_compiler ./TestSources/test-02-error.iml ./bin/intermediate/test-02.intermediate

compile_example_4:
	@echo "Compiling example 4..."
	./bin/compiler/iml_compiler ./TestSources/test-04.iml ./bin/intermediate/test-04.intermediate

run_example_vmtest:
	@cp ./TestSources/*.intermediate ./bin/intermediate/
	@cd ./bin/vm/; \
		cat ../intermediate/test-virtualmachine.intermediate | java Machine
