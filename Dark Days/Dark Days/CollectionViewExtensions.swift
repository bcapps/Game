//
//  CollectionViewExtensions.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

/**
 Extension of `UICollectionView` that adds convenience methods for cell registration.
 */
extension UICollectionView {
    
    /**
     Registers the cell of a particular class that has a corresponding nib of the same name with the collection view under the specified reuse identifier.
     
     - parameter cellClass:         The class of the collection view cell to register.
     - parameter reuseIdentifier:   The reuse identifier for the cell.
     */
    func registerNibForClass(cellClass: UICollectionViewCell.Type, reuseIdentifier: String) {
        registerNib(UINib(nibName: cellClass.defaultNibName(), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    /**
     Registers the collection reusable view of a particular class that has a corresponding nib of the same name with the collection view under the specified reuse identifier.
     
     - parameter supplementaryViewClass: The class of the collection reusable view to register.
     - parameter elementKind:            The kind of supplementary view to create.
     - parameter identifier:             The reuse identifier for the collection reusable view.
     */
    func registerNibForClass(supplementaryViewClass: UICollectionReusableView.Type, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        registerNib(UINib(nibName: supplementaryViewClass.defaultNibName(), bundle: nil), forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
    }
}
