import SwiftUI

actor AsyncPublisherDataManager {
    
    @Published var data: [String] = []
    
    func insertData() async {
        data.append("Grapes")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("Banana")
        data.append("Mango")
        data.append("Dragonfruit")
    }
}

class AsyncPublisherViewModel: ObservableObject {
    
    @Published var datas: [String] = []
    let manager = AsyncPublisherDataManager()
    
    func start() async {
        await manager.insertData()
        datas = await manager.data
    }
}

struct AsyncPublisherView: View {
    
    @StateObject private var viewModel = AsyncPublisherViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.datas, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

struct AsyncPublisherView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherView()
    }
}
