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

    // MARK: - properties

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
        //tableView.delegate = self
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Boardgames"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

}

// MARK:- UISearchBarDelegate

extension BoardGameViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        boardGameViewModel.boardGames = []
        self.update(with: boardGameViewModel.boardGames, animate: false)
        self.activityIndicatorView.stopAnimating()
        searchController.searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchController.searchBar.text,
              searchString.isEmpty == false else { return }

        Task { [weak self] in
            do {
                self?.activityIndicatorView.startAnimating()
                self?.tableView.isUserInteractionEnabled = false
                try await boardGameViewModel.getGames(searchString: searchString)
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.isUserInteractionEnabled = true
                self?.update(with: boardGameViewModel.boardGames, animate: false)

            } catch {
                self?.searchController.searchBar.text = ""
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.isUserInteractionEnabled = true
                showError(error)
            }
        }

        searchController.searchBar.endEditing(true)
    }

}

// MARK: - datsource

private extension BoardGameViewController {

    func update(with boardGames: [BoardGame], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BoardGame>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(boardGames, toSection: .basicInfo)

        dataSource.apply(snapshot, animatingDifferences: animate)
    }

    func configureDataSource() -> UITableViewDiffableDataSource<BoardGameViewModel.Section, BoardGame> {
        return UITableViewDiffableDataSource<Section, BoardGame>(
            tableView: tableView,
            cellProvider: { [unowned self] tableView, indexPath, boardGame in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: BoardGameTableViewCell.reuseIdentifer,
                    for: indexPath) as? BoardGameTableViewCell else { fatalError("Could not create new cell") }

                cell.configure(
                    title: boardGame.name,
                    year: self.boardGameViewModel.getYear(boardGame: boardGame)
                )
                return cell
            }
        )
    }

}
