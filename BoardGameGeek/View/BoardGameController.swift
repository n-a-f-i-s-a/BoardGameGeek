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
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

extension BoardGameViewController: UISearchResultsUpdating{

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text,
              searchString.isEmpty == false else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.activityIndicatorView.startAnimating()

            self?.boardGameViewModel.getGames(searchString: searchString.trimmingCharacters(in: .whitespacesAndNewlines)) { [weak self] in
                // refresh table
                DispatchQueue.main.async {
                    self?.activityIndicatorView.stopAnimating()
                    self?.tableView.reloadData()
                }
            }
        }

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! BoardGameTableViewCell
        cell.configure(
            title: boardGameViewModel.getTitle(row: indexPath.row),
            year: boardGameViewModel.getYear(row: indexPath.row)
        )
        return cell
    }
    
}
