//
//  CodeSnippetsView.swift
//  GitDiffExample
//
//  Created by Tornike Gomareli on 18.06.25.
//

import SwiftUI
import gitdiff

struct CodeSnippetsView: View {
  @State private var selectedCategory = "Basic"
  @State private var copiedSnippet: String?
  
  let categories = ["Basic", "Themes", "Configuration", "Advanced"]
  
  var snippets: [CodeSnippet] {
    CodeSnippet.allSnippets.filter { $0.category == selectedCategory }
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Picker("Category", selection: $selectedCategory) {
          ForEach(categories, id: \.self) { category in
            Text(category).tag(category)
          }
        }
        .pickerStyle(.segmented)
        .padding()
        
        ScrollView {
          VStack(spacing: 16) {
            ForEach(snippets) { snippet in
              SnippetCard(
                snippet: snippet,
                onCopy: {
                  copyToClipboard(snippet.code)
                  withAnimation {
                    copiedSnippet = snippet.id.uuidString
                  }
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                      copiedSnippet = nil
                    }
                  }
                },
                isCopied: copiedSnippet == snippet.id.uuidString
              )
            }
          }
          .padding()
        }
      }
      .navigationTitle("Code Examples")
    }
  }
  
  private func copyToClipboard(_ text: String) {
    UIPasteboard.general.string = text
  }
}

struct CodeSnippet: Identifiable {
  let id = UUID()
  let title: String
  let description: String
  let category: String
  let code: String
  let preview: AnyView?
  
  init(title: String, description: String, category: String, code: String, preview: AnyView? = nil) {
    self.title = title
    self.description = description
    self.category = category
    self.code = code
    self.preview = preview
  }
  
  static let allSnippets = [
    CodeSnippet(
      title: "Basic Usage",
      description: "The simplest way to display a diff",
      category: "Basic",
      code: """
import SwiftUI
import gitdiff

struct ContentView: View {
    let diffText = "your git diff output"
    
    var body: some View {
        DiffRenderer(diffText: diffText)
    }
}
""",
      preview: AnyView(
        DiffRenderer(diffText: SampleDiffs.miniDiff)
          .frame(height: 150)
      )
    ),
    
    CodeSnippet(
      title: "With Theme",
      description: "Apply a built-in theme",
      category: "Basic",
      code: """
DiffRenderer(diffText: diffText)
    .diffTheme(.vsCodeDark)
""",
      preview: AnyView(
        DiffRenderer(diffText: SampleDiffs.miniDiff)
          .diffTheme(.vsCodeDark)
          .frame(height: 150)
      )
    ),
    
    CodeSnippet(
      title: "All Built-in Themes",
      description: "Available themes you can use",
      category: "Themes",
      code: """
// GitHub (default)
DiffRenderer(diffText: diffText)
    .diffTheme(.github)

// GitLab
DiffRenderer(diffText: diffText)
    .diffTheme(.gitlab)

// VS Code Light
DiffRenderer(diffText: diffText)
    .diffTheme(.vsCodeLight)

// VS Code Dark
DiffRenderer(diffText: diffText)
    .diffTheme(.vsCodeDark)

// Xcode Light
DiffRenderer(diffText: diffText)
    .diffTheme(.xcodeLight)

// Xcode Dark
DiffRenderer(diffText: diffText)
    .diffTheme(.xcodeDark)
"""
    ),
    
    CodeSnippet(
      title: "Custom Theme",
      description: "Create your own theme",
      category: "Themes",
      code: """
let customTheme = DiffTheme(
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

DiffRenderer(diffText: diffText)
    .diffTheme(customTheme)
"""
    ),
    
    CodeSnippet(
      title: "View Modifiers",
      description: "Customize using view modifiers",
      category: "Configuration",
      code: """
DiffRenderer(diffText: diffText)
    .diffTheme(.github)
    .diffLineNumbers(true)
    .diffFont(size: 14, weight: .medium)
    .diffLineSpacing(.comfortable)
    .diffWordWrap(true)
"""
    ),
    
    CodeSnippet(
      title: "Configuration Object",
      description: "Use a configuration object for reusability",
      category: "Configuration",
      code: """
let config = DiffConfiguration(
    theme: .vsCodeDark,
    showLineNumbers: true,
    fontSize: 14,
    fontWeight: .medium,
    lineSpacing: .comfortable,
    wordWrap: true
)

DiffRenderer(diffText: diffText)
    .diffConfiguration(config)
"""
    ),
    
    CodeSnippet(
      title: "Preset Configurations",
      description: "Use built-in configuration presets",
      category: "Configuration",
      code: """
// Default configuration
DiffRenderer(diffText: diffText)
    .diffConfiguration(.default)

// Optimized for code review
DiffRenderer(diffText: diffText)
    .diffConfiguration(.codeReview)

// Optimized for mobile devices
DiffRenderer(diffText: diffText)
    .diffConfiguration(.mobile)

// Perfect for presentations
DiffRenderer(diffText: diffText)
    .diffConfiguration(.presentation)

// Dark mode configuration
DiffRenderer(diffText: diffText)
    .diffConfiguration(.darkMode)
"""
    ),
    
    CodeSnippet(
      title: "Configuration Builder",
      description: "Build configurations using fluent API",
      category: "Advanced",
      code: """
let config = DiffConfiguration.default
    .with(theme: .gitlab)
    .withLineNumbers(false)
    .withFont(size: 16, weight: .semibold)
    .withLineSpacing(.spacious)

DiffRenderer(diffText: diffText)
    .diffConfiguration(config)
"""
    ),
    
    CodeSnippet(
      title: "Environment Values",
      description: "Pass configuration through environment",
      category: "Advanced",
      code: """
struct MyApp: View {
    var body: some View {
        ContentView()
            .environment(\\.diffConfiguration, .codeReview)
    }
}

struct ContentView: View {
    // Configuration is automatically inherited
    var body: some View {
        VStack {
            DiffRenderer(diffText: diff1)
            DiffRenderer(diffText: diff2)
        }
    }
}
"""
    ),
    
    CodeSnippet(
      title: "Dynamic Theme Switching",
      description: "Switch themes at runtime",
      category: "Advanced",
      code: """
struct ThemeSwitcher: View {
    @State private var selectedTheme: DiffTheme = .github
    
    var body: some View {
        VStack {
            Picker("Theme", selection: $selectedTheme) {
                Text("GitHub").tag(DiffTheme.github)
                Text("VS Code Dark").tag(DiffTheme.vsCodeDark)
            }
            .pickerStyle(.segmented)
            
            DiffRenderer(diffText: diffText)
                .diffTheme(selectedTheme)
                .animation(.easeInOut, value: selectedTheme)
        }
    }
}
"""
    )
  ]
}

struct SnippetCard: View {
  let snippet: CodeSnippet
  let onCopy: () -> Void
  let isCopied: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(snippet.title)
            .font(.headline)
          Text(snippet.description)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        
        Spacer()
        
        Button(action: onCopy) {
          Image(systemName: isCopied ? "checkmark.circle.fill" : "doc.on.doc")
            .foregroundColor(isCopied ? .green : .blue)
            .animation(.easeInOut, value: isCopied)
        }
      }
      
      ScrollView(.horizontal, showsIndicators: false) {
        Text(snippet.code)
          .font(.system(.caption, design: .monospaced))
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color(.secondarySystemBackground))
          .cornerRadius(8)
      }
      
      if let preview = snippet.preview {
        VStack(alignment: .leading, spacing: 8) {
          Text("Preview")
            .font(.caption.bold())
            .foregroundColor(.secondary)
          
          preview
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.05), radius: 5)
  }
}

#Preview {
  CodeSnippetsView()
}
