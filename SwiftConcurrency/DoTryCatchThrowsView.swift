import SwiftUI

class DoCatchTryThrowsDataManager {
    
    func getTitle() -> String {
        return "Title from data manager."
    }
}

class DoCatchTryThrowsViewModel: ObservableObject {
    
    @Published var text: String = "Starting text from view model."
    let manager = DoCatchTryThrowsDataManager()
    
    func fetchTitle() {
        let newTitle = manager.getTitle()
        self.text = newTitle
    }
}

struct DoTryCatchThrowsView: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width:300, height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoTryCatchThrowsView_Previews: PreviewProvider {
    static var previews: some View {
        DoTryCatchThrowsView()
    }
}
