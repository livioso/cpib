import Foundation

func main() {
	print("🔴 IML-S Compiler 🐵🙈")
	
	var scanner: Scanner = Scanner()
	scanner.debugContent =
		"hello = 1 \n" +
		"a = hellof \n" +
		"\n\n\n\n" +
		"trolo = 888890009"
	print("🔴 Scanner.scan()")
	scanner.scan("")
	
}

main()



