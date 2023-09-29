import SwiftUI

final class ReferencesDataService {
    
    func getData() async -> String {
        "Update data!"
    }
}

final class ReferencesViewModel: ObservableObject {
    
    @Published var data: String = "Some title!"
    let dataService = ReferencesDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    func implicitUpdateData() {
        Task {
            // This implies a strong reference to the var "data"
            data = await dataService.getData()
        }
    }
    
    func explicitUpdateData() {
        Task {
            // This is an explicit strong reference to the var "data"
            self.data = await self.dataService.getData()
        }
    }
    
    func moreExplicitUpdateData() {
        Task { [self] in
            // This is an even more explicit strong reference to the var "data"
            self.data = await self.dataService.getData()
        }
    }
    
    func weakUpdateData() {
        Task { [weak self] in
            // This is an implicit weak reference to the var "data"
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }
    
    // We don't need to manage weak/strong
    // We can mange the Task!
    func updateData() {
        someTask = Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // We can manage the Task
    func updateMultipleData() {
        let firstTask = Task {
            self.data = await self.dataService.getData()
        }
        tasks.append(firstTask)
        
        let secondTask = Task {
            self.data = await self.dataService.getData()
        }
        tasks.append(secondTask)
    }
    
    // We purposely do not cancel tasks to keep strong references
    func updateDetatchedData() {
        Task {
            self.data = await self.dataService.getData()
        }
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }
    
    // See task modifier
    func viewManagedUpdateData() async {
        self.data = await self.dataService.getData()
    }
}

struct ReferencesView: View {
    
    @StateObject private var viewModel = ReferencesViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.implicitUpdateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
            .task {
                // This task is managed by the SwiftUI View
                // The task will automatically cancel
                // We don't have to hold a reference to the task
                await viewModel.viewManagedUpdateData()
            }
    }
}

struct ReferencesView_Previews: PreviewProvider {
    static var previews: some View {
        ReferencesView()
    }
}
