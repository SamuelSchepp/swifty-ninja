import PackageDescription

let package = Package(
    name: "SwiftyNinja",
    targets: [
		Target(name: "SwiftyNinjaLib"),
		Target(name: "SwiftyNinjaREPL", dependencies: ["SwiftyNinjaLib"])
	]
)
