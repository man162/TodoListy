//
//  CheckListViewController.swift
//  TodoListy
//
//  Created by Manpreet Singh on 2020-01-16.
//  Copyright © 2020 Manpreet Singh. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {

    var todoList: TodoList
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        let item = todoList.todos[indexPath.row]
        configText(for: cell, with: item)
        configCheckmark(for: cell, with: item)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = todoList.todos[indexPath.row]
            configCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.todos.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    func configCheckmark(for cell:UITableViewCell, with item: CheckListItem) {
        guard let checkMark = cell.viewWithTag(2) as? UILabel else {
            return
        }
        if item.checked {
            checkMark.text = "√"
        } else {
            checkMark.text = ""
        }
        item.toggleChecked()
    }

    func configText(for cell: UITableViewCell, with item: CheckListItem) {
        if let label = cell.viewWithTag(1) as? UILabel{
            label.text = item.text
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let ItemDetailViewController = segue.destination as? ItemDetailViewController {
                ItemDetailViewController.delegate = self
                ItemDetailViewController.toDoList = todoList
            }
        } else if segue.identifier == "EditItem" {
            if let ItemDetailViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    let item = todoList.todos[indexPath!.row]
                    ItemDetailViewController.itemToEdit = item
                    ItemDetailViewController.delegate = self
                }
            }
        }
    }
}

extension CheckListViewController {

    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = todoList.todos.count
        _ = todoList.newTodo()
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

}

extension CheckListViewController: ItemDetailViewControllerDelegate {

    func ItemDetailViewDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func ItemDetailViewController(_ controller: ItemDetailViewController, DidFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todos.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    func ItemDetailViewController(_ controller: ItemDetailViewController, DidFinishEditing item: CheckListItem) {
        if let index = todoList.todos.lastIndex(of: item) {
            let indexPath = IndexPath(row : index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }

}
