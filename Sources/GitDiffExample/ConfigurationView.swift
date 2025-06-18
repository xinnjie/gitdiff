import SwiftUI
import gitdiff

struct ConfigurationView: View {
    @State private var showLineNumbers = true
    @State private var fontSize: CGFloat = 13
    @State private var lineSpacing: DiffConfiguration.LineSpacing = .compact
    @State private var wordWrap = true
    @State private var selectedTheme: DiffTheme = .github
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Display Options") {
                        Toggle("Show Line Numbers", isOn: $showLineNumbers)
                        
                        HStack {
                            Text("Font Size")
                            Spacer()
                            Text("\(Int(fontSize))pt")
                                .foregroundColor(.secondary)
                            Stepper("", value: $fontSize, in: 10...20)
                                .labelsHidden()
                        }
                        
                        Picker("Line Spacing", selection: $lineSpacing) {
                            Text("Compact").tag(DiffConfiguration.LineSpacing.compact)
                            Text("Comfortable").tag(DiffConfiguration.LineSpacing.comfortable)
                            Text("Spacious").tag(DiffConfiguration.LineSpacing.spacious)
                        }
                        
                        Toggle("Word Wrap", isOn: $wordWrap)
                    }
                    
                    Section("Preset Configurations") {
                        Button("Default") {
                            applyConfiguration(.default)
                        }
                        
                        Button("Code Review") {
                            applyConfiguration(.codeReview)
                        }
                        
                        Button("Mobile") {
                            applyConfiguration(.mobile)
                        }
                        
                        Button("Presentation") {
                            applyConfiguration(.presentation)
                        }
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Preview")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        DiffRenderer(diffText: sampleDiff)
                            .diffTheme(selectedTheme)
                            .diffLineNumbers(showLineNumbers)
                            .diffFont(size: fontSize)
                            .diffLineSpacing(lineSpacing)
                            .diffWordWrap(wordWrap)
                            .padding()
                    }
                }
            }
            .navigationTitle("Configuration")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func applyConfiguration(_ config: DiffConfiguration) {
        selectedTheme = config.theme
        showLineNumbers = config.showLineNumbers
        fontSize = config.fontSize
        lineSpacing = config.lineSpacing
        wordWrap = config.wordWrap
    }
    
    private let sampleDiff = """
    diff --git a/Config.swift b/Config.swift
    index 1234567..abcdefg 100644
    --- a/Config.swift
    +++ b/Config.swift
    @@ -10,8 +10,10 @@ struct Config {
         let apiKey: String
         let baseURL: URL
         
    -    init(apiKey: String) {
    +    init(apiKey: String, environment: Environment = .production) {
             self.apiKey = apiKey
    -        self.baseURL = URL(string: "https://api.example.com")!
    +        self.baseURL = environment.baseURL
         }
    +    
    +    enum Environment { case production, staging }
     }
    """
}