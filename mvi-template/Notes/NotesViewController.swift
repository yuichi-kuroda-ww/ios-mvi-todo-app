//
//  ViewController.swift
//  mvi-template
//
//  Copyright © 2018 WW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotesViewController: MxViewController<NotesIntent, NotesChange, NotesState, NotesViewModel>, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    let addButton: UIButton
    let textField: UITextField
    let textFieldContainerView: UIView
    let tableView: UITableView
    let emptyView: NotesEmptyView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        addButton = UIButton(type: .system)
        textField = UITextField()
        textFieldContainerView = UIView()
        tableView = UITableView()
        emptyView = NotesEmptyView()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // All observable intents added here (VC) are observed by intentsSubject (VM)
    override func intents() -> Observable<NotesIntent> {
        return Observable.merge(
            addButton.rx.tap
                .map { _ -> NotesIntent in
                    return NotesIntent.addNote(self.textField.text!)
                }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        viewModel.publish(intent: .start)
    }
    
    func setupViews() {
        addButton.setTitle("Add Note", for: .normal)
        view.addSubview(addButton)
        
        textFieldContainerView.backgroundColor = .white
        view.addSubview(textFieldContainerView)
        
        textField.backgroundColor = .white
        textField.delegate = self
        textFieldContainerView.addSubview(textField)
        
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        view.addSubview(emptyView)
        view.sendSubviewToBack(emptyView)
    }
    
    func switchMainView(to state: NotesState) {
        switch state.state {
        case .empty:
            view.bringSubviewToFront(emptyView)
        default:
            view.sendSubviewToBack(emptyView)
        }
    }
    
    func setupConstraints() {
        for v in view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        for v in textFieldContainerView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            textFieldContainerView.topAnchor.constraint(equalTo: textFieldContainerView.superview!.safeAreaLayoutGuide.topAnchor),
            textFieldContainerView.heightAnchor.constraint(equalToConstant: 50),
            textFieldContainerView.leftAnchor.constraint(equalTo: textFieldContainerView.superview!.leftAnchor),
            textFieldContainerView.rightAnchor.constraint(equalTo: textFieldContainerView.superview!.rightAnchor),
            
            textField.leftAnchor.constraint(equalTo: textField.superview!.leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: textField.superview!.rightAnchor, constant: 20),
            textField.topAnchor.constraint(equalTo: textField.superview!.topAnchor),
            textField.bottomAnchor.constraint(equalTo: textField.superview!.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: textFieldContainerView.bottomAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            emptyView.topAnchor.constraint(equalTo: tableView.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            emptyView.leftAnchor.constraint(equalTo: tableView.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: tableView.rightAnchor),
            ])
    }

    override func render(state: NotesState) {
        switch state.state {
        case .idle:
            switchMainView(to: state)
        case .empty:
            switchMainView(to: state)
        case .textIsRequiredError:
            let alertController = UIAlertController(title: "Note is empty", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                self.viewModel.publish(intent: .idle)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        case .noteCreated(let index):
            textField.text = ""
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .fade)
        case .noteDestroyed(let index):
            let indexPath = IndexPath(row: index, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func provideViewModel() -> ViewModel {
        return NotesViewModel(initialState: NotesState(state: .idle))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        
        cell.setup(with: NoteCellViewModel(note: viewModel.notes[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.publish(intent: NotesIntent.destroyNote(at: indexPath.row))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.publish(intent: NotesIntent.addNote(self.textField.text!))
        return true
    }
}
