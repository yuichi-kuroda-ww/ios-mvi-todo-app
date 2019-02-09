//
//  Intent.swift
//  mvi-template
//
//  Copyright © 2018 WW. All rights reserved.
//

import Foundation

enum NotesIntent: MxIntent {
    case idle
    case start
    case addNote(_ note: String)
    case destroyNote(at: Int)
}
