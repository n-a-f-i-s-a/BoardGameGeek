//
//  BoardGameTableViewCell.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import UIKit

final class BoardGameTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(title: String, year: String) {
        self.titleLabel.text = title
        self.yearLabel.text = year
    }

}
