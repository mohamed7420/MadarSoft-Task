//
//  TodoListViewModel.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 24/10/2024.
//

import Foundation
import CoreData
import Combine

class TodoListViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var todos: [Todo] = []
    @Published var filteredTodos: [Todo] = []
    
    private let context: NSManagedObjectContext
    private let soundManager: SoundManager
    private let networkManager: NetworkServiceProtocol
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext,
         soundManager: SoundManager = .shared,
         networkManager: NetworkServiceProtocol = NetworkManager()) {
        self.context = context
        self.soundManager = soundManager
        self.networkManager = networkManager
    }
    
    @MainActor
    func loadAllTodos() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedTodos: [Todo] = try await networkManager.fetchData(from: Constants.apiURL)
            todos = fetchedTodos
            saveTodosOffline()
        } catch {
            print("Failed to load todos: \(error.localizedDescription)")
        }
    }
    
    func filterTodos(_ searchText: String) -> [Todo] {
        if searchText.isEmpty {
            return todos
        } else {
            let filteredTodos = todos.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
            return filteredTodos
        }
    }
    
    func deleteTodo(at index: Int) {
        guard index < todos.count else { return }
        let todoToDelete = todos.remove(at: index)
        deleteTodoFromCoreData(todoToDelete)
    }
    
    private func deleteTodoFromCoreData(_ todo: Todo) {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", todo.id)
        
        do {
            let results = try context.fetch(request)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
            }
        } catch {
            print("Error deleting todo from Core Data: \(error.localizedDescription)")
        }
    }
    
    func addNewTodo(_ todo: Todo) {
        todos.insert(todo, at: 0)
        saveTodoOffline(todo)
        
        do {
            try context.save()
        } catch {
            print("Failed to save new todo: \(error.localizedDescription)")
        }
    }
    
    func updateCompleteTodo(at index: Int) {
        guard index < todos.count else { return }
        todos[index].completed.toggle()
        updateTodoInCoreData(todos[index])
        completedTodoSound(for: todos[index])
        
        do {
            try context.save()
        } catch {
            print("Failed to update todo completion status: \(error.localizedDescription)")
        }
    }

    private func updateTodoInCoreData(_ todo: Todo) {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", todo.id)
        
        do {
            let results = try context.fetch(request)
            if let entityToUpdate = results.first {
                entityToUpdate.isCompleted = todo.completed
            }
        } catch {
            print("Error updating todo in Core Data: \(error.localizedDescription)")
        }
    }
    
    private func saveTodosOffline() {
        todos.forEach { saveTodoOffline($0) }
        do {
            try context.save()
        } catch {
            print("Failed to save todos offline: \(error.localizedDescription)")
        }
    }
    
    private func saveTodoOffline(_ todo: Todo) {
        let todoEntity = TodoEntity(context: context)
        todoEntity.userId = Int64(todo.userId)
        todoEntity.id = Int64(todo.id)
        todoEntity.title = todo.title
        todoEntity.isCompleted = todo.completed
    }
    
    func fetchTodos() {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        
        do {
            let todoEntities = try context.fetch(request)
            todos = todoEntities.map {
                Todo(userId: Int($0.userId), id: Int($0.id), title: $0.title ?? "", completed: $0.isCompleted)
            }
        } catch {
            print("Error fetching todos from Core Data: \(error.localizedDescription)")
        }
    }
    
    func hasTodosInCoreData() -> Bool {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.fetchLimit = 1
        
        do {
            return try context.count(for: request) > 0
        } catch {
            print("Error checking Core Data existence: \(error.localizedDescription)")
            return false
        }
    }
    
    func completedTodoSound(for todo: Todo) {
        if todo.completed {
            soundManager.play()
        }
    }
}
