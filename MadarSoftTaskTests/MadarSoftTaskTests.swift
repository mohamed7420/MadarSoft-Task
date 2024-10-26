//
//  MadarSoftTaskTests.swift
//  MadarSoftTaskTests
//
//  Created by Mohamed Osama on 23/10/2024.
//

import XCTest
import CoreData
import Combine
@testable import MadarSoftTask

final class MadarSoftTaskTests: XCTestCase {
    
    var viewModel: TodoListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockSoundManager: MockSoundManager!
    var mockContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockNetworkManager = MockNetworkManager()
        mockSoundManager = MockSoundManager()
        mockContext = setUpInMemoryManagedObjectContext()
        
        viewModel = TodoListViewModel(context: mockContext,
                                      soundManager: mockSoundManager,
                                      networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkManager = nil
        mockSoundManager = nil
        mockContext = nil
        try super.tearDownWithError()
    }
        
    private func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }
        
    func testLoadAllTodosSuccess() async {
        mockNetworkManager.mockTodos = [Todo(userId: 1, id: 1, title: "Sample Todo", completed: false)]
        
        await viewModel.loadAllTodos()
        
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.todos.first?.title, "Sample Todo")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFilterTodosWithSearchText() {
        viewModel.todos = [
            Todo(userId: 1, id: 1, title: "First Todo", completed: false),
            Todo(userId: 1, id: 2, title: "Second Todo", completed: false)
        ]
        
        let filteredTodos = viewModel.filterTodos("First")
        
        XCTAssertEqual(filteredTodos.count, 1)
        XCTAssertEqual(filteredTodos.first?.title, "First Todo")
    }
    
    func testAddNewTodo() {
        let newTodo = Todo(userId: 1, id: 3, title: "New Todo", completed: false)
        
        viewModel.addNewTodo(newTodo)
        
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.todos.first?.title, "New Todo")
    }
    
    func testDeleteTodo() {
        viewModel.todos = [
            Todo(userId: 1, id: 1, title: "Sample Todo", completed: false)
        ]
        
        viewModel.deleteTodo(at: 0)
        XCTAssertEqual(viewModel.todos.count, 0)
    }
    
    func testUpdateCompleteTodo() {
        let todo = Todo(userId: 1, id: 1, title: "Sample Todo", completed: false)
        viewModel.todos = [todo]
        
        viewModel.updateCompleteTodo(at: 0)
        
        XCTAssertTrue(viewModel.todos.first!.completed)
        XCTAssertTrue(mockSoundManager.isSoundPlayed) // Ensures sound played
    }
        
    class MockNetworkManager: NetworkServiceProtocol {
        var mockTodos: [Todo] = []
        var isNetworkConnected: Bool = true
        
        func isConnectedToNetwork() -> Bool {
            return isNetworkConnected
        }
        
        func fetchData<T: Codable>(from urlString: String) async throws -> T {
            if T.self == [Todo].self {
                return mockTodos as! T
            } else {
                throw NSError(domain: "Invalid data type", code: -1, userInfo: nil)
            }
        }
    }
    
    class MockSoundManager: SoundManager {
        var isSoundPlayed = false
        override func play() {
            isSoundPlayed = true
        }
    }
}

