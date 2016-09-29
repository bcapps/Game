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
        case damage
        case attack
        case avoidance
        case reduction
    }
    
    var hero: Hero?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor()
        tableView.estimatedSectionHeaderHeight = 40
        tableView.estimatedRowHeight = 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case EffectSections.damage.rawValue:
            return DamageModifier.allDamageModifierTypes.count
        case EffectSections.attack.rawValue:
            return AttackModifier.allAttackModifierTypes.count
        case EffectSections.avoidance.rawValue:
            return DamageAvoidance.allAvoidanceTypes.count
        case EffectSections.reduction.rawValue:
            return DamageReduction.allReductionTypes.count
        default:
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    fileprivate func titleForSection(_ section: Int) -> String? {
        switch section {
        case EffectSections.damage.rawValue:
            return "Damage"
        case EffectSections.attack.rawValue:
            return "Attack"
        case EffectSections.avoidance.rawValue:
            return "Avoid"
        case EffectSections.reduction.rawValue:
            return "Reduce"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = titleForSection(section) else { return nil }
        
        return EffectsHeaderView.headerViewWithText(title, width: tableView.bounds.size.width)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EffectCellReuseIdentifier", for: indexPath) as? EffectCell
        cell?.backgroundColor = tableView.backgroundColor
        
        switch (indexPath as NSIndexPath).section {
        case EffectSections.damage.rawValue:
            configureDamageCellForIndexPath(cell, indexPath: indexPath)
        case EffectSections.avoidance.rawValue:
            configureAvoidanceCellForIndexPath(cell, indexPath: indexPath)
        case EffectSections.reduction.rawValue:
            configureReductionCellForIndexPath(cell, indexPath: indexPath)
        case EffectSections.attack.rawValue:
            configureAttackModifierCellForIndexPath(cell, indexPath: indexPath)
        default:
            print("Unconfigured cell")
        }
        
        return cell ?? UITableViewCell()
    }
    
    fileprivate func configureDamageCellForIndexPath(_ cell: EffectCell?, indexPath: IndexPath) {
        let damageType = damageTypeForIndexPath(indexPath)
        let damageValue = damageModifierValue(damageType)
        
        cell?.effectImageView.image = damageType.image
        cell?.effectLabel.attributedText = NSAttributedString(string: damageType.rawValue + ": " + "\(damageValue)", attributes: [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
    }
    
    fileprivate func configureAvoidanceCellForIndexPath(_ cell: EffectCell?, indexPath: IndexPath) {
        let avoidanceType = avoidanceTypeForIndexPath(indexPath)
        let avoidanceValue = avoidanceValueForReductionType(avoidanceType)
        
        cell?.effectImageView.image = avoidanceType.image
        cell?.effectLabel.attributedText = NSAttributedString(string: avoidanceType.rawValue + ": " + "\(avoidanceValue)", attributes: [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
    }
    
    fileprivate func configureReductionCellForIndexPath(_ cell: EffectCell?, indexPath: IndexPath) {
        let reductionType = reductionTypeForIndexPath(indexPath)
        let reductionValue = reductionValueForReductionType(reductionType)
        
        cell?.effectImageView.image = reductionType.image
        cell?.effectLabel.attributedText = NSAttributedString(string: reductionType.rawValue + ": " + "\(reductionValue)", attributes: [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
    }
    
    fileprivate func configureAttackModifierCellForIndexPath(_ cell: EffectCell?, indexPath: IndexPath) {
        let modifierType = attackModifierTypeForIndexPath(indexPath)
        let modifierValue = attackModifierValueForModifierType(modifierType)
        
        cell?.effectImageView.image = modifierType.image
        cell?.effectLabel.attributedText = NSAttributedString(string: modifierType.rawValue + ": " + "\(modifierValue)", attributes: [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
    }
    
    fileprivate func damageTypeForIndexPath(_ indexPath: IndexPath) -> DamageModifier.DamageModifierType {
        return DamageModifier.allDamageModifierTypes[(indexPath as NSIndexPath).row]
    }
    
    fileprivate func damageModifierValue(_ type: DamageModifier.DamageModifierType) -> Int {
        guard let hero = hero else { return 0 }
        
        return hero.damageModifierForModifierType(type)
    }
    
    fileprivate func avoidanceTypeForIndexPath(_ indexPath: IndexPath) -> DamageAvoidance.AvoidanceType {
        return DamageAvoidance.allAvoidanceTypes[(indexPath as NSIndexPath).row]
    }
    
    fileprivate func avoidanceValueForReductionType(_ type: DamageAvoidance.AvoidanceType) -> Int {
        guard let hero = hero else { return 0 }
        
        return hero.damageAvoidanceForAvoidanceType(type)
    }
    
    fileprivate func reductionTypeForIndexPath(_ indexPath: IndexPath) -> DamageReduction.ReductionType {
        return DamageReduction.allReductionTypes[(indexPath as NSIndexPath).row]
    }
    
    fileprivate func reductionValueForReductionType(_ type: DamageReduction.ReductionType) -> Int {
        guard let hero = hero else { return 0 }
        
        return hero.damageReductionForReductionType(type)
    }
    
    fileprivate func attackModifierTypeForIndexPath(_ indexPath: IndexPath) -> AttackModifier.AttackModifierType {
        return AttackModifier.allAttackModifierTypes[(indexPath as NSIndexPath).row]
    }
    
    fileprivate func attackModifierValueForModifierType(_ type: AttackModifier.AttackModifierType) -> Int {
        guard let hero = hero else { return 0 }
        
        return hero.attackModifierForModifierType(type)
    }
}

private class EffectsHeaderView {
    static func headerViewWithText(_ text: String, width: CGFloat) -> UITableViewHeaderFooterView {
        let containingView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        containingView.contentView.backgroundColor = .backgroundColor()
        
        let labelFrame = CGRect(x: 10, y: 0, width: containingView.frame.width, height: containingView.frame.height)
        let label = UILabel(frame: labelFrame)
        
        label.attributedText =  NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.bodyFont(), NSForegroundColorAttributeName: UIColor.headerTextColor()])
        label.textAlignment = .left
        
        containingView.addSubview(label)
        
        return containingView
    }
}
