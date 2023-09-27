import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: UserInfoClass) {
        
    }
    
}

// Sendable protocol marks this struct as thread safe
// The Sendable protocol indicates that value of the given type can be safely used in concurrent code.
struct UserInfo: Sendable {
    let name: String
}

// @unchecked Sendable - compiler does not show warning for mutable property/properties, but not good practice
final class UserInfoClass: @unchecked Sendable {
    // You will get a warning if this is 'var' or mutable
    private var name: String
    let queue = DispatchQueue(label: "com.MyApp.UserInfoClass")
    
    init(name: String) {
        self.name = name
    }
    
    // Way to update the name in a class and make it thread safe
    // requires a queue
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableViewModel: ObservableObject {
    
    let manager = CurrentUserManager()

    func updateCurrentUserInfo() async {
        
        let info = UserInfoClass(name: "Biff")
        
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableView: View {
    
    @StateObject private var viewModel = SendableViewModel()
    
    var body: some View {
        Text("Sendable")
    }
}

struct SendableView_Previews: PreviewProvider {
    static var previews: some View {
        SendableView()
    }
}
