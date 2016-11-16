//
//  MonthViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/16/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class MonthViewController: UICollectionViewController {
    var month: Month?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .backgroundColor()
        
        let layout = ColumnLayout(numberOfColumns: 7, rowHeight: 55)
        layout.headerReferenceSize = CGSize(width: 0, height: 40)
        
        collectionView?.collectionViewLayout = layout
    }
}

extension MonthViewController {
    
    private static let DayCellReuseIdentifier = "DayCellReuseIdentifier"
    private static let MonthHeaderReuseIdentifier = "MonthHeaderReuseIdentifier"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return month?.days ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthViewController.DayCellReuseIdentifier, for: indexPath) as? MonthDayCell
        let day = indexPath.row + 1
        
        cell?.backgroundColor = collectionView.backgroundColor
        cell?.dayNumberLabel.attributedText = NSAttributedString(string: String(day), attributes: [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
        
        cell?.highlightView.isHidden = !(month?.name == Month.currentMonthName && day == Month.currentMonthDay)
        
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MonthViewController.MonthHeaderReuseIdentifier, for: indexPath) as? MonthHeaderView else { return UICollectionReusableView() }
            
            headerView.monthNameLabel.attributedText = NSAttributedString(string: month?.name ?? "", attributes: [NSFontAttributeName: UIFont.headingFont(), NSForegroundColorAttributeName: UIColor.headerTextColor()])
            return headerView
        }
        
        return UICollectionReusableView()
    }
}
