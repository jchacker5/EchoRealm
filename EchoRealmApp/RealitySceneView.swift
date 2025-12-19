import SwiftUI
import RealityKit
import RealityKitContent

struct RealitySceneView: View {
    @State private var splatEntity: Entity?
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        RealityView { content in
            // Initial scene setup
            let rootAnchor = AnchorEntity(world: .zero)
            content.add(rootAnchor)
            
            // Logically, we would load the splat here mapping to the view model's current realm
            Task {
                // For demo, we play a "Nostalgia" ambient track
                SoundService.shared.playAmbientSound(for: "Nostalgic Home")
                
                // Load the Gaussian Splat Entity
                // let splat = try? await SplatRenderer.shared.loadSplat(from: someURL)
                // rootAnchor.addChild(splat)
                
                // Placeholder visual for the "World"
                let worldModel = ModelEntity(
                    mesh: .generateSphere(radius: 2.0),
                    materials: [UnlitMaterial(color: .black.withAlphaComponent(0.1))]
                )
                worldModel.components.set(InputTargetComponent())
                worldModel.generateCollisionShapes(recursive: true)
                rootAnchor.addChild(worldModel)
                
                await MainActor.run {
                    self.splatEntity = worldModel
                }
            }
        } update: { content in
            // Handle updates if needed
        }
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    // 6DoF movement simulation
                    let translation = value.convert(value.translation3D, from: .local, to: .scene)
                    value.entity.position += translation
                }
        )
        .gesture(
            MagnifyGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    // "Pinch to zoom/scale" depth
                    let scale = Float(value.magnification)
                    value.entity.scale = [scale, scale, scale]
                }
        )
        .onDisappear {
            // Stop sound when exiting realm
            print("Exiting realm...")
        }
    }
}

#Preview(immersionStyle: .full) {
    RealitySceneView()
}
