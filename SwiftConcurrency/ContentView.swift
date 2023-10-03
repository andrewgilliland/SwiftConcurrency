import SwiftUI

// Swiftful Thinking - Swift Concurrency Playlist
// https://www.youtube.com/playlist?list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM



struct ContentView: View {
    var body: some View {
        NavigationView {
            
            List {
                NavigationLink("Do, Catch, Try, Throws", destination: DoCatchTryThrowsView())
                NavigationLink("TaskGroup", destination: TaskGroupView())
                NavigationLink("Continuation", destination: ContinuationView())
                NavigationLink("Actors", destination: ActorsView())
                NavigationLink("Global Actor", destination: GlobalActorView())
                NavigationLink("Sendable", destination: SendableView())
                NavigationLink("AsyncPublisher", destination: AsyncPublisherView())
                NavigationLink("[Strong] & [Weak] References", destination: ReferencesView())
            }
            .navigationTitle("Swift Concurrency")
        }
        .preferredColorScheme(.dark)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
