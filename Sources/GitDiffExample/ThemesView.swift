import SwiftUI
import gitdiff

struct ThemesView: View {
    @State private var selectedTheme: DiffTheme = .github
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ThemeButton(theme: .github, label: "GitHub", isSelected: isGitHub) {
                            selectedTheme = .github
                        }
                        ThemeButton(theme: .gitlab, label: "GitLab", isSelected: isGitLab) {
                            selectedTheme = .gitlab
                        }
                        ThemeButton(theme: .vsCodeLight, label: "VS Code Light", isSelected: isVSCodeLight) {
                            selectedTheme = .vsCodeLight
                        }
                        ThemeButton(theme: .vsCodeDark, label: "VS Code Dark", isSelected: isVSCodeDark) {
                            selectedTheme = .vsCodeDark
                        }
                        ThemeButton(theme: .xcodeLight, label: "Xcode Light", isSelected: isXcodeLight) {
                            selectedTheme = .xcodeLight
                        }
                        ThemeButton(theme: .xcodeDark, label: "Xcode Dark", isSelected: isXcodeDark) {
                            selectedTheme = .xcodeDark
                        }
                    }
                    .padding()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Theme: \(themeName)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        DiffRenderer(diffText: sampleDiff)
                            .diffTheme(selectedTheme)
                            .padding()
                    }
                }
            }
            .navigationTitle("Themes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var themeName: String {
        switch selectedTheme {
        case .github: return "GitHub"
        case .gitlab: return "GitLab"
        case .vsCodeLight: return "VS Code Light"
        case .vsCodeDark: return "VS Code Dark"
        case .xcodeLight: return "Xcode Light"
        case .xcodeDark: return "Xcode Dark"
        default: return "Custom"
        }
    }
    
    private var isGitHub: Bool { selectedTheme == .github }
    private var isGitLab: Bool { selectedTheme == .gitlab }
    private var isVSCodeLight: Bool { selectedTheme == .vsCodeLight }
    private var isVSCodeDark: Bool { selectedTheme == .vsCodeDark }
    private var isXcodeLight: Bool { selectedTheme == .xcodeLight }
    private var isXcodeDark: Bool { selectedTheme == .xcodeDark }
    
    private let sampleDiff = """
    diff --git a/Theme.swift b/Theme.swift
    index 1234567..abcdefg 100644
    --- a/Theme.swift
    +++ b/Theme.swift
    @@ -5,7 +5,9 @@ struct Theme {
         let primaryColor: Color
         let secondaryColor: Color
         
    -    static let light = Theme(
    +    /// Light theme with blue accent
    +    static let light = Theme(
             primaryColor: .blue,
    -        secondaryColor: .gray
    +        secondaryColor: .gray,
    +        backgroundColor: .white
         )
    """
    
    private struct ThemeButton: View {
        let theme: DiffTheme
        let label: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(label)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isSelected ? Color.accentColor : Color(UIColor.systemGray5))
                    .foregroundColor(isSelected ? .white : .primary)
                    .cornerRadius(8)
            }
        }
    }
}
