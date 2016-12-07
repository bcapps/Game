//
//  MonthDayCell.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/16/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class MonthDayCell: UICollectionViewCell {
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
        
    override func layoutSubviews() {
        super.layoutSubviews()

        highlightView.layer.cornerRadius = highlightView.bounds.width / 2.0
    }
}
