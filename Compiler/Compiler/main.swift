import Foundation

func main() {
	print("🔴 IML-S Compiler 🐵🙈")
	let scanner: Scanner = Scanner()
	scanner.debugContent = "a = 1 \n b = a \n c = true \n b = 111"
	print("🔴 Scanner.scan()")
	scanner.scan("")
}

main()



