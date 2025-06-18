//
//  ShowcaseView.swift
//  GitDiffExample
//
//  Created by Tornike Gomareli on 18.06.25.
//

import SwiftUI
import gitdiff

struct ShowcaseView: View {
  @State private var currentThemeIndex = 0
  @State private var timer: Timer?
  @State private var isAutoPlaying = true
  
  let themes: [(name: String, theme: DiffTheme)] = [
    ("Light", .light),
    ("Dark", .dark),
    ("GitLab", .gitlab)
  ]
  
  var body: some View {
    NavigationView {
      ZStack {
        // Gradient background
        LinearGradient(
          colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 0) {
          // Header
          VStack(spacing: 12) {
            Text("GitDiff Showcase")
              .font(.largeTitle.bold())
              .foregroundColor(.primary)
            
            Text("Beautiful Git Diff Rendering for SwiftUI")
              .font(.headline)
              .foregroundColor(.secondary)
          }
          .padding(.top, 20)
          .padding(.bottom, 30)
          
          // Theme name with animation
          HStack {
            ForEach(0..<themes.count, id: \.self) { index in
              Circle()
                .fill(index == currentThemeIndex ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 8, height: 8)
                .animation(.easeInOut, value: currentThemeIndex)
            }
          }
          .padding(.bottom, 20)
          
          Text(themes[currentThemeIndex].name)
            .font(.title2.bold())
            .foregroundColor(.blue)
            .animation(.easeInOut, value: currentThemeIndex)
            .padding(.bottom, 20)
          
          // Diff showcase
          ScrollView {
            DiffRenderer(diffText: showcaseDiff)
              .diffTheme(themes[currentThemeIndex].theme)
              .padding()
              .background(Color.white)
              .cornerRadius(16)
              .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
              .padding(.horizontal)
              .animation(.easeInOut(duration: 0.5), value: currentThemeIndex)
          }
          
          // Controls
          HStack(spacing: 20) {
            Button(action: previousTheme) {
              Image(systemName: "chevron.left.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.blue)
            }
            
            Button(action: toggleAutoPlay) {
              Image(systemName: isAutoPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.blue)
            }
            
            Button(action: nextTheme) {
              Image(systemName: "chevron.right.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.blue)
            }
          }
          .padding(.vertical, 20)
        }
      }
      .navigationBarHidden(true)
      .onAppear {
        startAutoPlay()
      }
      .onDisappear {
        stopAutoPlay()
      }
    }
  }
  
  private func startAutoPlay() {
    guard isAutoPlaying else { return }
    timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
      withAnimation {
        nextTheme()
      }
    }
  }
  
  private func stopAutoPlay() {
    timer?.invalidate()
    timer = nil
  }
  
  private func toggleAutoPlay() {
    isAutoPlaying.toggle()
    if isAutoPlaying {
      startAutoPlay()
    } else {
      stopAutoPlay()
    }
  }
  
  private func nextTheme() {
    currentThemeIndex = (currentThemeIndex + 1) % themes.count
  }
  
  private func previousTheme() {
    currentThemeIndex = (currentThemeIndex - 1 + themes.count) % themes.count
  }
  
  private let showcaseDiff = """
    diff --git a/SwiftUIView.swift b/SwiftUIView.swift
    index 1234567..abcdefg 100644
    --- a/SwiftUIView.swift
    +++ b/SwiftUIView.swift
    @@ -10,16 +10,24 @@ import SwiftUI
     
     struct ContentView: View {
         @State private var count = 0
    +    @State private var message = "Welcome to GitDiff!"
    +    @Environment(\\.colorScheme) var colorScheme
         
         var body: some View {
             VStack(spacing: 20) {
    -            Text("Counter: \\(count)")
    -                .font(.largeTitle)
    +            Text(message)
    +                .font(.largeTitle.bold())
    +                .foregroundColor(.primary)
    +                .animation(.spring(), value: count)
                 
    -            Button("Increment") {
    -                count += 1
    +            Text("Count: \\(count)")
    +                .font(.title2)
    +                .foregroundColor(.secondary)
    +            
    +            Button(action: { 
    +                withAnimation { count += 1 }
    +            }) {
    +                Label("Increment", systemImage: "plus.circle.fill")
    +                    .font(.headline)
                 }
    -            .buttonStyle(.bordered)
    +            .buttonStyle(.borderedProminent)
             }
             .padding()
    +        .background(colorScheme == .dark ? Color.black : Color.white)
         }
     }
    """
}

#Preview {
  ShowcaseView()
}
