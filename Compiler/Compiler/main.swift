import Foundation

func main() {
	print("🔴 IML-S Compiler 🐵🙈")
	
	let scanner: Scanner = Scanner()
	scanner.debugContent =
		"hello = 1 \n" +
		"a = true \n" +
		"\n\n\n\n" +
		"trolo = 888890009"
	print("🔴 Scanner.scan()")
	scanner.scan("")
	
}

main()



