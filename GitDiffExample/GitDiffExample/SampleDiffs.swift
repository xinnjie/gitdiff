//
//  SampleDiffs.swift
//  GitDiffExample
//
//  Created by Tornike Gomareli on 18.06.25.
//

import Foundation

struct SampleDiffs {
    static let miniDiff = """
    diff --git a/Hello.swift b/Hello.swift
    @@ -1,3 +1,3 @@
    -print("Hello")
    +print("Hello, World!")
     // End of file
    """
    
    static let simpleChanges = """
    diff --git a/ContentView.swift b/ContentView.swift
    index 1234567..abcdefg 100644
    --- a/ContentView.swift
    +++ b/ContentView.swift
    @@ -10,14 +10,16 @@ import SwiftUI
     
     struct ContentView: View {
         @State private var counter = 0
    +    @State private var message = "Hello, SwiftUI!"
         
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
    diff --git a/OldViewController.swift b/NewViewController.swift
    similarity index 95%
    rename from OldViewController.swift
    rename to NewViewController.swift
    index 1234567..abcdefg 100644
    --- a/OldViewController.swift
    +++ b/NewViewController.swift
    @@ -1,12 +1,12 @@
     //
    -//  OldViewController.swift
    +//  NewViewController.swift
     //  MyApp
     //
     
     import UIKit
     
    -class OldViewController: UIViewController {
    +class NewViewController: UIViewController {
         
         override func viewDidLoad() {
             super.viewDidLoad()
    -        setupOldUI()
    +        setupNewUI()
         }
     }
    """
    
    static let newFile = """
    diff --git a/NetworkService.swift b/NetworkService.swift
    new file mode 100644
    index 0000000..1234567
    --- /dev/null
    +++ b/NetworkService.swift
    @@ -0,0 +1,25 @@
    +//
    +//  NetworkService.swift
    +//  MyApp
    +//
    +
    +import Foundation
    +
    +class NetworkService {
    +    static let shared = NetworkService()
    +    
    +    private init() {}
    +    
    +    func fetchData(from url: URL) async throws -> Data {
    +        let (data, response) = try await URLSession.shared.data(from: url)
    +        
    +        guard let httpResponse = response as? HTTPURLResponse,
    +              httpResponse.statusCode == 200 else {
    +            throw NetworkError.invalidResponse
    +        }
    +        
    +        return data
    +    }
    +}
    +
    +enum NetworkError: Error {
    +    case invalidResponse
    +}
    """
    
    static let deletedFile = """
    diff --git a/LegacyCode.swift b/LegacyCode.swift
    deleted file mode 100644
    index 1234567..0000000
    --- a/LegacyCode.swift
    +++ /dev/null
    @@ -1,30 +0,0 @@
    -//
    -//  LegacyCode.swift
    -//  MyApp
    -//
    -
    -import Foundation
    -
    -@available(*, deprecated, message: "Use NetworkService instead")
    -class LegacyNetworking {
    -    
    -    func fetchDataOldWay(completion: @escaping (Data?, Error?) -> Void) {
    -        // Old implementation
    -        let url = URL(string: "https://api.example.com")!
    -        
    -        URLSession.shared.dataTask(with: url) { data, response, error in
    -            if let error = error {
    -                completion(nil, error)
    -                return
    -            }
    -            
    -            guard let data = data else {
    -                completion(nil, NSError(domain: "NoData", code: 0))
    -                return
    -            }
    -            
    -            completion(data, nil)
    -        }.resume()
    -    }
    -}
    """
    
    static let binaryFile = """
    diff --git a/Assets.xcassets/AppIcon.appiconset/icon.png b/Assets.xcassets/AppIcon.appiconset/icon.png
    index 1234567..abcdefg 100644
    Binary files a/Assets.xcassets/AppIcon.appiconset/icon.png and b/Assets.xcassets/AppIcon.appiconset/icon.png differ
    diff --git a/Resources/logo.pdf b/Resources/logo.pdf
    index 2345678..bcdefgh 100644
    Binary files a/Resources/logo.pdf and b/Resources/logo.pdf differ
    """
    
    static let largeDiff = """
    diff --git a/DataManager.swift b/DataManager.swift
    index 1234567..abcdefg 100644
    --- a/DataManager.swift
    +++ b/DataManager.swift
    @@ -15,8 +15,12 @@ import CoreData
     class DataManager: ObservableObject {
         static let shared = DataManager()
         
    -    let container: NSPersistentContainer
    +    private let container: NSPersistentContainer
    +    private let backgroundContext: NSManagedObjectContext
    +    
    +    @Published var items: [Item] = []
    +    @Published var isLoading = false
         
         private init() {
             container = NSPersistentContainer(name: "DataModel")
    @@ -26,45 +30,89 @@ class DataManager: ObservableObject {
                     fatalError("Core Data failed to load: \\(error.localizedDescription)")
                 }
             }
    +        
    +        backgroundContext = container.newBackgroundContext()
    +        setupNotifications()
    +        fetchItems()
         }
         
    -    func save() {
    +    private func setupNotifications() {
    +        NotificationCenter.default.addObserver(
    +            self,
    +            selector: #selector(contextDidSave),
    +            name: .NSManagedObjectContextDidSave,
    +            object: backgroundContext
    +        )
    +    }
    +    
    +    @objc private func contextDidSave(_ notification: Notification) {
    +        guard let context = notification.object as? NSManagedObjectContext,
    +              context == backgroundContext else { return }
    +        
    +        DispatchQueue.main.async {
    +            self.container.viewContext.mergeChanges(fromContextDidSave: notification)
    +            self.fetchItems()
    +        }
    +    }
    +    
    +    func save() async throws {
             let context = container.viewContext
             
             guard context.hasChanges else { return }
             
             do {
                 try context.save()
    -        } catch {
    -            print("Failed to save: \\(error)")
    +        } catch {
    +            context.rollback()
    +            throw DataError.saveFailed(error)
             }
         }
         
    -    func fetchItems() -> [Item] {
    +    func fetchItems() {
    +        isLoading = true
    +        
             let request = Item.fetchRequest()
             request.sortDescriptors = [NSSortDescriptor(keyPath: \\Item.timestamp, ascending: false)]
             
             do {
    -            return try container.viewContext.fetch(request)
    +            items = try container.viewContext.fetch(request)
             } catch {
    -            print("Failed to fetch items: \\(error)")
    -            return []
    +            print("Failed to fetch items: \\(error)")
    +            items = []
             }
    +        
    +        isLoading = false
         }
         
    -    func addItem(name: String) {
    -        let newItem = Item(context: container.viewContext)
    -        newItem.id = UUID()
    -        newItem.name = name
    -        newItem.timestamp = Date()
    +    func addItem(name: String) async throws {
    +        try await backgroundContext.perform {
    +            let newItem = Item(context: self.backgroundContext)
    +            newItem.id = UUID()
    +            newItem.name = name
    +            newItem.timestamp = Date()
    +            newItem.isCompleted = false
    +            
    +            try self.backgroundContext.save()
    +        }
    +    }
    +    
    +    func updateItem(_ item: Item, name: String? = nil, isCompleted: Bool? = nil) async throws {
    +        try await backgroundContext.perform {
    +            guard let objectID = item.objectID as? NSManagedObjectID,
    +                  let itemInContext = try? self.backgroundContext.existingObject(with: objectID) as? Item else {
    +                throw DataError.itemNotFound
    +            }
    +            
    +            if let name = name { itemInContext.name = name }
    +            if let isCompleted = isCompleted { itemInContext.isCompleted = isCompleted }
    +            itemInContext.timestamp = Date()
    +            
    +            try self.backgroundContext.save()
    +        }
    +    }
    +    
    +    func deleteItem(_ item: Item) async throws {
    +        try await backgroundContext.perform {
    +            guard let objectID = item.objectID as? NSManagedObjectID,
    +                  let itemInContext = try? self.backgroundContext.existingObject(with: objectID) else {
    +                throw DataError.itemNotFound
    +            }
    +            
    +            self.backgroundContext.delete(itemInContext)
    +            try self.backgroundContext.save()
    +        }
    +    }
    +}
         
    -        save()
    -    }
    -    
    -    func deleteItem(_ item: Item) {
    -        container.viewContext.delete(item)
    -        save()
    -    }
    +enum DataError: LocalizedError {
    +    case saveFailed(Error)
    +    case itemNotFound
    +    
    +    var errorDescription: String? {
    +        switch self {
    +        case .saveFailed(let error):
    +            return "Failed to save: \\(error.localizedDescription)"
    +        case .itemNotFound:
    +            return "Item not found"
    +        }
    +    }
     }
    """
    
    static let multipleFiles = """
    diff --git a/Models/User.swift b/Models/User.swift
    index 1234567..abcdefg 100644
    --- a/Models/User.swift
    +++ b/Models/User.swift
    @@ -8,9 +8,11 @@ struct User: Codable, Identifiable {
         let id: UUID
         let name: String
         let email: String
    +    let avatarURL: URL?
    +    let joinDate: Date
         
    -    init(name: String, email: String) {
    +    init(name: String, email: String, avatarURL: URL? = nil) {
             self.id = UUID()
             self.name = name
             self.email = email
    +        self.avatarURL = avatarURL
    +        self.joinDate = Date()
         }
     }
    diff --git a/Views/UserProfileView.swift b/Views/UserProfileView.swift
    index 2345678..bcdefgh 100644
    --- a/Views/UserProfileView.swift
    +++ b/Views/UserProfileView.swift
    @@ -12,15 +12,25 @@ struct UserProfileView: View {
         
         var body: some View {
             VStack(spacing: 20) {
    -            Image(systemName: "person.circle.fill")
    -                .font(.system(size: 100))
    -                .foregroundColor(.gray)
    +            AsyncImage(url: user.avatarURL) { image in
    +                image
    +                    .resizable()
    +                    .aspectRatio(contentMode: .fit)
    +            } placeholder: {
    +                Image(systemName: "person.circle.fill")
    +                    .font(.system(size: 100))
    +                    .foregroundColor(.gray)
    +            }
    +            .frame(width: 100, height: 100)
    +            .clipShape(Circle())
                 
                 Text(user.name)
                     .font(.largeTitle)
                     .bold()
                 
                 Text(user.email)
                     .font(.subheadline)
                     .foregroundColor(.secondary)
    +            
    +            Text("Member since \\(user.joinDate, style: .date)")
    +                .font(.caption)
    +                .foregroundColor(.secondary)
             }
             .padding()
         }
    """
    
    static let multipleHunks = """
    diff --git a/ViewModel.swift b/ViewModel.swift
    index 1234567..abcdefg 100644
    --- a/ViewModel.swift
    +++ b/ViewModel.swift
    @@ -5,8 +5,10 @@ import Foundation
     import Combine
     
     class ViewModel: ObservableObject {
    -    @Published var items: [String] = []
    +    @Published var items: [Item] = []
    +    @Published var searchText = ""
         @Published var isLoading = false
    +    @Published var error: Error?
         
         private var cancellables = Set<AnyCancellable>()
         
    @@ -25,15 +27,20 @@ class ViewModel: ObservableObject {
         
         func loadData() {
             isLoading = true
    +        error = nil
             
             APIService.shared.fetchItems()
                 .receive(on: DispatchQueue.main)
                 .sink(
                     receiveCompletion: { completion in
                         self.isLoading = false
    +                    if case .failure(let error) = completion {
    +                        self.error = error
    +                    }
                     },
                     receiveValue: { items in
                         self.items = items
                     }
                 )
                 .store(in: &cancellables)
         }
    @@ -50,10 +57,18 @@ class ViewModel: ObservableObject {
             items.removeAll { $0.id == item.id }
         }
         
    +    var filteredItems: [Item] {
    +        if searchText.isEmpty {
    +            return items
    +        }
    +        return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    +    }
    +    
         private func setupBindings() {
    -        // Add any reactive bindings here
    +        $searchText
    +            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    +            .sink { _ in self.objectWillChange.send() }
    +            .store(in: &cancellables)
         }
     }
    """
    
    static let whitespaceChanges = """
    diff --git a/FormatExample.swift b/FormatExample.swift
    index 1234567..abcdefg 100644
    --- a/FormatExample.swift
    +++ b/FormatExample.swift
    @@ -10,20 +10,20 @@ struct FormatExample {
         func processData() {
             let items = [1, 2, 3, 4, 5]
             
    -        for item in items{
    -            if item % 2 == 0{
    -                print("Even: \\(item)")
    -            }else{
    -                print("Odd: \\(item)")
    +        for item in items {
    +            if item % 2 == 0 {
    +                print("Even: \\(item)")
    +            } else {
    +                print("Odd: \\(item)")
                 }
             }
         }
         
    -    func calculate(a:Int,b:Int)->Int{
    -        return a+b
    +    func calculate(a: Int, b: Int) -> Int {
    +        return a + b
         }
         
    -    var computed:String{
    -        return "Hello"+"World"
    +    var computed: String {
    +        return "Hello" + " " + "World"
         }
     }
    """
    
    static let configPlaygroundDiff = """
    diff --git a/AppConfig.swift b/AppConfig.swift
    index 1234567..abcdefg 100644
    --- a/AppConfig.swift
    +++ b/AppConfig.swift
    @@ -12,18 +12,25 @@ struct AppConfig {
         static let shared = AppConfig()
         
         // API Configuration
    -    let apiBaseURL = "https://api.example.com/v1"
    -    let apiTimeout: TimeInterval = 30
    +    let apiBaseURL: String
    +    let apiTimeout: TimeInterval
    +    let maxRetries: Int
         
         // UI Configuration
    -    let primaryColor = UIColor.systemBlue
    -    let secondaryColor = UIColor.systemGray
    +    let theme: Theme
    +    let animationDuration: Double
         
         // Feature Flags
    -    let isDebugEnabled = false
    -    let isAnalyticsEnabled = true
    +    let isDebugEnabled: Bool
    +    let isAnalyticsEnabled: Bool
    +    let isBetaFeaturesEnabled: Bool
         
         private init() {
    -        // Initialize configuration
    +        // Load from environment
    +        self.apiBaseURL = ProcessInfo.processInfo.environment["API_URL"] ?? "https://api.example.com/v1"
    +        self.apiTimeout = 30
    +        self.maxRetries = 3
    +        self.theme = .default
    +        self.animationDuration = 0.3
    +        self.isDebugEnabled = ProcessInfo.processInfo.environment["DEBUG"] == "1"
    +        self.isAnalyticsEnabled = !isDebugEnabled
    +        self.isBetaFeaturesEnabled = ProcessInfo.processInfo.environment["BETA"] == "1"
         }
     }
    """
}