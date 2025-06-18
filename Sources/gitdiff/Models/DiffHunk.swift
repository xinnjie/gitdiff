//
//  DiffHunk.swift
//  gitdiff
//
//  Created by Tornike Gomareli on 18.06.25.
//


import Foundation

/// Represents a change section (hunk) in a diff file.
struct DiffHunk: Identifiable {
  let id = UUID()
  let oldStart: Int
  let oldCount: Int
  let newStart: Int
  let newCount: Int
  let header: String
  let lines: [DiffLine]
}
