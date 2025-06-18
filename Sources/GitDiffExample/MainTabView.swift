import SwiftUI
import gitdiff

struct MainTabView: View {
    var body: some View {
        TabView {
            ExamplesView()
                .tabItem {
                    Label("Examples", systemImage: "doc.text")
                }
            
            ThemesView()
                .tabItem {
                    Label("Themes", systemImage: "paintbrush")
                }
            
            ConfigurationView()
                .tabItem {
                    Label("Config", systemImage: "gearshape.2")
                }
            
            APIReferenceView()
                .tabItem {
                    Label("API", systemImage: "curlybraces")
                }
        }
    }
}