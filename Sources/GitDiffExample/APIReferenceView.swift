import SwiftUI
import gitdiff

struct APIReferenceView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Basic Usage") {
                    CodeExample(
                        title: "Simple Rendering",
                        code: """
                        DiffRenderer(diffText: gitDiffOutput)
                        """
                    )
                }
                
                Section("View Modifiers") {
                    CodeExample(
                        title: "Theme",
                        code: """
                        DiffRenderer(diffText: gitDiff)
                            .diffTheme(.vsCodeDark)
                        """
                    )
                    
                    CodeExample(
                        title: "Line Numbers",
                        code: """
                        DiffRenderer(diffText: gitDiff)
                            .diffLineNumbers(false)
                        """
                    )
                    
                    CodeExample(
                        title: "Font Configuration",
                        code: """
                        DiffRenderer(diffText: gitDiff)
                            .diffFont(size: 14, weight: .medium, design: .monospaced)
                        """
                    )
                    
                    CodeExample(
                        title: "Line Spacing",
                        code: """
                        DiffRenderer(diffText: gitDiff)
                            .diffLineSpacing(.comfortable)
                        """
                    )
                    
                    CodeExample(
                        title: "Combined Modifiers",
                        code: """
                        DiffRenderer(diffText: gitDiff)
                            .diffTheme(.gitlab)
                            .diffLineNumbers(false)
                            .diffFont(size: 14)
                            .diffLineSpacing(.comfortable)
                            .diffWordWrap(true)
                        """
                    )
                }
                
                Section("Configuration Object") {
                    CodeExample(
                        title: "Using Configuration",
                        code: """
                        let config = DiffConfiguration(
                            theme: .xcodeDark,
                            showLineNumbers: true,
                            fontSize: 14,
                            lineSpacing: .comfortable
                        )
                        
                        DiffRenderer(diffText: gitDiff)
                            .diffConfiguration(config)
                        """
                    )
                    
                    CodeExample(
                        title: "Configuration Builder",
                        code: """
                        let config = DiffConfiguration.default
                            .with(theme: .vsCodeLight)
                            .withLineNumbers(false)
                            .withFont(size: 16)
                        
                        DiffRenderer(diffText: gitDiff)
                            .diffConfiguration(config)
                        """
                    )
                    
                    CodeExample(
                        title: "Preset Configurations",
                        code: """
                        // Code Review
                        DiffRenderer(diffText: gitDiff)
                            .diffConfiguration(.codeReview)
                        
                        // Mobile
                        DiffRenderer(diffText: gitDiff)
                            .diffConfiguration(.mobile)
                        
                        // Presentation
                        DiffRenderer(diffText: gitDiff)
                            .diffConfiguration(.presentation)
                        """
                    )
                }
                
                Section("Custom Theme") {
                    CodeExample(
                        title: "Creating Custom Theme",
                        code: """
                        let myTheme = DiffTheme(
                            addedBackground: Color.green.opacity(0.2),
                            addedText: Color.green,
                            removedBackground: Color.red.opacity(0.2),
                            removedText: Color.red,
                            contextBackground: Color.gray.opacity(0.1),
                            contextText: Color.primary,
                            lineNumberBackground: Color.gray.opacity(0.1),
                            lineNumberText: Color.secondary,
                            headerBackground: Color.blue.opacity(0.1),
                            headerText: Color.blue,
                            fileHeaderBackground: Color.gray.opacity(0.1),
                            fileHeaderText: Color.primary
                        )
                        
                        DiffRenderer(diffText: gitDiff)
                            .diffTheme(myTheme)
                        """
                    )
                }
            }
            .navigationTitle("API Reference")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CodeExample: View {
    let title: String
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote.bold())
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(6)
            }
        }
        .padding(.vertical, 4)
    }
}