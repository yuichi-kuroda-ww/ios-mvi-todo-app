//
//  ViewState.swift
//  mvi-template
//
//  Copyright © 2018 WW. All rights reserved.
//

import Foundation

enum NotesState: MxState {
    case idle
    case empty
    case textIsRequiredError
    case noteCreated(at: Int)
    case noteDestroyed(at: Int)
}
