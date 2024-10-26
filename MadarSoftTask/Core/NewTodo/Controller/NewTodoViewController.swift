//
//  NewTodoViewController.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 25/10/2024.
//

import UIKit

protocol AddNewTodoDelegate: AnyObject {
    func addNewTodo(todo: Todo)
}

class NewTodoViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: AddNewTodoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        handleKeyboardAppearance()
    }

    private func updateViews() {
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
    }
    
    private func handleKeyboardAppearance() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func didSaveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let userId = Int.random(in: 10...100)
        let uniqueId = Int.random(in: 201...300)
        let newTodo = Todo(userId: userId, id: uniqueId, title: title.lowercased(), completed: false)
        
        dismiss(animated: true) {[weak self] in
            guard let self else { return }
            delegate?.addNewTodo(todo: newTodo)
        }
    }
}
