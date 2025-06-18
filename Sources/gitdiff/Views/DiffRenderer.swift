//
//  DiffRenderer.swift
//  gitdiff
//
//  Created by Tornike Gomareli on 18.06.25.
//

import SwiftUI

/// A SwiftUI view that renders git diff output with syntax highlighting.
///
/// ## Overview
/// `DiffRenderer` parses and displays git diff text with customizable themes and formatting options.
///
/// ## Usage
/// ```swift
/// DiffRenderer(diffText: gitDiffOutput)
///     .diffTheme(.vsCodeDark)
///     .diffLineNumbers(false)
/// ```
public struct DiffRenderer: View {
  let diffText: String
  
  @Environment(\.diffConfiguration) private var configuration
  
  private var parsedFiles: [DiffFile] {
    DiffParser.parse(diffText)
  }
  
  public init(diffText: String) {
    self.diffText = diffText
  }
  
  public var body: some View {
    ScrollView {
      if parsedFiles.isEmpty {
        VStack(spacing: 20) {
          Image(systemName: "doc.text.magnifyingglass")
            .font(.system(size: 50))
            .foregroundColor(.secondary)
          
          Text("No diff content to display")
            .font(.headline)
            .foregroundColor(.secondary)
          
          Text("The provided diff text appears to be empty or invalid.")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        VStack(spacing: 16) {
          ForEach(parsedFiles) { file in
            DiffFileView(file: file)
          }
        }
        .padding()
      }
    }
    .background(Color(.systemBackground))
  }
}

#Preview {
  let text = """
    diff --git a/example.swift b/example.swift
    index 1234567..abcdefg 100644
    --- a/example.swift
    +++ b/example.swift
    @@ -1,5 +1,6 @@
    
    
     struct ContentView: View {
    +    let title = "Hello World"
         var body: some View {
    -        Text("Hello, World!")
    +        Text(title)
         }
     }
    diff --git a/AppDelegate.swift b/AppDelegate.swift
    index 2345678..bcdefgh 100644
    --- a/AppDelegate.swift
    +++ b/AppDelegate.swift
    @@ -10,8 +10,10 @@ class AppDelegate: NSObject, NSApplicationDelegate {
         func applicationDidFinishLaunching(_ notification: Notification) {
             // Insert code here to initialize your application
    +        setupApplication()
         }
    
    -    func applicationWillTerminate(_ notification: Notification) {
    -        // Insert code here to tear down your application
    +    private func setupApplication() {
    +        // Configure app settings
    +        print("Application setup complete")
         }
     }
    """
  // Simple usage with default GitHub theme
  DiffRenderer(diffText: text)
  
  // With dark theme
  DiffRenderer(diffText: text)
    .diffTheme(.vsCodeDark)
  
  // With custom configuration
  DiffRenderer(diffText: text)
    .diffTheme(.gitlab)
    .diffLineNumbers(false)
    .diffFont(size: 14, weight: .medium)
    .diffLineSpacing(.comfortable)
}
