//
//  MainTabView.swift
//  GitDiffExample
//
//  Created by Tornike Gomareli on 18.06.25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ShowcaseView()
                .tabItem {
                    Label("Showcase", systemImage: "star.fill")
                }
                .tag(0)
            
            ThemeGalleryView()
                .tabItem {
                    Label("Themes", systemImage: "paintbrush.fill")
                }
                .tag(1)
            
            CustomizationPlayground()
                .tabItem {
                    Label("Customize", systemImage: "slider.horizontal.3")
                }
                .tag(2)
            
            ExamplesView()
                .tabItem {
                    Label("Examples", systemImage: "doc.text.fill")
                }
                .tag(3)
            
            CodeSnippetsView()
                .tabItem {
                    Label("Code", systemImage: "curlybraces")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}