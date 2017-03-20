import PackageDescription

let package = Package(
    name: "SwiftyNinja",
    targets: [
		Target(name: "SwiftyLib"),
		Target(name: "SwiftyApp", dependencies: ["SwiftyLib"])
	]
)
