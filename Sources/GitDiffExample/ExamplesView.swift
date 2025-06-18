import SwiftUI
import gitdiff

struct ExamplesView: View {
    @State private var selectedExample = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Example", selection: $selectedExample) {
                    Text("Simple").tag(0)
                    Text("Rename").tag(1)
                    Text("New File").tag(2)
                    Text("Deleted").tag(3)
                    Text("Binary").tag(4)
                    Text("Large").tag(5)
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView {
                    DiffRenderer(diffText: SampleDiffs.allDiffs[selectedExample])
                        .padding()
                }
            }
            .navigationTitle("Diff Examples")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SampleDiffs {
    static let allDiffs = [
        simpleChanges,
        fileRename,
        newFile,
        deletedFile,
        binaryFile,
        largeDiff
    ]
    
    static let simpleChanges = """
    diff --git a/ContentView.swift b/ContentView.swift
    index 1234567..abcdefg 100644
    --- a/ContentView.swift
    +++ b/ContentView.swift
    @@ -10,14 +10,16 @@ import SwiftUI
     
     struct ContentView: View {
         @State private var counter = 0
    +    @State private var message = "Hello"
         
         var body: some View {
             VStack {
    -            Text("Count: \\(counter)")
    +            Text("\\(message): \\(counter)")
                     .font(.largeTitle)
    +                .foregroundColor(.blue)
                 
                 Button("Increment") {
    -                counter += 1
    +                withAnimation { counter += 1 }
                 }
                 .buttonStyle(.borderedProminent)
             }
    """
    
    static let fileRename = """
    diff --git a/OldName.swift b/NewName.swift
    similarity index 95%
    rename from OldName.swift
    rename to NewName.swift
    index 1234567..abcdefg 100644
    --- a/OldName.swift
    +++ b/NewName.swift
    @@ -1,8 +1,8 @@
     //
    -//  OldName.swift
    +//  NewName.swift
     //  MyProject
     //
     
    -struct OldName {
    +struct NewName {
         let id: UUID
         let title: String
     }
    """
    
    static let newFile = """
    diff --git a/NewFeature.swift b/NewFeature.swift
    new file mode 100644
    index 0000000..1234567
    --- /dev/null
    +++ b/NewFeature.swift
    @@ -0,0 +1,15 @@
    +//
    +//  NewFeature.swift
    +//  MyProject
    +//
    +
    +import Foundation
    +
    +struct NewFeature {
    +    let id = UUID()
    +    let name: String
    +    
    +    func activate() {
    +        print("Feature \\(name) activated")
    +    }
    +}
    """
    
    static let deletedFile = """
    diff --git a/DeprecatedCode.swift b/DeprecatedCode.swift
    deleted file mode 100644
    index 1234567..0000000
    --- a/DeprecatedCode.swift
    +++ /dev/null
    @@ -1,20 +0,0 @@
    -//
    -//  DeprecatedCode.swift
    -//  MyProject
    -//
    -
    -import Foundation
    -
    -@available(*, deprecated, message: "Use NewFeature instead")
    -struct DeprecatedCode {
    -    let id: String
    -    
    -    init() {
    -        self.id = UUID().uuidString
    -    }
    -    
    -    func oldMethod() {
    -        print("This method is deprecated")
    -    }
    -}
    """
    
    static let binaryFile = """
    diff --git a/Assets.xcassets/AppIcon.appiconset/icon.png b/Assets.xcassets/AppIcon.appiconset/icon.png
    index 1234567..abcdefg 100644
    Binary files a/Assets.xcassets/AppIcon.appiconset/icon.png and b/Assets.xcassets/AppIcon.appiconset/icon.png differ
    """
    
    static let largeDiff = """
    diff --git a/NetworkManager.swift b/NetworkManager.swift
    index 1234567..abcdefg 100644
    --- a/NetworkManager.swift
    +++ b/NetworkManager.swift
    @@ -15,8 +15,10 @@ class NetworkManager: ObservableObject {
         static let shared = NetworkManager()
         
         private let session: URLSession
    +    private let cache = URLCache.shared
         
         private init() {
    +        let config = URLSessionConfiguration.default
             self.session = URLSession.shared
         }
         
    @@ -25,18 +27,35 @@ class NetworkManager: ObservableObject {
             
             do {
                 let (data, response) = try await session.data(from: url)
    +            
    +            // Check response
    +            guard let httpResponse = response as? HTTPURLResponse,
    +                  httpResponse.statusCode == 200 else {
    +                throw NetworkError.invalidResponse
    +            }
    +            
                 return data
             } catch {
    -            throw NetworkError.requestFailed
    +            throw NetworkError.requestFailed(error)
             }
         }
         
    +    func fetchJSON<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
    +        let data = try await fetchData(from: url)
    +        
    +        do {
    +            return try JSONDecoder().decode(type, from: data)
    +        } catch {
    +            throw NetworkError.decodingFailed(error)
    +        }
    +    }
    +    
         enum NetworkError: Error {
             case invalidURL
    -        case requestFailed
    +        case invalidResponse
    +        case requestFailed(Error)
    +        case decodingFailed(Error)
         }
     }
    """
}