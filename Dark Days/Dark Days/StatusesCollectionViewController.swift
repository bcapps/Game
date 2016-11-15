//
//  StatusesTableViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/14/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class StatusesCollectionViewController: UICollectionViewController {
    let statuses: [StatusEffect] = ObjectProvider.objectsForJSON("StatusEffects")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .backgroundColor()
        //collectionView.estimatedRowHeight = 40
    }
}

extension StatusesCollectionViewController {
    
    private static let StatusEffectCellReuseIdentifier = "StatusEffectCellReuseIdentifier"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusesCollectionViewController.StatusEffectCellReuseIdentifier, for: indexPath) as? StatusEffectCell
        let status = statuses[indexPath.row]
        
        cell?.backgroundColor = collectionView.backgroundColor
        cell?.nameLabel.attributedText = NSAttributedString(string: status.name, attributes: [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])

        return cell ?? UICollectionViewCell()
    }
}
