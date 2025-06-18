# GitDiff Example App

An iOS example app showcasing all features of the gitdiff package.

## Running the Example

1. Open the gitdiff package in Xcode
2. Select the `GitDiffExample` scheme from the scheme selector
3. Choose an iOS simulator or device
4. Build and run (⌘R)

## Features Demonstrated

### Examples Tab
- Simple code changes
- File renames
- New files
- Deleted files
- Binary files
- Large diffs with multiple hunks

### Themes Tab
- Interactive theme switcher
- All built-in themes:
  - GitHub
  - GitLab
  - VS Code Light/Dark
  - Xcode Light/Dark

### Configuration Tab
- Line numbers toggle
- Font size adjustment (10-20pt)
- Line spacing options (compact, comfortable, spacious)
- Word wrap toggle
- Preset configurations:
  - Default
  - Code Review
  - Mobile
  - Presentation

### API Reference Tab
- Code examples for all features
- View modifiers usage
- Configuration object usage
- Custom theme creation

## Code Structure

- `GitDiffExampleApp.swift` - Main app entry point
- `MainTabView.swift` - Tab navigation
- `ExamplesView.swift` - Different diff examples
- `ThemesView.swift` - Theme selection
- `ConfigurationView.swift` - Configuration options
- `APIReferenceView.swift` - API usage examples