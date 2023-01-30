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
    @IBOutlet private weak var learnMoreButton: UIButton!

    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var playingTimeLabel: UILabel!
    @IBOutlet private weak var minimumPlayingTimeLabel: UILabel!
    @IBOutlet private weak var maximumPlayingTimeLabel: UILabel!

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    private var detailViewModel: DetailViewModel!
    private var isLearnMoreButtonTapped: Bool = false

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
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }

    @IBAction func learnMoreTapped(_ sender: UIButton) {
        isLearnMoreButtonTapped.toggle()

        if isLearnMoreButtonTapped {
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
            learnMoreButton.setTitle("Learn Less", for: .normal)
        } else {
            descriptionLabel.numberOfLines = 2
            descriptionLabel.lineBreakMode = .byTruncatingTail
            learnMoreButton.setTitle("Learn More", for: .normal)
        }
    }

}

private extension DetailViewController {

    func configureStyle() {
        nameLabel.textColor = .primaryTitleColor
        minimumPlayerLabel.textColor = .secondaryTitleColor
        maximumPlayerLabel.textColor = .secondaryTitleColor
        categoryLabel.textColor = .secondaryTitleColor
        publisherLabel.textColor = .secondaryTitleColor
        ageLabel.textColor = .secondaryTitleColor
        playingTimeLabel.textColor = .secondaryTitleColor
        minimumPlayingTimeLabel.textColor = .secondaryTitleColor
        maximumPlayingTimeLabel.textColor = .secondaryTitleColor
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
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byTruncatingTail

        maximumPlayerLabel.text = detailViewModel.maxPlayer
        maximumPlayerLabel.isHidden = detailViewModel.isMaxPlayerHidden
        minimumPlayerLabel.text = detailViewModel.minPlayer
        minimumPlayerLabel.isHidden = detailViewModel.isMinPlayerHidden

        categoryLabel.text = detailViewModel.category
        categoryLabel.isHidden = detailViewModel.isCategoryHidden
        publisherLabel.text = detailViewModel.publisher
        publisherLabel.isHidden = detailViewModel.ispublisherHidden

        ageLabel.text = detailViewModel.age
        ageLabel.isHidden = detailViewModel.isAgeHidden
        playingTimeLabel.text = detailViewModel.playingTime
        playingTimeLabel.isHidden = detailViewModel.isPlayingTimeHidden
        minimumPlayingTimeLabel.text = detailViewModel.minimumPlayingTime
        minimumPlayingTimeLabel.isHidden = detailViewModel.isMinimumPlayingTimeHidden
        maximumPlayingTimeLabel.text = detailViewModel.maximumPlayingTime
        maximumPlayingTimeLabel.isHidden = detailViewModel.ismMaximumPlayingTimeHidden

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
