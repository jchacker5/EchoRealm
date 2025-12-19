import SwiftUI

@main
struct EchoRealmApp: App {
    @State private var immersionStyle: ImmersionStyle = .full
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.0, height: 1.0, depth: 1.0, in: .meters)

        ImmersiveSpace(id: "ImmersiveRealm") {
            RealitySceneView()
        }
        .immersionStyle(selection: $immersionStyle, in: .full, .mixed)
    }
}
