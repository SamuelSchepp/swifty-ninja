import PackageDescription

let package = Package(
    name: "SwiftyNinja",
    targets: [
		Target(name: "SwiftyNinjaREPL", dependencies: ["SwiftyNinjaLib"]),
		Target(name: "SwiftyNinjaLib", dependencies: ["SwiftyNinjaCore"]),
		Target(name: "SwiftyNinjaCore")
	]
)
