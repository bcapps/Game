//
//  HeroToolsViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/8/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

final class HeroToolsViewController: UITableViewController, ListViewControllerDelegate {
    
    var hero: Hero?
    var increaseStatList: ListViewController<Stat>?
    var decreaseStatList: ListViewController<Stat>?
    
    enum Tool: Int {
        case ItemList
        case SpellList
        case SkillList
        case IncreaseStat
        case DecreaseStat
        case Gold
        case BackupCharacter
        
        func toolName() -> String {
            switch self {
            case .ItemList:
                return "Item List"
            case .SpellList:
                return "Spell List"
            case .SkillList:
                return "Skill List"
            case .IncreaseStat:
                return "Increase Stat"
            case .DecreaseStat:
                return "Decrease Stat"
            case .Gold:
                return "Gold"
            case .BackupCharacter:
                return "Backup Character"
            }
        }
        
        func toolViewController(delegate: ListViewControllerDelegate) -> UIViewController? {
            switch self {
            case .ItemList:
                let list = ListViewController<Item>(sections: ObjectProvider.sortedObjectsForJSON("Items").sectionedItems, delegate: delegate)
                list.title = "Get Item"
                return list
            case .SpellList:
                let list = ListViewController<Spell>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Spells"))], delegate: delegate)
                list.title = "Get Spell"
                return list
            case .SkillList:
                let list = ListViewController<Skill>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Skills"))], delegate: delegate)
                list.title = "Get Skill"
                return list
            case .IncreaseStat:
                let list = ListViewController<Stat>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Stats"))], delegate: delegate)
                list.title = "Increase Stat"
                return list
            case .DecreaseStat:
                let list = ListViewController<Stat>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Stats"))], delegate: delegate)
                list.title = "Decrease Stat"
                return list
            case .Gold:
                return nil
            case .BackupCharacter:
                return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hero Tools"
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: .dismiss)
        
        tableView.customize()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
            
            goldViewController.sendGoldTapped = { [weak self] gold in
                self?.hero?.inventory.gold += gold
                
                self?.saveHero()
                self?.dismiss()
            }
            
            navigationController?.pushViewController(goldViewController, animated: true)
        case .BackupCharacter:
            break
        case .IncreaseStat:
            guard let viewController = tool.toolViewController(self) else { return }
            increaseStatList = viewController as? ListViewController<Stat>
            
            navigationController?.pushViewController(viewController, animated: true)
        case .DecreaseStat:
            guard let viewController = tool.toolViewController(self) else { return }
            decreaseStatList = viewController as? ListViewController<Stat>
            navigationController?.pushViewController(viewController, animated: true)
        default:
            guard let viewController = tool.toolViewController(self) else { return }
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func dismiss() {
        navigationController?.dismissViewControllerAnimated(true) {
            print("Finished")
        }
    }
    
    private func saveHero() {
        guard let hero = hero else { return }
        
        HeroPersistence().persistHero(hero)
    }
    
    // MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        if let item = object as? Item {
            hero?.inventory.items.append(item)
        } else if let skill = object as? Skill {
            hero?.skills.append(skill)
        } else if let spell = object as? Spell {
            hero?.spells.append(spell)
        } else if let stat = object as? Stat {
            if listViewController == increaseStatList {
                hero?.increaseStatBy(stat.statType, value: 1)
            } else if listViewController == decreaseStatList {
                hero?.increaseStatBy(stat.statType, value: -1)
            }
        }
        
        saveHero()
        dismiss()
    }
    
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool {
        return object is Item || object is Skill || object is Spell || object is Stat
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    
    func removeObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
}

private extension Selector {
    static let dismiss = #selector(HeroToolsViewController.dismiss)
}

private extension Hero {
    func export() -> NSData {
        let heroCoder = HeroCoder(value: self)
        let data = NSKeyedArchiver.archivedDataWithRootObject(heroCoder)
        
        return data
    }
}
