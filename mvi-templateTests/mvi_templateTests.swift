//
//  mvi_templateTests.swift
//  mvi-templateTests
//
//  Created by Yuichi Kuroda on 12/16/18.
//  Copyright © 2018 WW. All rights reserved.
//

import XCTest
import RxSwift
@testable import mvi_template

class MviComponent: Mvi {
    typealias Intent = NotesIntent
    typealias State = NotesState
    typealias ViewModel = NotesViewModel
    
    private let disposeBag = DisposeBag()
    
    lazy var viewModel: ViewModel = {
        return provideViewModel()
    }()
    
    var onRender: ((_ state: NotesState) -> ())!
    
    init() {
        viewModel.states()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in
                self.render(state: state)
            })
            .disposed(by: disposeBag)
        
        viewModel.processIntents(intents: intents())
    }
    
    // MARK: Protocol
    func intents() -> Observable<Intent> {
        return Observable<NotesIntent>.never()
    }
    
    func idleIntent() -> Intent {
        fatalError("idleIntent() must be overidden in concrete implementations of MviViewController")
    }
    
    func render(state: State) {
        onRender(state)
    }
    
    func provideViewModel() -> ViewModel {
        return NotesViewModel(initialState: .idle)
    }
}

class mvi_templateTests: XCTestCase {
    var mviComponent: MviComponent!
    var intent: NotesIntent!
    var expectedState: NotesState!
    var e: XCTestExpectation!
    
    override func setUp() {
        e = expectation(description: "")
        mviComponent = MviComponent()
        mviComponent.onRender = { [weak self] state in
            guard let strongSelf = self else { return }
            XCTAssert(state == strongSelf.expectedState)
            
            strongSelf.e.fulfill()
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_start() {
        // Given
        intent = .start
        expectedState = .empty

        // When
        mviComponent.viewModel.publish(intent: intent)

        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_addEmptyNote() {
        // Given
        intent = .addNote("")
        expectedState = .textIsRequiredError

        // When
        mviComponent.viewModel.publish(intent: intent)

        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func test_addValidNote() {
        // Given
        intent = .addNote("Go buy USB-C cable")
        expectedState = .noteCreated(at: 0)
        
        // When
        mviComponent.viewModel.publish(intent: intent)
        
        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
