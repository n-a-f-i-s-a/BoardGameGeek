//
//  EmptyTableViewCell.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 28/1/2023.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    // MARK: - properties

    static let reuseIdentifer = "emptyCell"
    
    @IBOutlet private weak var emptyMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(emptyCellViewModel: EmptyTableCellViewModel) {
        emptyMessageLabel.text = emptyCellViewModel.title

        configureStyle()
    }

    func configureStyle() {
        emptyMessageLabel.textColor = .secondaryTitleColor
        
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }

}
