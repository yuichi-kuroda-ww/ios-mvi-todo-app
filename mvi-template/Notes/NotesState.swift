//
//  ViewState.swift
//  mvi-template
//
//  Copyright © 2018 WW. All rights reserved.
//

import Foundation

struct NotesState: MxState, Equatable {
    let state: State
    
    enum State: Equatable {
        case idle
        case empty
        case textIsRequiredError
        case noteCreated(at: Int)
        case noteDestroyed(at: Int)
    }
}
