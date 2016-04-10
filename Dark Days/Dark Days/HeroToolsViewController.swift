//
//  HeroToolsViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/8/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

final class HeroToolsViewController: UITableViewController, ListViewControllerDelegate {
    
    var hero: Hero?
    
    enum Tool: Int {
        case ItemList
        case SpellList
        case SkillList
        case Gold
        
        func toolName() -> String {
            switch self {
            case .ItemList:
                return "Item List"
            case .SpellList:
                return "Spell List"
            case .SkillList:
                return "Skill List"
            case .Gold:
                return "Gold"
            }
        }
        
        func toolViewController(delegate: ListViewControllerDelegate) -> UIViewController? {
            switch self {
            case .ItemList:
                return ListViewController<Item>(sections: ObjectProvider.sortedObjectsForJSON("Items").sectionedItems, delegate: delegate)
            case .SpellList:
                return ListViewController<Spell>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Spells"))], delegate: delegate)
            case .SkillList:
                return ListViewController<Skill>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Skills"))], delegate: delegate)
            case .Gold:
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
        return 4
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
        default:
            guard let viewController = tool.toolViewController(self) else { return }
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
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
        }
        
        saveHero()
        dismiss()
    }
    
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool {
        return object is Item || object is Skill || object is Spell
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    
    func removeObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
}

private extension Selector {
    static let dismiss = #selector(HeroToolsViewController.dismiss)
}
