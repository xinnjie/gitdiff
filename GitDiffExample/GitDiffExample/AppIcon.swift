//
//  AppIcon.swift
//  GitDiffExample
//
//  Created by Tornike Gomareli on 18.06.25.
//

import SwiftUI

struct AppIconView: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.blue, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      
      VStack(spacing: 8) {
        HStack(spacing: 4) {
          Rectangle()
            .fill(Color.green.opacity(0.8))
            .frame(width: 30, height: 8)
          Rectangle()
            .fill(Color.white.opacity(0.3))
            .frame(width: 50, height: 8)
        }
        
        HStack(spacing: 4) {
          Rectangle()
            .fill(Color.white.opacity(0.3))
            .frame(width: 40, height: 8)
          Rectangle()
            .fill(Color.red.opacity(0.8))
            .frame(width: 35, height: 8)
        }
        
        HStack(spacing: 4) {
          Rectangle()
            .fill(Color.green.opacity(0.8))
            .frame(width: 45, height: 8)
          Rectangle()
            .fill(Color.white.opacity(0.3))
            .frame(width: 25, height: 8)
        }
      }
      .rotationEffect(.degrees(-10))
    }
    .frame(width: 120, height: 120)
    .cornerRadius(26)
  }
}

struct LaunchScreenView: View {
  @State private var animationAmount = 1.0
  
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()
      
      VStack(spacing: 20) {
        AppIconView()
          .scaleEffect(animationAmount)
          .animation(
            Animation.easeInOut(duration: 1.0)
              .repeatForever(autoreverses: true),
            value: animationAmount
          )
        
        Text("GitDiff")
          .font(.system(size: 40, weight: .bold, design: .rounded))
          .foregroundColor(.primary)
        
        Text("Beautiful Diff Rendering")
          .font(.headline)
          .foregroundColor(.secondary)
      }
    }
    .onAppear {
      animationAmount = 1.1
    }
  }
}

#Preview("App Icon") {
  AppIconView()
}

#Preview("Launch Screen") {
  LaunchScreenView()
}
