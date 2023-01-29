//
//  DetailViewController.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import UIKit

final class DetailViewController: UIViewController {

    // MARK: - properties

    @IBOutlet private weak var imageContainerView: UIView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        fetchGameDetails()
        configureStyle()
    }

    override func viewWillAppear(_ animated: Bool) {
        imageView.isHidden = true
        imageContainerView.isHidden = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.view.frame = CGRect(origin: .zero, size: view.bounds.size)
        self.view.setNeedsDisplay()
    }
}

private extension DetailViewController {

    func configureStyle() {
        nameLabel.textColor = .primaryTitleColor
        minimumPlayerLabel.textColor = .secondaryTitleColor
        maximumPlayerLabel.textColor = .secondaryTitleColor
        categoryLabel.textColor = .secondaryTitleColor
        publisherLabel.textColor = .secondaryTitleColor
    }

    func configureViewModel() {
        detailViewModel = DetailViewModel(boardGameService: BoardGameService(parser: DetailParser()))
    }

    func fetchGameDetails() {
        Task { [weak self] in
            do {
                self?.activityIndicatorView.startAnimating()
                navigationItem.hidesBackButton = true

                guard let objectID = objectID else { return }
                try await detailViewModel.getGameDetails(objectID: objectID)
                showDetails()

                self?.activityIndicatorView.stopAnimating()
                navigationItem.hidesBackButton = false
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

        showImage()
    }

    func showImage() {
        Task { [weak self] in
            do {
                if let imageURL = detailViewModel.imageURL {
                   let imageData = try await detailViewModel.getImageData(url: imageURL)
                    self?.imageView.image = UIImage(data: imageData)
                    self?.imageView.isHidden = detailViewModel.isImageHidden
                    imageContainerView.isHidden = detailViewModel.isImageHidden
                }
            } catch {
                // throw error
            }
        }
    }
    
}
