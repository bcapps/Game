//
//  DamageReductionCollectionViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class EffectsTableViewController: UITableViewController {
    enum EffectSections: Int {
        case Attack
        case Avoidance
        case Reduction
    }
    
    var hero: Hero?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case EffectSections.Attack.rawValue:
            return AttackModifier.allAttackModifierTypes.count
        case EffectSections.Avoidance.rawValue:
            return DamageAvoidance.allAvoidanceTypes.count
        case EffectSections.Reduction.rawValue:
            return DamageReduction.allReductionTypes.count
        default:
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    private func titleForSection(section: Int) -> String? {
        switch section {
        case EffectSections.Attack.rawValue:
            return "+ Attack"
        case EffectSections.Avoidance.rawValue:
            return "+ Avoid"
        case EffectSections.Reduction.rawValue:
            return "- Reduce"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = titleForSection(section) else { return nil }
        
        return EffectsHeaderView.headerViewWithText(title, width: tableView.bounds.size.width)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EffectCellReuseIdentifier", forIndexPath: indexPath) as? EffectCell
        cell?.backgroundColor = tableView.backgroundColor
        
        switch indexPath.section {
        case EffectSections.Avoidance.rawValue:
            configureAvoidanceCellForIndexPath(cell, indexPath: indexPath)
        case EffectSections.Reduction.rawValue:
            configureReductionCellForIndexPath(cell, indexPath: indexPath)
        case EffectSections.Attack.rawValue:
            configureAttackModifierCellForIndexPath(cell, indexPath: indexPath)
        default:
            print("Unconfigured cell")
        }
        
        return cell ?? UITableViewCell()
    }
    
    private func configureAvoidanceCellForIndexPath(cell: EffectCell?, indexPath: NSIndexPath) {
        let avoidanceType = avoidanceTypeForIndexPath(indexPath)
        let avoidanceValue = avoidanceValueForReductionType(avoidanceType)
        
        cell?.effectImageView.image = avoidanceType.image
        cell?.effectLabel.attributedText = NSAttributedString(string: avoidanceType.rawValue + ": " + "\(avoidanceValue)", attributes: [NSFontAttributeName: UIFont.verySmallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
    }
    
    private func configureReductionCellForIndexPath(cell: EffectCell?, indexPath: NSIndexPath) {
        let reductionType = reductionTypeForIndexPath(indexPath)
        let reductionValue = reductionValueForReductionType(reductionType)
        
        cell?.effectImageView.image = reductionType.image
        cell?.effectLabel.attributedText = NSAttributedString(string: reductionType.rawValue + ": " + "\(reductionValue)", attributes: [NSFontAttributeName: UIFont.verySmallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
    }
    
    private func configureAttackModifierCellForIndexPath(cell: EffectCell?, indexPath: NSIndexPath) {
        let modifierType = attackModifierTypeForIndexPath(indexPath)
        let modifierValue = attackModifierValueForModifierType(modifierType)
        
        cell?.effectImageView.image = modifierType.image
        cell?.effectLabel.attributedText = NSAttributedString(string: modifierType.rawValue + ": " + "\(modifierValue)", attributes: [NSFontAttributeName: UIFont.verySmallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
    }
    
    private func avoidanceTypeForIndexPath(indexPath: NSIndexPath) -> DamageAvoidance.AvoidanceType {
        return DamageAvoidance.allAvoidanceTypes[indexPath.row]
    }
    
    private func avoidanceValueForReductionType(type: DamageAvoidance.AvoidanceType) -> Int {
        guard let hero = hero else { return 0 }
        
        return hero.damageAvoidanceForAvoidanceType(type)
    }
    
    private func reductionTypeForIndexPath(indexPath: NSIndexPath) -> DamageReduction.ReductionType {
        return DamageReduction.allReductionTypes[indexPath.row]
    }
    
    private func reductionValueForReductionType(type: DamageReduction.ReductionType) -> Int {
        guard let hero = hero else { return 0 }
        
        return hero.damageReductionForReductionType(type)
    }
    
    private func attackModifierTypeForIndexPath(indexPath: NSIndexPath) -> AttackModifier.AttackModifierType {
        return AttackModifier.allAttackModifierTypes[indexPath.row]
    }
    
    private func attackModifierValueForModifierType(type: AttackModifier.AttackModifierType) -> Int {
        guard let hero = hero else { return 0 }
        
        return hero.attackModifierForModifierType(type)
    }
}

private class EffectsHeaderView {
    static func headerViewWithText(text: String, width: CGFloat) -> UITableViewHeaderFooterView {
        let containingView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: width, height: 30))
        containingView.contentView.backgroundColor = .backgroundColor()
        
        let labelFrame = CGRect(x: 0, y: 0, width: CGRectGetWidth(containingView.frame), height: CGRectGetHeight(containingView.frame))
        let label = UILabel(frame: labelFrame)
        
        label.attributedText =  NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.headerTextColor()])
        label.textAlignment = .Left
        
        containingView.addSubview(label)
        
        return containingView
    }
}
