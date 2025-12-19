import SwiftUI
import RealityKit

@main
struct EchoRealmApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 800, height: 600, depth: 0.1, in: .meters)

        ImmersiveSpace(id: "ImmersiveRealm") {
            ImmersiveRealmView()
        }
    }
}

/// Minimal placeholder immersive content so `openImmersiveSpace(id:)` succeeds.
struct ImmersiveRealmView: View {
    var body: some View {
        RealityView { content in
            // Add a simple floating text entity as a placeholder
            let mesh = MeshResource.generateText("EchoRealm", extrusionDepth: 0.02, font: .systemFont(ofSize: 0.2), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
            let material = SimpleMaterial(color: .blue, isMetallic: true)
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.position = [0, 1.4, -1.5]
            content.add(entity)
        }
    }
}
