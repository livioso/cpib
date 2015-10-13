import Foundation

func main() {
	print("🔴 IML-S Compiler 🐵🙈")
	if let sourcePath = Process.arguments.last {
		let scanner: Scanner = Scanner()
		//scanner.debugContent = "a = 1 \n b = a \n c = true \n b = 111"
		scanner.scan(sourcePath)
		print("🔴 Scanner.scan(\(sourcePath))")
		scanner.scan("")
	} else {
		print("Missing Parameter <source.iml>")
	}
}

main()



