import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject private var viewModel = EchoRealmViewModel()
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("EchoRealm")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(.linearGradient(colors: [.white, .white.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                    
                    Text("Step back into your memories")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                
                Button(action: {
                    // Start SharePlay session
                }) {
                    Image(systemName: "shareplay")
                        .font(.system(size: 24))
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.bordered)
                .clipShape(Circle())
                
                PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding(40)
            .background(.ultraThinMaterial)
            
            ScrollView {
                VStack(spacing: 40) {
                    if let image = viewModel.selectedImage {
                        mainPreviewSection(image: image)
                    } else {
                        emptyStateSection()
                    }
                    
                    Divider()
                        .padding(.horizontal, 40)
                    
                    timelineSection()
                }
                .padding(.vertical, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: viewModel.selectedItem) { newItem in
            viewModel.handlePhotoSelection(newItem)
        }
    }
    
    @ViewBuilder
    private func mainPreviewSection(image: UIImage) -> some View {
        VStack(spacing: 30) {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 600, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                if viewModel.isGenerating {
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        .frame(width: 600, height: 400)
                    
                    VStack(spacing: 20) {
                        ProgressView(value: viewModel.generationProgress)
                            .progressViewStyle(.circular)
                            .scaleEffect(2)
                        Text("Reconstructing 3D World...")
                            .font(.headline)
                    }
                }
            }
            
            HStack(spacing: 25) {
                Button(action: {
                    Task {
                        await viewModel.generateQuickSplat()
                        await openImmersiveSpace(id: "ImmersiveRealm")
                    }
                }) {
                    HStack {
                        Image(systemName: "arkit")
                        Text("Enter Realm")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isGenerating)
                
                Button(action: {
                    Task {
                        await viewModel.enhanceWithMarble()
                    }
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text(viewModel.isEnhanced ? "Enhanced with Marble" : "Enhance with Marble")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isGenerating || viewModel.isEnhanced)
                .tint(.purple)
            }
        }
    }
    
    @ViewBuilder
    private func emptyStateSection() -> some View {
        PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
            VStack(spacing: 20) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 80))
                    .foregroundStyle(.secondary)
                
                Text("Pick a photo to begin your journey")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 600, height: 400)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func timelineSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recent Memories")
                .font(.title)
                .bold()
                .padding(.horizontal, 40)
            
            MemoryTimelineView()
        }
    }
}

// Helper for blur effect (visionOS has native blurs, but this is a common pattern)
import SwiftUI

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
