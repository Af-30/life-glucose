//
//  UIView+.swift
//  Life Glucose
//
//  Created by grand ahmad on 07/06/1443 AH.
//

import UIKit

extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil,
                width: NSLayoutAnchor<NSLayoutDimension>? = nil,
                height: NSLayoutAnchor<NSLayoutDimension>? = nil,
                widthConstant: CGFloat = .zero,
                heightConstant: CGFloat = .zero,
                padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: 0).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: 0).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalTo: width, constant: widthConstant).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalTo: height, constant: heightConstant).isActive = true
        }
        
        if width == nil && widthConstant != .zero {
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        
        if height == nil && heightConstant != .zero {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }
    
}
