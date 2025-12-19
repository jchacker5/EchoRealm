import SwiftUI

struct RealmMemory: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let image: String // System image or thumbnail
}

struct MemoryTimelineView: View {
    let memories: [RealmMemory] = [
        RealmMemory(title: "Grandpa's Garden", date: Date().addingTimeInterval(-86400 * 365), image: "leaf.fill"),
        RealmMemory(title: "Beach House 2010", date: Date().addingTimeInterval(-86400 * 500), image: "sun.max.fill"),
        RealmMemory(title: "First Steps", date: Date().addingTimeInterval(-86400 * 1000), image: "figure.walk")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(memories) { memory in
                    VStack {
                        Image(systemName: memory.image)
                            .font(.system(size: 60))
                            .frame(width: 150, height: 150)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                        
                        Text(memory.title)
                            .font(.headline)
                        Text(memory.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding()
        }
    }
}

#Preview {
    MemoryTimelineView()
}
