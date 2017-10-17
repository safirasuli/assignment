//
//  RoundButton.swift
//  WeatherStation
//
//  Created by J.A. Korten on 06-03-17.
//  Copyright © 2017 HAN University of Applied Sciences Educational. All rights reserved.
//

import UIKit

@IBDesignable public class RoundButton: UIButton {


    @IBInspectable var borderColor: UIColor = UIColor.blue {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.2 {
        didSet {
            layer.cornerRadius = cornerRadius * bounds.size.width
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius * bounds.size.width
        clipsToBounds = true
    }

}

