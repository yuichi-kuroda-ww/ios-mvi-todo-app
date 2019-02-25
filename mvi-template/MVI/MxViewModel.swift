import UIKit
import RxSwift

class MxViewModel<I: MxIntent, C: MxChange, S: MxState> {

    typealias Intent = I
    typealias Change = C
    typealias State = S
    
    private let intentsSubject: PublishSubject<I> =  PublishSubject()
    private let initialState: State
    private let disposable = CompositeDisposable()

    private lazy var statesObservable: Observable<State> = {
        return intentsSubject
            .flatMap { intent in
                self.log(intent: intent)
            }
            .flatMap { intent in
                self.dispatcher(intent: intent)
            }
            .scan(initialState) { [unowned self] previousState, result in
                return self.reducer(previousState: previousState, change: result)
            }
            .replay(1)
            .autoconnect()
    }()

    init(initialState: State) {
        print("Initializer")
        self.initialState = initialState
    }

    func states() -> Observable<State> {
        return statesObservable
    }

    func processIntents(intents: Observable<Intent>) {
        _ = disposable.insert(intents.subscribe(intentsSubject))
    }

    func publish(intent: Intent) {
        intentsSubject.onNext(intent)
    }

    private func log(intent: Intent) -> Observable<Intent> {
        return Observable.just(intent)
    }

    // MARK: Must be overriden by concrete implementations
    func dispatcher(intent: Intent) -> Observable<Change> {
        fatalError("dispatcher must be implemented in concrete implementations of MviViewModel")
    }

    func reducer(previousState: State, change: Change) -> State {
        fatalError("reducer must be implemented in concrete implementations of MviViewModel")
    }
}
