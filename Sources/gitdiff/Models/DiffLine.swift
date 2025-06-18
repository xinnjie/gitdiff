//
//  DiffLine.swift
//  gitdiff
//
//  Created by Tornike Gomareli on 18.06.25.
//


import Foundation

/// Represents a single line in a diff.
struct DiffLine: Identifiable {
  let id = UUID()
  let type: LineType
  let content: String
  let oldLineNumber: Int?
  let newLineNumber: Int?
  
  /// Type of diff line.
  enum LineType {
    case added    /// Line was added (+)
    case removed  /// Line was removed (-)
    case context  /// Unchanged context line
    case header   /// Section header
  }
}
