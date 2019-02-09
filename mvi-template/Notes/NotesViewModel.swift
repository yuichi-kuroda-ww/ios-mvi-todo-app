//
//  ViewModel.swift
//  mvi-template
//
//  Copyright © 2018 WW. All rights reserved.
//

import Foundation
import RxSwift

struct Note {
    let text: String
}

class NotesViewModel: MxViewModel<NotesIntent, NotesChange, NotesState> {
    var notes: [Note] = []
    
    func fetchNotes() -> Observable<NotesChange> {
        return Observable.just(.fetchedNotes)
    }
    
    func create(note: String) -> Observable<NotesChange> {
        guard !note.isEmpty else { return Observable.just(.createNoteError) }
        
        notes.append(Note(text: note))
        
        return Observable.just(.createdNote(at: notes.count-1))
    }
    
    func destroyNote(at index: Int) -> Observable<NotesChange> {
        notes.remove(at: index)
        
        return Observable.just(.destroyedNote(at: index))
    }
    
    override func dispatcher(intent: NotesIntent) -> Observable<NotesChange> {
//        print("dispatcher() - intent: \(intent)")
        switch intent {
        case .idle:
            return Observable.just(.idle)
        case .start:
            return fetchNotes()
        case .addNote(let note):
            return create(note: note)
        case .destroyNote(let index):
            return destroyNote(at: index)
        }
    }
    
    override func reducer(previousState: NotesState, change: NotesChange) -> NotesState {
//        print("reducer() - previousState: \(previousState), change: \(change)")
        switch change {
        case .idle:
            return .idle
        case .fetchedNotes:
            if notes.isEmpty {
                return .empty
            } else {
                return .idle
            }
        case .createdNote(let index):
            return .noteCreated(at: index)
        case .destroyedNote(let index):
            return .noteDestroyed(at: index)
        case .createNoteError:
            return .textIsRequiredError
        }
    }
}
