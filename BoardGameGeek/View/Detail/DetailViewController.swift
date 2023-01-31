//
//  DetailViewController.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import UIKit

final class DetailViewController: UIViewController, ViewModelProtocol {

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

    var viewModel: DetailViewModel!
    private var isLearnMoreButtonTapped: Bool = false

    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchGameDetails()
        configureStyle()
    }

    override func viewWillAppear(_ animated: Bool) {
        imageView.isHidden = true
        imageContainerView.isHidden = true
        learnMoreButton.isHidden = true
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

    func fetchGameDetails() {
        Task { [weak self] in
            do {
                self?.activityIndicatorView.startAnimating()
                navigationItem.hidesBackButton = true

                try await viewModel.getGameDetails()
                showDetails()

                self?.activityIndicatorView.stopAnimating()
                navigationItem.hidesBackButton = false
            } catch {
                self?.activityIndicatorView.stopAnimating()
                navigationItem.hidesBackButton = false
                self?.showError(error)
            }
        }
    }

    func showDetails() {
        nameLabel.text = viewModel.name
        yearLabel.text = viewModel.year
        descriptionLabel.text = viewModel.description
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byTruncatingTail
        learnMoreButton.isHidden = false

        maximumPlayerLabel.text = viewModel.maxPlayer
        maximumPlayerLabel.isHidden = viewModel.isMaxPlayerHidden
        minimumPlayerLabel.text = viewModel.minPlayer
        minimumPlayerLabel.isHidden = viewModel.isMinPlayerHidden

        categoryLabel.text = viewModel.category
        categoryLabel.isHidden = viewModel.isCategoryHidden
        publisherLabel.text = viewModel.publisher
        publisherLabel.isHidden = viewModel.isPublisherHidden

        ageLabel.text = viewModel.age
        ageLabel.isHidden = viewModel.isAgeHidden
        playingTimeLabel.text = viewModel.playingTime
        playingTimeLabel.isHidden = viewModel.isPlayingTimeHidden
        minimumPlayingTimeLabel.text = viewModel.minimumPlayingTime
        minimumPlayingTimeLabel.isHidden = viewModel.isMinimumPlayingTimeHidden
        maximumPlayingTimeLabel.text = viewModel.maximumPlayingTime
        maximumPlayingTimeLabel.isHidden = viewModel.isMaximumPlayingTimeHidden

        showImage()
    }

    func showImage() {
        Task { [weak self] in
            do {
                if let imageURL = viewModel.imageURL {
                   let imageData = try await viewModel.getImageData(url: imageURL)
                    self?.imageView.image = UIImage(data: imageData)
                    self?.imageView.isHidden = viewModel.isImageHidden
                    imageContainerView.isHidden = viewModel.isImageHidden
                }
            } catch {
                self?.showError(error)
            }
        }
    }
    
}
