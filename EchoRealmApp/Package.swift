// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EchoRealm",
    platforms: [
        .visionOS(.v1)
    ],
    products: [
        .library(name: "EchoRealm", targets: ["EchoRealmApp"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EchoRealmApp",
            path: ".",
            exclude: [],
            sources: [
                "EchoRealmApp.swift", 
                "ContentView.swift", 
                "RealitySceneView.swift",
                "Services",
                "Rendering",
                "Views",
                "Models"
            ],
            resources: []
        )
    ]
)
