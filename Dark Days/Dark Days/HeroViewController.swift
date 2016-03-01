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
    
    let menu = DropdownMenuFactory.heroDropdownMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = hero?.name
        view.backgroundColor = .backgroundColor()
        
        addMenuTapHandlers()
    }
    
    @IBAction func menuButtonTapped(sender: UIBarButtonItem) {
        if menu.isDescendantOfView(view) {
            menu.hideMenu()
        }
        else {
            menu.showMenuFromView(view)
        }
    }
    
    private func addMenuTapHandlers() {
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
        guard let items = hero?.inventory.items else { return }
        
        let itemsList = ListViewController<Item>(objects: items, delegate: nil)
        itemsList.title = "Inventory"
        
        presentListViewController(itemsList)
    }
    
    private func presentsSkillsList() {
        guard let skills = hero?.skills else { return }
        
        let skillsList = ListViewController<Skill>(objects: skills, delegate: nil)
        skillsList.title = "Skills"
        
        presentListViewController(skillsList)
    }
    
    private func presentSpellsList() {
        guard let spells = hero?.spells else { return }
        
        let spellsList = ListViewController<Spell>(objects: spells, delegate: nil)
        spellsList.title = "Spellbook"
        
        presentListViewController(spellsList)
    }
    
    private func presentListViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }    
}
