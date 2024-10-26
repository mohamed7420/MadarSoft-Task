//
//  TodoCVCellViewModel.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 24/10/2024.
//

import UIKit

class TodoCVCellViewModel: ObservableObject {
            
    private let todo: Todo
    init(todo: Todo) {
        self.todo = todo
    }
    
    var title: String { todo.title }
    var isCompleted: Bool { todo.completed }
}
