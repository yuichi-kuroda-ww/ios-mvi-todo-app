import UIKit
import RxSwift

protocol Mvi {
    associatedtype Intent
    associatedtype State
    associatedtype ViewModel
    
    func intents() -> Observable<Intent>
    func idleIntent() -> Intent
    func render(state: State)
    func provideViewModel() -> ViewModel
}

class MxViewController
    <I: MxIntent, C: MxChange, S: MxState, VM: MxViewModel<I, C, S>>: UIViewController, Mvi {

    typealias Intent = I
    typealias State = S
    typealias ViewModel = VM

    private let disposeBag = DisposeBag()

    lazy var viewModel: ViewModel = {
        return provideViewModel()
    }()

    override func viewDidLoad() {
        viewModel.states()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in
                self.log(state: state)
                self.render(state: state)
            })
            .disposed(by: disposeBag)

        viewModel.processIntents(intents: intents())
    }

    private func log(state: State) {
        print(state)
    }

    // MARK: @protocol/Mvi
    func intents() -> Observable<Intent> {
        return Observable.empty()
    }

    func idleIntent() -> Intent {
        fatalError("idleIntent() must be overidden in concrete implementations of MviViewController")
    }

    func render(state: State) {
        fatalError("render() must be overidden in concrete implementations of MviViewController")
    }

    func provideViewModel() -> ViewModel {
        fatalError("viewModel() must be overidden in concrete implementations of MviViewController")
    }
    
}
