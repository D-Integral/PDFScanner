//
//  UIViewExtensions.swift
//  PDFReaderApp
//
//  Created by Dmytro Skorokhod on 10/01/2024.
//

import UIKit

extension UIView {
    public func pinToInside(_ child: UIView, padding: UIEdgeInsets = .zero) {
        child.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(child)
        
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                           constant: padding.left
            ),
            child.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                            constant: padding.right
            ),
            child.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                constant: padding.top
            ),
            child.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                          constant: padding.bottom
            )
        ])
    }
}
