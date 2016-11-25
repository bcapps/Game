//
//  DiceRollerCell.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class DiceRollerCell: UITableViewCell {
    @IBOutlet weak var diceStepperView: DiceStepperView!
    @IBOutlet weak var diceImageView: UIImageView!
    @IBOutlet weak var numberRolledLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .backgroundColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        diceStepperView.diceCountLabel.attributedText = nil
        numberRolledLabel.attributedText = nil
    }
}

final class DiceStepperView: UIView {
    
    var stepperHasChanged: ((DiceStepperView) -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .backgroundColor()
    }
    
    @IBOutlet weak var diceCountLabel: UILabel!
    @IBOutlet weak var diceCountStepper: UIStepper!
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperHasChanged?(self)
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return viewFromNib(nil)
    }
}
