import SwiftUI



class  ContinuationNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch {
            throw error
        }
    }
    
    func getDataContinuation(url: URL) async throws -> Data {
        
        return try await withCheckedThrowingContinuation { continuation in
            // .dataTask is an older API that is not async
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                // Only resume a continuation once
                continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }.resume()
        }
    }
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5 ) {
            completionHandler(UIImage(systemName: "face.smiling.inverse")!)
        }
    }
    
    func getFaceImageFromDatabase() async -> UIImage {
        return await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
                
            }
            
        }
    }
}

class ContinuationViewModel: ObservableObject {
    
    let urlString = "https://picsum.photos/300"
    
    @Published var image: UIImage? = nil
    let networkManager = ContinuationNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: urlString) else { return }
        
        do {
            let data = try await networkManager.getDataContinuation(url: url)
            
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error)
        }
    }
    
    func getHeartImage() async {
        self.image =  await networkManager.getFaceImageFromDatabase()
    }
}

struct ContinuationView: View {
    
    @StateObject private var viewModel = ContinuationViewModel()
    
    var body: some View {
        
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .background(.red)
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.getHeartImage()
        }
        
    }
}

struct ContinuationView_Previews: PreviewProvider {
    static var previews: some View {
        ContinuationView()
    }
}
