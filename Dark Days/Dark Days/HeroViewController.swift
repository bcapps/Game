//
//  HeroViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import AZDropdownMenu

final class HeroViewController: UIViewController, ListViewControllerDelegate {
    @IBOutlet weak var helmetButton: EquipmentButton!
    @IBOutlet weak var accessoryButton: EquipmentButton!
    @IBOutlet weak var leftHandButton: EquipmentButton!
    @IBOutlet weak var rightHandButton: EquipmentButton!
    @IBOutlet weak var chestButton: EquipmentButton!
    @IBOutlet weak var bootsButton: EquipmentButton!
    
    @IBOutlet var equipmentButtons: [EquipmentButton]! // swiftlint:disable:this force_unwrapping
    
    var hero: Hero?
    
    private let menu = DropdownMenuFactory.heroDropdownMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = hero?.name
        view.backgroundColor = .backgroundColor()
        
        addItemSlotToEquipmentButtons()
        updateEquippedItems()
        addMenuTapHandlers()
    }
    
    @IBAction func equipmentButtonTapped(button: EquipmentButton) {
        if let item = button.item {
            presentItem(item)
        } else {
            presentItemList(button.slot)
        }
    }
    
    @IBAction func menuButtonTapped(sender: UIBarButtonItem) {
        if menu.isDescendantOfView(view) {
            menu.hideMenu()
        } else {
            menu.showMenuFromView(view)
        }
    }
    
    func saveHero() {
        guard let hero = hero else { return }
        
        HeroPersistence().persistHero(hero)
    }
    
    private func addItemSlotToEquipmentButtons() {
        helmetButton.slot = .Helmet
        accessoryButton.slot = .Accessory
        leftHandButton.slot = .Hand
        rightHandButton.slot = .Hand
        chestButton.slot = .Chest
        bootsButton.slot = .Boots
    }
    
    private func updateEquippedItems() {
        guard let equippedItems = hero?.inventory.equippedItems else { return }
        
        for item in equippedItems {
            if let equipmentButton = freeEquipmentButtonForItemSlot(item.itemSlot) {
                equipmentButton.item = item
            }
        }
    }
    
    private func freeEquipmentButtonForItemSlot(slot: ItemSlot) -> EquipmentButton? {
        for equipmentButton in equipmentButtons {
            if equipmentButton.slot == slot && equipmentButton.item == nil {
                return equipmentButton
            }
        }
        
        return nil
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
    
    private func presentItem(item: Item) {
        let itemsList = ListViewController<Item>(objects: [item], delegate: nil)
        itemsList.view.frame = CGRect(x: 50, y: 100, width: 200, height: 200)
        
        addViewController(itemsList)
    }
    
    private func presentItemList() {
        guard let items = hero?.inventory.items else { return }

        let itemsList = ListViewController<Item>(objects: items, delegate: nil)
        itemsList.title = "Inventory"
        
        presentListViewController(itemsList)
    }
    
    private func presentItemList(itemSlot: ItemSlot) {
        guard let items = hero?.inventory.items.filter({$0.itemSlot == itemSlot}) else { return }

        let itemsList = ListViewController<Item>(objects: items, delegate: self)
        itemsList.title = itemSlot.rawValue
        
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
    
    //MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        if let item = object as? Item {
            switch item.itemSlot {
                case .Hand: fallthrough
                default:
                    let equipmentButton = freeEquipmentButtonForItemSlot(item.itemSlot)
                    equipmentButton?.item?.equipped = false
                    equipmentButton?.item = item
            }
            
            item.equipped = true
            
            saveHero()
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool {
        return true
    }
}
