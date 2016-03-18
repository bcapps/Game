//
//  ToolsListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/10/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

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
                return ListViewController<Item>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Items"))], delegate: delegate)
            case .GodList:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Gods"))], delegate: delegate)
            case .FloorList:
                return ListViewController<Floor>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Floors"))], delegate: delegate)
            case .SpellList:
                return ListViewController<Spell>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Spells"))], delegate: delegate)
            case .SkillList:
                return ListViewController<Skill>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Skills"))], delegate: delegate)
            case .MonsterList:
                return ListViewController<Monster>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Monsters"))], delegate: delegate)
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
                print("HI")
            default:
                guard let viewController = tool.toolViewController(self) else { return }
                navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        guard let object = object as? AnyObject else { return }
        let peersViewController = PeerListViewController(multipeerManager: multipeer)
        peersViewController.objectToSend = object

        navigationController?.pushViewController(peersViewController, animated: true)
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool {
        
        if object is Item || object is Skill || object is Spell {
            return true
        }
        
        return false
    }
}
