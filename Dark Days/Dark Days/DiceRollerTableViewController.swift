//
//  DiceRollerTableViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class DiceRollerTableViewController: UITableViewController {
    
    var currentDiceTotals: [Dice: Int] = [.d2:1, .d4:1, .d6:1, .d8:1, .d10:1, .d12:1, .d20:1]
    var currentDiceResults: [Dice: Int] = [.d2:0, .d4:0, .d6:0, .d8:0, .d10:0, .d12:0, .d20:0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .backgroundColor()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80.0
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    @IBAction func rollButtonTapped(_ sender: UIBarButtonItem) {
        rollAllDice()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            rollAllDice()
        }
    }
    
    private func rollAllDice() {
        for (key, value) in currentDiceTotals {
            currentDiceResults[key] = DiceRoller.roll(dice: key, count: value)
        }
        
        tableView.reloadData()
    }
}

extension DiceRollerTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dice.numberOfTypesOfDice
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiceRollerCell", for: indexPath) as? DiceRollerCell else { return UITableViewCell() }
        guard let dice = Dice(rawValue: indexPath.row) else { return UITableViewCell() }
        guard let diceTotal = currentDiceTotals[dice] else { return UITableViewCell() }
        
        cell.diceImageView.image = dice.image
        cell.diceStepperView.diceCountLabel.attributedText = NSAttributedString.attributedStringWithBodyAttributes(String(diceTotal))
        
        cell.diceStepperView.stepperHasChanged = { [weak self] stepperView in
            let stepperValue = Int(stepperView.diceCountStepper.value)
            let newString = NSAttributedString.attributedStringWithBodyAttributes(String(stepperValue))
            stepperView.diceCountLabel.attributedText = newString
            
            self?.currentDiceTotals[dice] = stepperValue
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        
        if let result = currentDiceResults[dice], result > 0 {
            cell.numberRolledLabel.attributedText = NSAttributedString.attributedStringWithAttributes(String(result), color: .headerTextColor(), font: .heavyExtraLargeFont(), paragraphStyle: paragraphStyle)
        }
        
        return cell
    }
}
