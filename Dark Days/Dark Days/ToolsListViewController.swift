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
        case PeersList
        case ItemList
        case GodList
        case FloorList
        case SpellList
        case SkillList
        case MonsterList
        case Gold
        
        func toolName() -> String {
            switch self {
                case .PeersList:
                    return "Peers List"
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
            case .PeersList:
                return nil
            case .ItemList:
                return ListViewController<Item>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Items"))], delegate: delegate)
            case .GodList:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Gods"))], delegate: delegate)
            case .FloorList:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Floors"))], delegate: delegate)
            case .SpellList:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Spells"))], delegate: delegate)
            case .SkillList:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Skills"))], delegate: delegate)
            case .MonsterList:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Monsters"))], delegate: delegate)
            case .Gold:
                return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        tableView.customize()
        
        multipeer.startMultipeerConnectivity()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
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
        
        let viewController = tool.toolViewController(self)
        
        if let vC = viewController {
            navigationController?.pushViewController(vC, animated: true)
        }
    }
    
    // MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool { return true }
}
