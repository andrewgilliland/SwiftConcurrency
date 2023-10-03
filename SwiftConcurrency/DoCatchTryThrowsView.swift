import SwiftUI

class DoCatchTryThrowsDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("Title from data manager.", nil )
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getResult() -> Result<String, Error> {
        if isActive {
            return .success("Result returned from data manager.")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getResultThrows() throws -> String {
        print("getResulsThrows")
        if isActive {
            return "Result returned from data manager. (getResultThrows)"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getResultThrowsAgain() throws -> String {
        print("getResulsThrows")
        if isActive {
            return "Result returned from data manager. (getResultThrowsAgain)"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsViewModel: ObservableObject {
    
    @Published var text: String = "Starting text from view model."
    let manager = DoCatchTryThrowsDataManager()
    
    func fetchTitle() {
        print("fetchTitle")
//        let returnedValue = manager.getTitle()
//        if let newTitle = returnedValue {
//            self.text = newTitle
//        } else if let error = returnedValue.error {
//            self.text = error.localizedDescription
//        }

//        let result = manager.getResult()
//        
//        switch result {
//        case .success(let newTitle):
//            self.text = newTitle
//        case .failure(let error):
//            self.text = error.localizedDescription
//        }

        // Optional try - if error comes back, it sets the value to nil
//        let title = try? manager.getResultThrows()
//        if let successTitle = title {
//            self.text = successTitle
//        }

        // Explicit try - don't resort to this
//        let title = try! manager.getResultThrows()
//        if let successTitle = title {
//            self.text = successTitle
//        }
        
        do {
            // If try fails then code immediately goes to the catch block
            // Optional try - won't throw it out of the do block if an error occurs
            let newTitle = try? manager.getResultThrows()
            self.text = newTitle

            let newerTitle = try manager.getResultThrowsAgain()
            self.text = newerTitle
        } catch let error {
            print(error)
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsView: View {
    
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
        DoCatchTryThrowsView()
    }
}
