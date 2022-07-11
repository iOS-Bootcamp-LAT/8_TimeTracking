//
//  FloatingButton.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 6/30/22.
//

import Foundation
import UIKit

class FloatingButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.widthAnchor.constraint(equalToConstant: 56).isActive = true
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true
        self.layer.cornerRadius = 28
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        
        self.backgroundColor = UIColor(red: 1/255, green: 70/255, blue: 175/255, alpha: 1)
        
        self.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        
        self.setTitle("", for: .normal)
        
        self.tintColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        
        
    }
    
    func show() {

        UIView.animate(withDuration: 0.5, animations: {

            self.alpha = 1.0

            self.isEnabled = true

            self.isHidden = false

            self.layoutIfNeeded()

        })

    }


    func hide() {

        UIView.animate(withDuration: 0.5, animations: {

            self.alpha = 0

        }, completion: { _ in

            self.isEnabled = false

            self.isHidden = true

            self.layoutIfNeeded()

        })

    }
    
    
}
