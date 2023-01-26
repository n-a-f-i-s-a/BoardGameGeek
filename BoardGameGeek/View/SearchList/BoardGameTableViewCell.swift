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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        self.yearLabel.isHidden = false
    }

    func configure(title: String, year: String) {
        self.titleLabel.text = title
    
        if year.isEmpty == false {
            self.yearLabel.text = year
        } else {
            self.yearLabel.isHidden = true
        }
    }

}
