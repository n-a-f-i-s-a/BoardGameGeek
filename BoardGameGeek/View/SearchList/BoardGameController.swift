//
//  ViewController.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import UIKit

final class BoardGameViewController: UIViewController {

    // MARK: - Type

    typealias Section = BoardGameViewModel.Section
    typealias Item = BoardGameViewModel.Item

    // MARK: - properties

    private var storyBoardName: String = "Main"
    private var boardGameViewModel: BoardGameViewModel!
    private var searchController: UISearchController!
    private lazy var dataSource = configureDataSource()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureTableView()
        configureSearchBar()
        configureStyle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        searchController.searchBar.resignFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        searchController.searchBar.resignFirstResponder()
    }

}

private extension BoardGameViewController {

    func configureViewModel() {
        boardGameViewModel = BoardGameViewModel(boardGameService: BoardGameService(parser: SearchResultParser()))
    }

    func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
    }

    func configureStyle() {
        tableView.separatorColor = .separatorColor
        tableView.separatorInset = .zero

        searchController.searchBar.searchTextField.textColor = .searchBarColor
    }

    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a boardgame"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked
    }

    func evaluateState() {
        switch boardGameViewModel.state {
        case .loading:
            self.update(with: boardGameViewModel.boardGames, animate: false)
            self.activityIndicatorView.startAnimating()
            self.tableView.isUserInteractionEnabled = false
        case .empty:
            self.activityIndicatorView.stopAnimating()
            self.tableView.isUserInteractionEnabled = true
            self.update(with: boardGameViewModel.boardGames, animate: false)
        case .loaded:
            self.tableView.isUserInteractionEnabled = true
            self.update(with: boardGameViewModel.boardGames, animate: false)
            self.activityIndicatorView.stopAnimating()
        case .idle:
            break
        }
    }

}

// MARK:- UISearchBarDelegate

extension BoardGameViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        boardGameViewModel.boardGames = []
        boardGameViewModel.state = .idle
        self.update(with: boardGameViewModel.boardGames, animate: false)
        self.activityIndicatorView.stopAnimating()
        searchController.searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchController.searchBar.text,
              searchString.isEmpty == false else { return }

        Task { [weak self] in
            do {
                boardGameViewModel.boardGames = []
                boardGameViewModel.state = .loading
                evaluateState()
                try await boardGameViewModel.getGames(searchString: searchString)
                evaluateState()
            } catch {
                self?.searchController.searchBar.text = ""
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.isUserInteractionEnabled = true
                self?.showError(error)
            }
        }

        searchController.searchBar.endEditing(true)
    }

}

// MARK: - datsource

private extension BoardGameViewController {

    func update(with boardGames: [BoardGame], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        let allBoardGamesItems = boardGames.map { BoardGameViewModel.Item.boardGame($0)}
        snapshot.appendItems(allBoardGamesItems, toSection: .basicInfo)

        if boardGameViewModel.state == .empty {
            snapshot.appendItems([BoardGameViewModel.Item.empty(1)], toSection: .empty)
        }

        dataSource.apply(snapshot, animatingDifferences: animate)
    }

    func configureDataSource() -> UITableViewDiffableDataSource<Section, Item> {
        return UITableViewDiffableDataSource<Section, Item>(
            tableView: tableView,
            cellProvider: { [unowned self] tableView, indexPath, boardGameItem in

                let sectionType = Section.allCases[indexPath.section]

                switch sectionType {
                case .basicInfo:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: BoardGameTableViewCell.reuseIdentifer,
                        for: indexPath) as? BoardGameTableViewCell else { fatalError("Could not create new cell") }

                    if case let .boardGame(item) = boardGameItem {
                        cell.configure(
                            boardGameCellViewModel: BoardGameCellViewModel(
                                title: item.name,
                                year: self.boardGameViewModel.getYear(boardGame: item)
                            )
                        )
                    }
                    return cell
                case .empty:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: EmptyTableViewCell.reuseIdentifer,
                        for: indexPath) as? EmptyTableViewCell else { fatalError("Could not create new cell") }
                    cell.configure(emptyCellViewModel: EmptyTableCellViewModel())
                    return cell
                }
            }
        )
    }

}


// MARK: - UITableViewDelegate

extension BoardGameViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = DetailViewController.instantiateFromStoryboard(storyboardName: storyBoardName)
        nextViewController.objectID = boardGameViewModel.selectItem(row: indexPath.row)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
