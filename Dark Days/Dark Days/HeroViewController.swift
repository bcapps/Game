//
//  HeroViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import AZDropdownMenu

final class HeroViewController: UIViewController {
    var hero: Hero?
    
    private static var inventoryItem: AZDropdownMenuItemData {
        get {
            return AZDropdownMenuItemData(title: "Inventory", icon: UIImage(named: "Inventory")!)
        }
    }
    
    private static var spellItem: AZDropdownMenuItemData {
        get {
            return AZDropdownMenuItemData(title: "Spellbook", icon: UIImage(named: "Spellbook")!)
        }
    }
    
    private static var skillItem: AZDropdownMenuItemData {
        get {
            return AZDropdownMenuItemData(title: "Skills", icon: UIImage(named: "Skills")!)
        }
    }
    
    let menu = AZDropdownMenu(dataSource: [inventoryItem, spellItem, skillItem])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = hero?.name
        view.backgroundColor = .backgroundColor()
        
        customizeMenu()
    }
    
    @IBAction func menuButtonTapped(sender: UIBarButtonItem) {
        if menu.isDescendantOfView(view) {
            menu.hideMenu()
        }
        else {
            menu.showMenuFromView(view)
        }
    }
    
    private func customizeMenu() {
        menu.itemColor = .backgroundColor()
        menu.itemFontColor = .headerTextColor()
        menu.itemFontName = UIFont.headingFont().fontName
        menu.itemFontSize = UIFont.headingFont().pointSize
        menu.itemHeight = 54
        
        menu.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
            switch indexPath.row {
                case 0:
                    self?.presentItemList()
                case 1:
                    self?.presentSpellsList()
                case 2:
                    self?.presentsSkillsList()
                default:
                    print("No Action")
            }
        }
    }
    
    private func presentItemList() {
        if let items = hero?.inventory.items {
            let itemsList = ListViewController<Item>(objects: items, delegate: nil)
            itemsList.title = "Inventory"
            
            presentListViewController(itemsList)
        }
    }
    
    private func presentsSkillsList() {
        if let skills = hero?.skills {
            let skillsList = ListViewController<Skill>(objects: skills, delegate: nil)
            skillsList.title = "Skills"
            
            presentListViewController(skillsList)
        }
    }
    
    private func presentSpellsList() {
        if let spells = hero?.spells {
            let spellsList = ListViewController<Spell>(objects: spells, delegate: nil)
            spellsList.title = "Spellbook"
            
            presentListViewController(spellsList)
        }
    }
    
    private func presentListViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }    
}
