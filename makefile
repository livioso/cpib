all: prepare build_vm build_compiler

clean:
	@rm -rf ./bin/

prepare:
	@mkdir -p ./bin/vm
	@mkdir -p ./bin/compiler
	@mkdir -p ./bin/intermediate

build_compiler: prepare
	@echo "Compiling compiler..."
	@xcrun -sdk macosx swiftc\
		./Compiler/Compiler/*.swift \
		./Compiler/Compiler/parser/*.swift \
		./Compiler/Compiler/scanner/*.swift \
		./Compiler/Compiler/extensions/*.swift \
		./Compiler/Compiler/codegen/*.swift \
		./Compiler/Compiler/context/*.swift \
		-o ./bin/compiler/iml_compiler

build_vm: prepare
	@echo "Compiling vm..."
	@javac -nowarn \
		-d ./bin/vm \
		-sourcepath ./VirtualMachine/src/ \
		./VirtualMachine/src/*.java \
		./VirtualMachine/src/vm/*.java

run_test_example_1:
	@echo "-> Compiling example 1..."
	./bin/compiler/iml_compiler ./TestSources/test-01.iml ./bin/intermediate/test-01.intermediate
	@echo "-> Running example 1 on virtual machine..."
	@cd ./bin/vm/; \
		cat ../intermediate/test-01.intermediate | java Machine

run_test_example_2_should_fail:
	@echo "-> Compiling example 2 (error)..."
	./bin/compiler/iml_compiler ./TestSources/test-02-error.iml ./bin/intermediate/test-02.intermediate

run_test_example_3:
	@echo "-> Compiling example 3..."
	./bin/compiler/iml_compiler ./TestSources/test-03.iml ./bin/intermediate/test-03.intermediate
	@echo "-> Running example 3 on virtual machine..."
	@cd ./bin/vm/; \
		cat ../intermediate/test-03.intermediate | java Machine

run_test_example_4:
	@echo " -> Compiling example 4..."
	./bin/compiler/iml_compiler ./TestSources/test-04.iml ./bin/intermediate/test-04.intermediate
	@echo " -> Running example 4 on virtual machine..."
	@cd ./bin/vm/; \
		cat ../intermediate/test-04.intermediate | java Machine

run_test_example_5:
	@echo " -> Compiling example 5..."
	./bin/compiler/iml_compiler ./TestSources/test-05.iml ./bin/intermediate/test-05.intermediate
	@echo " -> Running example 5 on virtual machine..."
	@cd ./bin/vm/; \
		cat ../intermediate/test-05.intermediate | java Machine

run_test_example_6_should_fail:
	@echo " -> Compiling example 6 (error)..."
	./bin/compiler/iml_compiler ./TestSources/test-06-error.iml ./bin/intermediate/test-06-error.intermediate
	@echo " -> Running example 6 on virtual machine..."
	@cd ./bin/vm/; \
		cat ../intermediate/test-06-error.intermediate | java Machine

run_test_example_6:
	@echo " -> Compiling example 6..."
	./bin/compiler/iml_compiler ./TestSources/test-06.iml ./bin/intermediate/test-06.intermediate
	@echo " -> Running example 6 on virtual machine..."
	@cd ./bin/vm/; \
		cat ../intermediate/test-06.intermediate | java Machine

run_test_virtualmachine:
	@cp ./TestSources/*.intermediate ./bin/intermediate/
	@cd ./bin/vm/; \
		cat ../intermediate/test-virtualmachine.intermediate | java Machine
