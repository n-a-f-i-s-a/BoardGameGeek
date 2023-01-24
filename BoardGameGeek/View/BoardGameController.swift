//
//  ViewController.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import UIKit

final class BoardGameViewController: UIViewController {

    // MARK: - properties

    private var boardGameViewModel: BoardGameViewModel!
    private var searchController: UISearchController!
    private var cellIdentifier = "gameCell"
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureTableView()
        configureSearchBar()
    }

}

private extension BoardGameViewController {

    func configureViewModel() {
        boardGameViewModel = BoardGameViewModel(boardGameEndPoint: BoardGameService())
    }

    func configureTableView() {
        tableView.dataSource = self
        //tableView.delegate = self
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
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

// MARK:- UISearchResultsUpdating

extension BoardGameViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text,
              searchString.isEmpty == false else { return }

        Task { [weak self] in
            do {
                self?.activityIndicatorView.startAnimating()
                try await boardGameViewModel.getGames(searchString: searchString)
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.reloadData()
            } catch {
                self?.searchController.searchBar.text = ""
                self?.activityIndicatorView.stopAnimating()
                showError(error)
            }
        }
    }

}

// MARK:- UISearchBarDelegate

extension BoardGameViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        boardGameViewModel.boardGames = []
        tableView.reloadData()
    }
}

// MARK:- UITableViewDataSource

extension BoardGameViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return boardGameViewModel.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardGameViewModel.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BoardGameTableViewCell
        cell.configure(
            title: boardGameViewModel.getTitle(row: indexPath.row),
            year: boardGameViewModel.getYear(row: indexPath.row)
        )
        return cell
    }
    
}
