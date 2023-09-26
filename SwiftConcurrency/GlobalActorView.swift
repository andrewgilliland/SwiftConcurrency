import SwiftUI

// Can be struct or final class
@globalActor final class GlobalActor {
    
    static var shared = DataManager()
}

actor DataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five", "Six"]
    }
}

// You can mark a class as being on the MainActor so all properties and methods are only updated on the Main Thread
@MainActor class GlobalActorViewModal: ObservableObject {

    // @MainActor makes sure this value is only updated on the Main Thread since it is updating the UI
    @MainActor @Published var dataArray: [String] = []
    let manager = GlobalActor.shared
    
    @GlobalActor func getData() {
        
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run(body: {
                self.dataArray = data
            })
        }
    }
}

struct GlobalActorView: View {
    
    @StateObject private var viewModal = GlobalActorViewModal()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModal.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModal.getData()
        }
    }
}

struct GlobalActorView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorView()
    }
}
