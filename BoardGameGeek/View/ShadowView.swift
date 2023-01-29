//
//  ShadowView.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 29/1/2023.
//

import UIKit

@IBDesignable
class ShadowView: UIView {

    @IBInspectable
    var shadowColor: CGColor? {
        get {
            return layer.shadowColor
        }
        set {
            layer.shadowColor = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
        var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.clipsToBounds = false
        self.shadowColor = UIColor.shadowColor.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = CGSize.zero
        self.shadowRadius = 10
        self.cornerRadius = self.frame.height / 2
        self.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.backgroundColor = .clear

    }

}



