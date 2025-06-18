# GitDiff Example App

A comprehensive showcase app demonstrating all features of the `gitdiff` SwiftUI package.

## Overview

This example app is designed to showcase the full capabilities of the gitdiff package through an interactive and visually appealing interface. Perfect for:
- Creating screenshots for documentation
- Recording demo videos
- Testing different configurations
- Learning the API

## Features

### 1. **Showcase Tab** 🌟
- Animated carousel showcasing all built-in themes
- Auto-play functionality for smooth demos
- Beautiful gradient backgrounds
- Theme transition animations

### 2. **Theme Gallery Tab** 🎨
- Grid view of all 3 built-in themes (Light, Dark, GitLab)
- Interactive theme selection with custom theme creation
- Side-by-side theme comparison
- Custom theme creator with color pickers
- Full-screen preview mode

### 3. **Customization Playground Tab** 🛠
- Real-time configuration controls:
  - Font size slider (10-20pt)
  - Font weight selector
  - Line spacing options
  - Line numbers toggle
  - Word wrap toggle
- Split view with live preview
- Preset configurations (Default, Code Review, Mobile, Presentation)
- Configuration summary display

### 4. **Examples Tab** 📄
- Categorized diff examples:
  - Simple code changes
  - File renames
  - New/deleted files
  - Binary files
  - Large diffs
  - Multiple files
- Detailed view for each example
- Theme switching within examples
- Share functionality

### 5. **Code Snippets Tab** 💻
- Categorized API examples
- Copy-to-clipboard functionality
- Live previews
- Complete code samples for:
  - Basic usage
  - Theme application
  - Configuration options
  - Advanced patterns

## Running the App

1. Open `GitDiffExample.xcodeproj` in Xcode
2. Select an iOS simulator (iPhone 14 Pro recommended for screenshots)
3. Build and run (⌘R)

## Recording Tips

### For Screenshots:
1. Use the **Showcase** tab for hero images
2. Use **Theme Gallery** to show theme variety
3. Use **Customization Playground** to demonstrate configuration options

### For Demo Videos:
1. Start with the auto-playing **Showcase** tab
2. Navigate through each tab to show features
3. Use the **Customization Playground** to show real-time updates
4. End with **Code Snippets** to show implementation ease

## Architecture

The app is built with:
- SwiftUI 3.0+
- Clean MVVM-like structure
- Reusable components
- Sample data in `SampleDiffs.swift`

## Customization

Feel free to modify:
- Sample diff content in `SampleDiffs.swift`
- Theme showcase timing in `ShowcaseView.swift`
- Example categories in `ExamplesView.swift`
- Code snippets in `CodeSnippetsView.swift`

## License

This example app is part of the gitdiff package and follows the same license.