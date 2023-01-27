//
//  DetailViewController.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import UIKit

final public class DetailViewController: UIViewController {

    // MARK: - properties

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!

    @IBOutlet private weak var minimumPlayerLabel: UILabel!
    @IBOutlet private weak var maximumPlayerLabel: UILabel!

    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!

    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

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
                    self?.activityIndicatorView.startAnimating()
                // disable back button

                guard let objectID = objectID else { return }
                 try await detailViewModel.getGameDetails(objectID: objectID)
                showDetails()
                 self?.activityIndicatorView.stopAnimating()
                 // enable back button
            } catch {
                print(error) // handle later
            }
        }
    }

    func showDetails() {
        nameLabel.text = detailViewModel.name
        yearLabel.text = detailViewModel.year
        descriptionLabel.text = detailViewModel.description

        maximumPlayerLabel.text = detailViewModel.maxPlayer
        maximumPlayerLabel.isHidden = detailViewModel.isMaxPlayerHidden
        minimumPlayerLabel.text = detailViewModel.minPlayer
        minimumPlayerLabel.isHidden = detailViewModel.isMinPlayerHidden

        categoryLabel.text = detailViewModel.category
        categoryLabel.isHidden = detailViewModel.isCategoryHidden
        publisherLabel.text = detailViewModel.publisher
        publisherLabel.isHidden = detailViewModel.ispublisherHidden
    }
    
}
