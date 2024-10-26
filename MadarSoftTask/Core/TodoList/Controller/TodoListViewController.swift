//
//  TodoListViewController.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 24/10/2024.
//

import UIKit
import Combine

class TodoListViewController: UIViewController {
    
    enum Section {
        case main
    }

    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var shimmerView: TodoShimmerView = {
        let view = TodoShimmerView.loadFromXib()
        return view
    }()
    
    private lazy var topTrailingBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .done, target: self,
                                     action: #selector(presentNewTodo))
        button.tintColor = .systemRed
        return button
    }()
    
    private var searchController: UISearchController!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Todo>!
    private var searchTextPublisher = PassthroughSubject<String, Never>()

    private let viewModel: TodoListViewModel = .init()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewBinding()
        registerCells()
        configureDataSource()
        setupSearchController()
        bindSearchTextPublisher()
        
        if viewModel.hasTodosInCoreData() {
            viewModel.fetchTodos()
        } else {
            Task { await viewModel.loadAllTodos() }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.rightBarButtonItem = topTrailingBarButton
    }
    
    private func setupViews() {
        title = Constants.title
        containerStackView.addArrangedSubview(shimmerView)
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search todos..."
        searchController.searchBar.tintColor = .black
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bindSearchTextPublisher() {
        searchTextPublisher
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }
                self.performSearch(with: searchText)
            }.store(in: &cancellables)
    }
    
    private func performSearch(with searchText: String) {
        if searchText.isEmpty {
            snapshot(todos: viewModel.todos)
        } else {
            let filteredTodos = viewModel.filterTodos(searchText)
            snapshot(todos: filteredTodos)
        }
    }
    
    private func setupViewBinding() {
        viewModel.$isLoading
            .combineLatest(viewModel.$todos)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] isLoading, todos in
                guard let self else { return }
                collectionView.isHidden = isLoading
                shimmerView.isHidden = !isLoading
                snapshot(todos: todos)
            }.store(in: &cancellables)
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: TodoCVCell.className, bundle: nil),
                                forCellWithReuseIdentifier: TodoCVCell.className)
        collectionView.collectionViewLayout = todoListCollectionViewLayout()
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {[weak self] in
            self?.configureCell(collectionView: $0, $1, todo: $2)
        }
    }
    
    private func configureCell(
        collectionView: UICollectionView,
        _ indexPath: IndexPath,
        todo: Todo
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCVCell.className, for: indexPath) as! TodoCVCell
        cell.configureCell(.init(todo: todo))
        return cell
    }
    
    private func snapshot(todos: [Todo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Todo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(todos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func todoListCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc func presentNewTodo() {
        presentAddNewTodoViewController()
    }
}

//MARK: - Collection View Delegate Methods
extension TodoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
         let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
             guard let self else { return UIMenu(title: "", children: []) }
             
             let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) {[weak self] action in
                 guard let self else { return }
                 viewModel.deleteTodo(at: indexPath.row)
                 snapshot(todos: viewModel.todos)
             }
             
             return UIMenu(title: "", children: [deleteAction])
         }
         
         return configuration
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !searchController.isActive {
            viewModel.updateCompleteTodo(at: indexPath.row)
        }
    }
    
    private func presentAddNewTodoViewController() {
        let vc = NewTodoViewController()
        vc.transitioningDelegate = self
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
}

//MARK: - Custom Presentation

extension TodoListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK: - Add New Note & Search Delegate Method

extension TodoListViewController: AddNewTodoDelegate, UISearchResultsUpdating {
    func addNewTodo(todo: Todo) {
        viewModel.addNewTodo(todo)
        var todos = dataSource.snapshot().itemIdentifiers
        todos.insert(todo, at: 0)
        snapshot(todos: todos)
        
        DispatchQueue.main.async {[weak self] in
            guard let self else { return }
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchTextPublisher.send(searchText)
        }
    }
}
