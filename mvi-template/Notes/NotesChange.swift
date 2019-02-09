//
//  Result.swift
//  mvi-template
//
//  Copyright © 2018 WW. All rights reserved.
//

import Foundation

enum NotesChange: MxChange {
    case idle
    case fetchedNotes
    case createdNote(at: Int)
    case destroyedNote(at: Int)
    case createNoteError
}
