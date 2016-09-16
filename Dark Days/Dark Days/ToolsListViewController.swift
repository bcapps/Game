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
    let multipeer = LCKMultipeer(multipeerUserType: .host, peerName: "DM", serviceName: "DarkDays")
    
    enum Tool: Int {
        case itemList
        case godList
        case townList
        case spellList
        case skillList
        case monsterList
        case quests
        case names
        case notes
        case statModification
        case gold
        
        func toolName() -> String {
            switch self {
            case .itemList:
                return "Item List"
            case .godList:
                return "God List"
            case .townList:
                return "Town List"
            case .spellList:
                return "Spell List"
            case .skillList:
                return "Skill List"
            case .monsterList:
                return "Monster List"
            case .statModification:
                return "Stat Modification"
            case .quests:
                return "Quests"
            case .names:
                return "Names"
            case .notes:
                return "Notes"
            case .gold:
                return "Gold"
            }
        }
        
        func toolViewController(_ delegate: ListViewControllerDelegate) -> UIViewController? {
            switch self {
            case .itemList:
                return ListViewController<Item>(sections: ObjectProvider.sortedObjectsForJSON("Items").sectionedItems, delegate: delegate)
            case .godList:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Gods"))], delegate: delegate)
            case .townList:
                return ListViewController<Town>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Towns"))], delegate: delegate)
            case .spellList:
                return ListViewController<Spell>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Spells"))], delegate: delegate)
            case .skillList:
                return ListViewController<Skill>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Skills"))], delegate: delegate)
            case .monsterList:
                return ListViewController<Monster>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Monsters"))], delegate: delegate)
            case .statModification:
                return ListViewController<Stat>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Stats"))], delegate: delegate)
            case .quests:
                let completedQuests: [Quest] = ObjectProvider.sortedObjectsForJSON("Quests").filter { $0.completed == true }
                let upcomingQuests: [Quest] = ObjectProvider.sortedObjectsForJSON("Quests").filter { $0.completed == false }
                
                return ListViewController<Quest>(sections: [SectionList(sectionTitle: nil, objects:upcomingQuests), SectionList(sectionTitle: "Completed", objects:completedQuests)], delegate: delegate)
            case .notes:
                return ListViewController<Note>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Notes"))], delegate: delegate)
            case .names:
                return nil
            case .gold:
                return nil
            }
        }
    }
    
    deinit {
        //multipeer.stopMultipeerConnectivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        tableView.customize()
        
        //multipeer.startMultipeerConnectivity()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath) 
        
        if let text = Tool(rawValue: (indexPath as NSIndexPath).row)?.toolName() {
            cell.textLabel?.attributedText = .attributedStringWithHeadingAttributes(text)
        }
        
        cell.selectionStyle = .gray
        cell.backgroundColor = .backgroundColor()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tool = Tool(rawValue: (indexPath as NSIndexPath).row) else { return }
        
        switch tool {
            case .gold:
                guard let goldViewController = UIStoryboard.sendGoldViewController() else { return }
                
                goldViewController.sendGoldTapped = { gold in
                    let peersViewController = PeerListViewController(multipeerManager: self.multipeer)
                    peersViewController.goldToSend = gold
                    
                    self.navigationController?.pushViewController(peersViewController, animated: true)
                }
                
                navigationController?.pushViewController(goldViewController, animated: true)
            case .names:
                guard let namesViewController = UIStoryboard.namesViewController() else { return }
            
                navigationController?.pushViewController(namesViewController, animated: true)
            default:
                guard let viewController = tool.toolViewController(self) else { return }
                navigationController?.pushViewController(viewController, animated: true)
        }
    }
        
    // MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) {
        if object is Item || object is Skill || object is Spell || object is Stat {
            let peersViewController = PeerListViewController(multipeerManager: multipeer)
            peersViewController.objectToSend = object as Any
            
            navigationController?.pushViewController(peersViewController, animated: true)
        } else if let town = object as? Town {
            let merchants = town.merchants.flatMap { return ObjectProvider.merchantForName($0) }
            
            let merchantList = ListViewController<Merchant>(sections: [SectionList(sectionTitle: nil, objects: merchants)], delegate: self)
            
            navigationController?.pushViewController(merchantList, animated: true)
        } else if let monster = object as? Monster {
            
            guard let monsterVC = UIStoryboard.monsterViewController() else { return }
            monsterVC.monster = monster
            
            navigationController?.pushViewController(monsterVC, animated: true)            
        }
    }
    
    func canSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) -> Bool {
        return object is Item || object is Skill || object is Spell || object is Monster || object is Town || object is Stat
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) { }
    func removeObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) { }
}
