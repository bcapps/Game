//
//  StatusEffectLayout.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/15/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

public class StatusEffectLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    private func setupLayout() {
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .vertical
    }
    
    override public var itemSize: CGSize {
        set { }
        get {
            let numberOfColumns: CGFloat = 3
            
            let totalSpace = sectionInset.left + sectionInset.right + (minimumInteritemSpacing * (numberOfColumns - 1))
            let width = Int((collectionView?.bounds.width ?? 0 - totalSpace) / numberOfColumns)
            
            return CGSize(width: width, height: 75)
        }
    }
}
