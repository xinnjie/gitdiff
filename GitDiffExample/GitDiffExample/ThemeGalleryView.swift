//
//  ThemeGalleryView.swift
//  GitDiffExample
//
//  Created by Tornike Gomareli on 18.06.25.
//

import SwiftUI
import gitdiff

struct ThemeGalleryView: View {
  @State private var selectedTheme: DiffTheme = .light
  @State private var showingFullScreen = false
  @State private var showingCustomThemeCreator = false
  
  let themes: [(name: String, theme: DiffTheme, icon: String, description: String)] = [
    ("Light", .light, "sun.max.fill", "Clean GitHub-style theme with excellent readability"),
    ("Dark", .dark, "moon.fill", "Modern dark theme for comfortable night coding"),
    ("GitLab", .gitlab, "square.and.arrow.up", "GitLab's clean and professional diff style")
  ]
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          LazyVGrid(columns: columns, spacing: 16) {
            ForEach(themes, id: \.name) { theme in
              ThemeCard(
                name: theme.name,
                theme: theme.theme,
                icon: theme.icon,
                description: theme.description,
                isSelected: selectedTheme == theme.theme
              ) {
                withAnimation(.spring()) {
                  selectedTheme = theme.theme
                }
              }
            }
          }
          .padding()
          
          // Custom Theme Button
          Button(action: { showingCustomThemeCreator = true }) {
            HStack {
              Image(systemName: "paintbrush.pointed.fill")
              Text("Create Custom Theme")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              LinearGradient(
                colors: [.purple, .blue],
                startPoint: .leading,
                endPoint: .trailing
              )
            )
            .cornerRadius(12)
          }
          .padding(.horizontal)
          
          VStack(alignment: .leading, spacing: 12) {
            HStack {
              Text("Preview")
                .font(.title2.bold())
              
              Spacer()
              
              Button(action: { showingFullScreen = true }) {
                Label("Full Screen", systemImage: "arrow.up.left.and.arrow.down.right")
                  .font(.caption)
              }
            }
            
            DiffRenderer(diffText: sampleDiff)
              .diffTheme(selectedTheme)
              .background(Color.white)
              .cornerRadius(12)
              .shadow(color: .black.opacity(0.1), radius: 5)
          }
          .padding()
        }
      }
      .background(Color(.systemGroupedBackground))
      .navigationTitle("Theme Gallery")
      .sheet(isPresented: $showingFullScreen) {
        FullScreenPreview(theme: selectedTheme)
      }
      .sheet(isPresented: $showingCustomThemeCreator) {
        CustomThemeCreator(selectedTheme: $selectedTheme)
      }
    }
  }
  
  private let sampleDiff = """
    diff --git a/Theme.swift b/Theme.swift
    index 1234567..abcdefg 100644
    --- a/Theme.swift
    +++ b/Theme.swift
    @@ -5,10 +5,12 @@ import Foundation
     
     struct Theme {
         let name: String
    -    let primaryColor: UIColor
    -    let secondaryColor: UIColor
    +    let primaryColor: Color
    +    let secondaryColor: Color
    +    let accentColor: Color
         
         init(name: String) {
             self.name = name
    +        // Initialize with default colors
         }
     }
    """
}

struct ThemeCard: View {
  let name: String
  let theme: DiffTheme
  let icon: String
  let description: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Image(systemName: icon)
            .font(.title2)
            .foregroundColor(isSelected ? .white : .blue)
          
          Spacer()
          
          if isSelected {
            Image(systemName: "checkmark.circle.fill")
              .foregroundColor(.white)
          }
        }
        
        Text(name)
          .font(.headline)
          .foregroundColor(isSelected ? .white : .primary)
        
        Text(description)
          .font(.caption)
          .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
          .lineLimit(2)
        
        HStack(spacing: 8) {
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.addedBackground)
            .frame(height: 20)
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.removedBackground)
            .frame(height: 20)
        }
      }
      .padding()
      .background(
        isSelected ?
        LinearGradient(
          colors: [.blue, .blue.opacity(0.8)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        ) :
          LinearGradient(
            colors: [Color(.systemBackground)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
      )
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
      )
      .shadow(color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.05), radius: 5)
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct FullScreenPreview: View {
  let theme: DiffTheme
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      DiffRenderer(diffText: SampleDiffs.largeDiff)
        .diffTheme(theme)
        .navigationTitle("Full Screen Preview")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") {
              dismiss()
            }
          }
        }
    }
  }
}

struct CustomThemeCreator: View {
  @Binding var selectedTheme: DiffTheme
  @Environment(\.dismiss) var dismiss
  
  @State private var addedBgColor = Color.green.opacity(0.2)
  @State private var addedTextColor = Color.green
  @State private var removedBgColor = Color.red.opacity(0.2)
  @State private var removedTextColor = Color.red
  
  var body: some View {
    NavigationView {
      Form {
        Section("Added Lines") {
          ColorPicker("Background", selection: $addedBgColor)
          ColorPicker("Text", selection: $addedTextColor)
        }
        
        Section("Removed Lines") {
          ColorPicker("Background", selection: $removedBgColor)
          ColorPicker("Text", selection: $removedTextColor)
        }
        
        Section("Preview") {
          DiffRenderer(diffText: """
                    diff --git a/test.swift b/test.swift
                    @@ -1,3 +1,3 @@
                    -let oldValue = "Hello"
                    +let newValue = "World"
                     let unchanged = true
                    """)
          .diffTheme(customTheme)
          .frame(height: 100)
        }
      }
      .navigationTitle("Create Custom Theme")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Apply") {
            selectedTheme = customTheme
            dismiss()
          }
        }
      }
    }
  }
  
  private var customTheme: DiffTheme {
    DiffTheme(
      addedBackground: addedBgColor,
      addedText: addedTextColor,
      removedBackground: removedBgColor,
      removedText: removedTextColor,
      contextBackground: Color.gray.opacity(0.1),
      contextText: Color.primary,
      lineNumberBackground: Color.gray.opacity(0.1),
      lineNumberText: Color.secondary,
      headerBackground: Color.blue.opacity(0.1),
      headerText: Color.blue,
      fileHeaderBackground: Color.gray.opacity(0.1),
      fileHeaderText: Color.primary
    )
  }
}

#Preview {
  ThemeGalleryView()
}
