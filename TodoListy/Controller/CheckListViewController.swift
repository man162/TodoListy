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
    var tableData: [[CheckListItem?]?]!
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true

        let sectionTitileCount = UILocalizedIndexedCollation.current().sectionTitles.count
        var allSections = [[CheckListItem?]?](repeating: nil, count: sectionTitileCount)
        var sectionNumber = 0
        let collation = UILocalizedIndexedCollation.current()
        for item in todoList.todos {
            sectionNumber = collation.section(for: item, collationStringSelector:
                #selector(getter: CheckListItem.text))
            if (allSections[sectionNumber] == nil) {
                allSections[sectionNumber] = [CheckListItem?]()
            }
            allSections[sectionNumber]!.append(item)
        }
        tableData = allSections
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section] == nil ? 0 : tableData[section]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath)
        //let item = todoList.todos[indexPath.row]
        if let item = tableData[indexPath.section]?[indexPath.row] {
            configText(for: cell, with: item)
            configCheckmark(for: cell, with: item)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = todoList.todos[indexPath.row]
            item.toggleChecked()
            configCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.todos.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }


    func configCheckmark(for cell:UITableViewCell, with item: CheckListItem) {
        guard let checkMarkCell = cell as? CheckListTableViewCell else {
            return
        }
        if item.checked {
            checkMarkCell.checkmarkLabel.text = "√"
        } else {
            checkMarkCell.checkmarkLabel.text = ""
        }
    }

    func configText(for cell: UITableViewCell, with item: CheckListItem) {
        if let checkMarkCell = cell as? CheckListTableViewCell {
            checkMarkCell.todoTextLabel.text = item.text
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UILocalizedIndexedCollation.current().sectionTitles[section]
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

    @IBAction func deleteItems(_ sender: Any) {
        if let selectedItems = tableView.indexPathsForSelectedRows {
            var items = [CheckListItem]()
            for indexPath in selectedItems {
                items.append(todoList.todos[indexPath.row])
            }
            todoList.remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedItems, with: .automatic)
            tableView.endUpdates()
        }
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
