//
//  DiffFile.swift
//  gitdiff
//
//  Created by Tornike Gomareli on 18.06.25.
//


import Foundation

/// Represents a file in a git diff.
struct DiffFile: Identifiable {
  let id = UUID()
  let oldPath: String
  let newPath: String
  let hunks: [DiffHunk]
  let isBinary: Bool
  let isRenamed: Bool
  
  /// Formatted name for display, showing rename if applicable.
  var displayName: String {
    if isRenamed {
      return "\(oldPath) → \(newPath)"
    }
    return newPath.isEmpty ? oldPath : newPath
  }
}
