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
        case TownList
        case SpellList
        case SkillList
        case MonsterList
        case Quests
        case Notes
        case Gold
        
        func toolName() -> String {
            switch self {
            case .ItemList:
                return "Item List"
            case .GodList:
                return "God List"
            case .TownList:
                return "Town List"
            case .SpellList:
                return "Spell List"
            case .SkillList:
                return "Skill List"
            case .MonsterList:
                return "Monster List"
            case .Quests:
                return "Quests"
            case .Notes:
                return "Notes"
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
            case .TownList:
                return ListViewController<Town>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Towns"))], delegate: delegate)
            case .SpellList:
                return ListViewController<Spell>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Spells"))], delegate: delegate)
            case .SkillList:
                return ListViewController<Skill>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Skills"))], delegate: delegate)
            case .MonsterList:
                return ListViewController<Monster>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Monsters"))], delegate: delegate)
            case .Quests:
                return ListViewController<Quest>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Quests"))], delegate: delegate)
            case .Notes:
                return ListViewController<Note>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Notes"))], delegate: delegate)
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
        return 9
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
                guard let goldViewController = UIStoryboard.sendGoldViewController() else { return }
                
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
        } else if let town = object as? Town {
            let merchants = town.merchants.flatMap { return ObjectProvider.merchantForName($0) }
            
            let merchantList = ListViewController<Merchant>(sections: [SectionList(sectionTitle: nil, objects: merchants)], delegate: self)
            
            navigationController?.pushViewController(merchantList, animated: true)
        } else if let monster = object as? Monster {
            let random = GKShuffledDistribution(forDieWithSideCount: 100).nextInt()
            let attack = monster.attackForNumber(random)
            
            if let attack = attack {
                let controller = UIAlertController(title: attack.name, message: attackStringForAttack(attack), preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                
                navigationController?.presentViewController(controller, animated: true, completion: nil)
            }
            
            guard let indexPath = listViewController.tableView.indexPathForSelectedRow else { return }
            
            listViewController.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool {
        return object is Item || object is Skill || object is Spell || object is Monster || object is Town
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    func removeObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
}
