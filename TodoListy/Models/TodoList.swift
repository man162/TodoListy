//
//  TodoList.swift
//  TodoListy
//
//  Created by Manpreet Singh on 2020-01-17.
//  Copyright © 2020 Manpreet Singh. All rights reserved.
//

import Foundation

class TodoList {

    var todos: [CheckListItem] = []

    init() {
        let task1 = CheckListItem()
        let task2 = CheckListItem()
        let task3 = CheckListItem()
        let task4 = CheckListItem()
        let task5 = CheckListItem()

        task1.text = "take a jog"
        task2.text = "prep breakfast"
        task3.text = "do grocery"
        task4.text = "clean the house"
        task5.text = "pay visa"

        todos = [task1, task2, task3, task4, task5]
    }

    func newTodo() -> CheckListItem {
        let item = CheckListItem()
        item.text = randomTitle()
        todos.append(item)
        return item
    }

    func remove(items: [CheckListItem]) {
        for item in items {
            if let index = todos.firstIndex(of: item) {
                todos.remove(at: index)
            }
        }
    }
    func move(item: CheckListItem, to index: Int) {
        guard let currentIndex = todos.firstIndex(of: item) else {
            return
        }
        todos.remove(at: currentIndex)
        todos.insert(item, at: index)
    }

    private func randomTitle() -> String {
        let title = "Write a app"
        let title2 = "Make a website"
        let title3 = "write a poem"
        let title4 = "write a song" 
        let title5 = "write a msg"
        let titles = [title, title2, title3, title4, title5]
        let randomInt = Int.random(in: 0..<titles.count)
        return titles[randomInt]
    }
}
