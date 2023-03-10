//
//  BoardGameTableViewCell.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import UIKit

final class BoardGameTableViewCell: UITableViewCell {

    // MARK: - properties

    static let reuseIdentifer = "gameCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = .disclosureIndicator
    }

    override func prepareForReuse() {
        self.yearLabel.isHidden = false
    }

    func configure(boardGameCellViewModel: BoardGameCellViewModel) {
        self.titleLabel.text = boardGameCellViewModel.title
        self.yearLabel.text = boardGameCellViewModel.year
        self.yearLabel.isHidden = boardGameCellViewModel.isYearHidden

        configureStyle()
    }

    func configureStyle() {
        titleLabel.textColor = .primaryTitleColor
        yearLabel.textColor = .secondaryTitleColor
    }

}
