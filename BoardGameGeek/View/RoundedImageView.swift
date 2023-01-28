//
//  PrettyImageView.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 28/1/2023.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    override init(image: UIImage?) {
        super.init(image: image)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }

}



