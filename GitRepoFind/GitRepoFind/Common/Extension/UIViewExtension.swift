//
//  UIViewExtension.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 18/09/2021.
//

import Foundation
import UIKit

extension UIView {
    
    /// To add both courner radius and shadow to any UIView
    /// - Parameters:
    ///   - cornerRadius:   value for view's corner
    func setCornerRadiusWithShadow(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
    }
}
