import SwiftUI
import PhotosUI

class EchoRealmViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var isGenerating: Bool = false
    @Published var generationProgress: Double = 0.0
    @Published var currentRealmID: String?
    @Published var isEnhanced: Bool = false
    
    func handlePhotoSelection(_ item: PhotosPickerItem?) {
        Task {
            if let data = try? await item?.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run {
                    self.selectedImage = image
                    self.isGenerating = false
                    self.isEnhanced = false
                }
            }
        }
    }
    
    func generateQuickSplat() async {
        guard let image = selectedImage else { return }
        
        await MainActor.run {
            isGenerating = true
            generationProgress = 0.1
        }
        
        do {
            // Simulate progress
            for i in 2...9 {
                try await Task.sleep(nanoseconds: 100_000_000)
                await MainActor.run { generationProgress = Double(i) / 10.0 }
            }
            
            let url = try await SharpService.shared.generateSplat(from: image)
            
            await MainActor.run {
                isGenerating = false
                currentRealmID = url.lastPathComponent
            }
        } catch {
            print("Generation failed: \(error)")
            await MainActor.run { isGenerating = false }
        }
    }
    
    func enhanceWithMarble() async {
        guard let image = selectedImage else { return }
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        await MainActor.run { isGenerating = true }
        
        do {
            let realmID = try await MarbleService.shared.enhanceWorld(source: data)
            await MainActor.run {
                self.currentRealmID = realmID
                self.isEnhanced = true
                self.isGenerating = false
            }
        } catch {
            print("Marble enhancement failed: \(error)")
            await MainActor.run { isGenerating = false }
        }
    }
}
