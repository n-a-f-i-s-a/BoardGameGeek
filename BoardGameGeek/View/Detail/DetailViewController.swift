//
//  DetailViewController.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import UIKit

final public class DetailViewController: UIViewController {

    // MARK: - properties

    private var detailViewModel: DetailViewModel!

    public var objectID: String?

    // MARK: - ViewController lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        fetchGameDetails()
    }

}

private extension DetailViewController {

    func configureViewModel() {
        detailViewModel = DetailViewModel(boardGameService: BoardGameService(parser: DetailParser()))
    }

    func fetchGameDetails() {
        Task { [weak self] in
            do {
                // self.activityIndicatorView.startAnimating()
                // disable back button

                guard let objectID = objectID else { return }
                 try await detailViewModel.getGameDetails(objectID: objectID) 
                 //self.activityIndicatorView.stopAnimating()
                 // enable back button
            } catch {
                print(error) // handle later
            }
        }
    }
    
}
