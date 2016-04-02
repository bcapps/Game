//
//  ToolsListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/10/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import GameplayKit

final class ToolsListViewController: UITableViewController, ListViewControllerDelegate {
    let multipeer = LCKMultipeer(multipeerUserType: .Host, peerName: "DM", serviceName: "DarkDays")
    
    enum Tool: Int {
        case ItemList
        case GodList
        case FloorList
        case SpellList
        case SkillList
        case MonsterList
        case Gold
        
        func toolName() -> String {
            switch self {
                case .ItemList:
                    return "Item List"
                case .GodList:
                    return "God List"
                case .FloorList:
                    return "Floor List"
                case .SpellList:
                    return "Spell List"
                case .SkillList:
                    return "Skill List"
                case .MonsterList:
                    return "Monster List"
                case .Gold:
                    return "Gold"
            }
        }
        
        func toolViewController(delegate: ListViewControllerDelegate) -> UIViewController? {
            switch self {
            case .ItemList:
                return ListViewController<Item>(sections: ObjectProvider.sortedObjectsForJSON("Items").sectionedItems, delegate: delegate)
            case .GodList:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Gods"))], delegate: delegate)
            case .FloorList:
                return ListViewController<Floor>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Floors"))], delegate: delegate)
            case .SpellList:
                return ListViewController<Spell>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Spells"))], delegate: delegate)
            case .SkillList:
                return ListViewController<Skill>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Skills"))], delegate: delegate)
            case .MonsterList:
                return ListViewController<Monster>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Monsters"))], delegate: delegate)
            case .Gold:
                return nil
            }
        }
    }
    
    deinit {
        multipeer.stopMultipeerConnectivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        tableView.customize()
        
        multipeer.startMultipeerConnectivity()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self), forIndexPath: indexPath) ?? UITableViewCell()
        
        if let text = Tool(rawValue: indexPath.row)?.toolName() {
            cell.textLabel?.attributedText = .attributedStringWithHeadingAttributes(text)
        }
        
        cell.selectionStyle = .Gray
        cell.backgroundColor = .backgroundColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let tool = Tool(rawValue: indexPath.row) else { return }
        
        switch tool {
            case .Gold:
                guard let goldViewController = UIStoryboard.sendGoldViewController() as? SendGoldViewController else { return }
                
                goldViewController.sendGoldTapped = { gold in
                    let peersViewController = PeerListViewController(multipeerManager: self.multipeer)
                    peersViewController.goldToSend = gold
                    
                    self.navigationController?.pushViewController(peersViewController, animated: true)
                }
                
                navigationController?.pushViewController(goldViewController, animated: true)
            default:
                guard let viewController = tool.toolViewController(self) else { return }
                navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func attackStringForAttack(attack: MonsterAttack) -> String {
        let damage = attack.damage
        let range = damage.startIndex..<damage.endIndex
        
        let attackRoll = GKShuffledDistribution(forDieWithSideCount: 20).nextInt()
        let digits = NSCharacterSet.decimalDigitCharacterSet()

        var damageWithNumberReplacement = String()
        
        for substring in damage.componentsSeparatedByString(" ") {
            let decimalRange = substring.rangeOfCharacterFromSet(digits, options: NSStringCompareOptions(), range: nil)
            
            damageWithNumberReplacement.appendContentsOf(substring)
            
            if decimalRange != nil {
                let separatedStrings = substring.componentsSeparatedByString("d")
                
                if separatedStrings.count == 2 {
                    let damageDiceString = separatedStrings[0]
                    let damageRollString = separatedStrings[1]
                    
                    if let damageDice = Int(damageDiceString), damageRoll = Int(damageRollString) {
                        var totalDamage = 0
                        
                        let damageRandomizer = GKShuffledDistribution(forDieWithSideCount: damageRoll)
                        
                        for _ in 1...damageDice {
                            totalDamage += damageRandomizer.nextInt()
                        }
                        
                        damageWithNumberReplacement.appendContentsOf("(\(totalDamage))")
                    }
                }
            }
            
            damageWithNumberReplacement.appendContentsOf(" ")
        }
        
        return "Attack Roll: \(attackRoll)" + "\n" + "Damage Roll: " + damageWithNumberReplacement
    }
    
    // MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        if object is Item || object is Skill || object is Spell {
            let peersViewController = PeerListViewController(multipeerManager: multipeer)
            peersViewController.objectToSend = object as Any
            
            navigationController?.pushViewController(peersViewController, animated: true)
        } else if let monster = object as? Monster {
            let random = GKShuffledDistribution(forDieWithSideCount: 100).nextInt()
            let attack = monster.attackForNumber(random)
            
            if let attack = attack {
                let controller = UIAlertController(title: attack.name, message: attackStringForAttack(attack), preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                
                presentViewController(controller, animated: true, completion: nil)
            }
            
            guard let indexPath = listViewController.tableView.indexPathForSelectedRow else { return }
            
            listViewController.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool {
        return object is Item || object is Skill || object is Spell || object is Monster
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
}
