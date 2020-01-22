//
//  AddCheckListItemViewController.swift
//  TodoListy
//
//  Created by Manpreet Singh on 2020-01-17.
//  Copyright © 2020 Manpreet Singh. All rights reserved.
//

import UIKit

protocol AddCheckListItemViewDelegate: class {
    func addItemViewDidCancel(_ controller: AddCheckListItemViewController)
    func addItemViewController(_ controller: AddCheckListItemViewController, DidFinishAdding item: CheckListItem)
    func addItemViewController(_ controller: AddCheckListItemViewController, DidFinishEditing item: CheckListItem)
}

class AddCheckListItemViewController: UITableViewController {

    weak var delegate: AddCheckListItemViewDelegate?
    weak var toDoList: TodoList?
    weak var itemToEdit: CheckListItem?

    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiled.delegate = self
        if let item = itemToEdit {
            title = "Edit item"
            textFiled.text = item.text
            addBarButton.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        textFiled.becomeFirstResponder()
    }

    @IBAction func dismissViewController(_ sender: Any) {
        delegate?.addItemViewDidCancel(self)
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        if let item = itemToEdit, let text = textFiled.text {
            item.text = text
            delegate?.addItemViewController(self, DidFinishEditing: item)
        } else {
            if let item = toDoList?.newTodo() {
                if let textFieldText = textFiled.text {
                    item.text = textFieldText
                }
                item.checked = false
                delegate?.addItemViewController(self, DidFinishAdding: item)
            }
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}


extension AddCheckListItemViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFiled.resignFirstResponder()
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let oldText = textFiled.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }

        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            addBarButton.isEnabled = false
        } else {
            addBarButton.isEnabled = true
        }

        return true
    }

}

