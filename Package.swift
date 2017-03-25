import PackageDescription

let package = Package(
    name: "SwiftyNinja",
    targets: [
		Target(name: "SwiftyNinjaREPL", dependencies: ["SwiftyNinjaLib", "SwiftyNinjaLang"]),
		Target(name: "SwiftyNinjaLib", dependencies: ["SwiftyNinjaLang", "SwiftyNinjaRuntime"]),
		Target(name: "SwiftyNinjaLang", dependencies: ["SwiftyNinjaUtils"]),
		Target(name: "SwiftyNinjaUtils"),
		Target(name: "SwiftyNinjaRuntime", dependencies: ["SwiftyNinjaLang"])
	]
)
