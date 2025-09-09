import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit
#endif
#if os(macOS)
  import AppKit
#endif

/// Cross-platform system background color wrapper
enum PlatformColors {
  static var background: Color {
    #if os(iOS) || os(tvOS) || os(watchOS)
      return Color(UIColor.systemBackground)
    #elseif os(macOS)
      if #available(macOS 10.15, *) {
        // There is no NSColor.systemBackground; windowBackgroundColor is closest for content areas
        return Color(NSColor.windowBackgroundColor)
      } else {
        return Color.white
      }
    #else
      return Color.white
    #endif
  }
}

extension Color {
  /// A cross-platform background color similar to system background.
  public static var appBackground: Color { PlatformColors.background }
}
