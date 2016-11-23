//
//  StatusesTableViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/14/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class StatusesCollectionViewController: UICollectionViewController {
    let statuses: [StatusEffect] = ObjectProvider.objectsForJSON("StatusEffects").sorted { $0.name < $1.name }
    
    var hero: Hero? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.collectionViewLayout = ColumnLayout(numberOfColumns: 3, rowHeight: 75)
        collectionView?.backgroundColor = .backgroundColor()
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
        cell?.checkBox.setOn(hero?.currentStatusEffects.contains(status) ?? false, animated: false)
        
        return cell ?? UICollectionViewCell()
    }
}

extension StatusesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? StatusEffectCell else { return }
        guard let hero = hero else { return }
        
        var enableBox: Bool = true
        let status = statuses[indexPath.row]

        if hero.currentStatusEffects.contains(status) {
            enableBox = false
            hero.currentStatusEffects.removeObject(status)
        } else {
            enableBox = true
            hero.currentStatusEffects.append(status)
        }
        
        selectedCell.checkBox.setOn(enableBox, animated: true)
    }
}
