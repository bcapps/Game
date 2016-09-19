//
//  HeroToolsViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/8/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import MessageUI

final class HeroToolsViewController: UITableViewController, ListViewControllerDelegate {
    
    var hero: Hero?
    var increaseStatList: ListViewController<Stat>?
    var decreaseStatList: ListViewController<Stat>?
    
    enum Tool: Int {
        case itemList
        case spellList
        case skillList
        case increaseStat
        case decreaseStat
        case gold
        case backupCharacter
        
        func toolName() -> String {
            switch self {
            case .itemList:
                return "Item List"
            case .spellList:
                return "Spell List"
            case .skillList:
                return "Skill List"
            case .increaseStat:
                return "Increase Stat"
            case .decreaseStat:
                return "Decrease Stat"
            case .gold:
                return "Gold"
            case .backupCharacter:
                return "Backup Character"
            }
        }
        
        func toolViewController(_ delegate: ListViewControllerDelegate) -> UIViewController? {
            switch self {
            case .itemList:
                let list = ListViewController<Item>(sections: ObjectProvider.sortedObjectsForJSON("Items").sectionedItems, delegate: delegate)
                list.title = "Get Item"
                return list
            case .spellList:
                let list = ListViewController<Spell>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Spells"))], delegate: delegate)
                list.title = "Get Spell"
                return list
            case .skillList:
                let list = ListViewController<Skill>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Skills"))], delegate: delegate)
                list.title = "Get Skill"
                return list
            case .increaseStat:
                let list = ListViewController<Stat>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Stats"))], delegate: delegate)
                list.title = "Increase Stat"
                return list
            case .decreaseStat:
                let list = ListViewController<Stat>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Stats"))], delegate: delegate)
                list.title = "Decrease Stat"
                return list
            case .gold:
                return nil
            case .backupCharacter:
                return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hero Tools"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .dismiss)
        
        tableView.customize()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
            
            goldViewController.sendGoldTapped = { [weak self] gold in
                self?.hero?.inventory.gold += gold
                
                self?.saveHero()
                self?.dismissHeroTools()
            }
            
            navigationController?.pushViewController(goldViewController, animated: true)
        case .backupCharacter:
            guard let hero = hero else { return }
            let URL = HeroPersistence().URLForHero(hero)
            guard let data = try? Data(contentsOf: URL) else { return }
            
            let mailCompose = MFMailComposeViewController(rootViewController: self)
            mailCompose.mailComposeDelegate = self
            mailCompose.addAttachmentData(data, mimeType: "application/octet-stream", fileName: hero.name)
            
            navigationController?.show(mailCompose, sender: self)
            
            break
        case .increaseStat:
            guard let viewController = tool.toolViewController(self) else { return }
            increaseStatList = viewController as? ListViewController<Stat>
            
            navigationController?.pushViewController(viewController, animated: true)
        case .decreaseStat:
            guard let viewController = tool.toolViewController(self) else { return }
            decreaseStatList = viewController as? ListViewController<Stat>
            navigationController?.pushViewController(viewController, animated: true)
        default:
            guard let viewController = tool.toolViewController(self) else { return }
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func dismissHeroTools() {
        navigationController?.dismiss(animated: true) {
            print("Finished")
        }
    }
    
    fileprivate func saveHero() {
        guard let hero = hero else { return }
        
        HeroPersistence().persistHero(hero)
    }
    
    // MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) {
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
        dismissHeroTools()
    }
    
    func canSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) -> Bool {
        return object is Item || object is Skill || object is Spell || object is Stat
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) { }
    
    func removeObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) { }
}

extension HeroToolsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("HI")
    }
}

private extension Selector {
    static let dismiss = #selector(HeroToolsViewController.dismissHeroTools)
}

private extension Hero {
    func export() -> Data {
        let heroCoder = HeroCoder(value: self)
        let data = NSKeyedArchiver.archivedData(withRootObject: heroCoder)
        
        return data
    }
}
