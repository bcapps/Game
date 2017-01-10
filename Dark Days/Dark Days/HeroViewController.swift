//
//  HeroViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import REMenu

final class HeroViewController: UIViewController, ListViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, LCKMultipeerEventListener {
    @IBOutlet weak var helmetButton: EquipmentButton!
    @IBOutlet weak var accessoryButton: EquipmentButton!
    @IBOutlet weak var leftHandButton: EquipmentButton!
    @IBOutlet weak var rightHandButton: EquipmentButton!
    @IBOutlet weak var chestButton: EquipmentButton!
    @IBOutlet weak var bootsButton: EquipmentButton!
    
    @IBOutlet var equipmentButtons: [EquipmentButton]! // swiftlint:disable:this force_unwrapping
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var godLabel: UILabel!
    @IBOutlet weak var itemSetListButton: UIButton!
    
    var multipeer: LCKMultipeer?
    
    var hero: Hero? {
        didSet {
            title = hero?.name
            
//            multipeer?.stopMultipeerConnectivity()
//            multipeer?.removeEventListener(self)
//            
//            multipeer = LCKMultipeer(multipeerUserType: .Client, peerName: hero?.name ?? "No Name", serviceName: "DarkDays")
//            
//            multipeer?.startMultipeerConnectivity()
//            multipeer?.addEventListener(self)
        }
    }
    
    fileprivate var healthViewController: HealthViewController?
    
    fileprivate var menu: REMenu?
    fileprivate let animationDuration = 0.35
    
    fileprivate var presentedOverlayController: UIViewController?
    
    deinit {
        multipeer?.stopConnectivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNibForClass(StatCell.self, reuseIdentifier: "StatCellIdentifier")
        
        title = hero?.name
        view.backgroundColor = .backgroundColor()
        
        addItemSlotToEquipmentButtons()
        updateEquippedItems()
        updateGoldText()
        
        if let god = hero?.god {
            godLabel.attributedText = .attributedStringWithSmallAttributes("Follower of " + god.name)
        }
        
        let itemSpacing = collectionViewFlowLayout.minimumInteritemSpacing
        let numberOfItems = CGFloat(5)
        
        collectionViewFlowLayout.itemSize = CGSize(width: (view.frame.width - (itemSpacing * numberOfItems)) / numberOfItems, height: 45)
        
        updateMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateGoldText()
        healthViewController?.hero = hero
        collectionView.reloadData()
        updateMenu()
        itemSetListButton.isHidden = hero?.inventory.equippedItemSets.isEmpty == true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        menu?.close()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination.view
        
        if let viewController = segue.destination as? HealthViewController {
            healthViewController = viewController
            healthViewController?.hero = hero
        } else if let viewController = segue.destination as? ItemSetListViewController {
            viewController.hero = hero
        }
    }
    
    private func updateMenu() {
        guard let hero = hero else { return }
        menu = DropdownMenuFactory.heroDropdownMenu(hero: hero)
        addMenuTapHandlers()
    }
    
    @IBAction func effectsViewButtonTapped(_ sender: AnyObject) {
        guard let evc = UIStoryboard.effectsViewController() else { return }
        evc.hero = hero
        
        let container = ContainingViewController(containedViewController: evc, footerView: nil)
        container.view.frame = view.bounds
        
        replaceChildViewController(presentedOverlayController, newViewController: container, animationDuration: animationDuration)
        presentedOverlayController = container
    }
    
    @IBAction func itemSetButtonTapped(_ sender: AnyObject) {
        presentEquippedItemSetList()
    }
    
    @IBAction func statusEffectListButtonTapped(_ sender: AnyObject) {
        presentStatusEffectList()
    }
    
    @IBAction func diceRollerButtonTapped(_ sender: AnyObject) {
        presentDiceRoller()
    }
    
    @IBAction func equipmentButtonTapped(_ button: EquipmentButton) {
        if let item = button.item {
            presentItem(item)
        } else {
            presentItemList(button)
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        guard let menu = menu else { return }
        
        if menu.isOpen == true {
            menu.close()
        } else {
            menu.show(from: navigationController)
        }
    }
    
    func saveHero() {
        guard let hero = hero else { return }
        
        HeroPersistence().persistHero(hero)
    }
    
    fileprivate func addItemSlotToEquipmentButtons() {
        helmetButton.slot = .Helmet
        accessoryButton.slot = .Accessory
        leftHandButton.slot = .Hand
        rightHandButton.slot = .Hand
        chestButton.slot = .Chest
        bootsButton.slot = .Boots
        
        helmetButton.equipmentSlot = .helmet
        accessoryButton.equipmentSlot = .accessory
        leftHandButton.equipmentSlot = .leftHand
        rightHandButton.equipmentSlot = .rightHand
        chestButton.equipmentSlot = .chest
        bootsButton.equipmentSlot = .boots
    }
    
    fileprivate func updateEquippedItems() {
        guard let equippedItems = hero?.inventory.equippedItems else { return }
        
        for equipmentButton in equipmentButtons {
            equipmentButton.item = nil
            
            if equipmentButton == leftHandButton {
                equipmentButton.setImage(UIImage(named: "LeftHand"), for: UIControlState())
            } else if equipmentButton == rightHandButton {
                equipmentButton.setImage(UIImage(named: "RightHand"), for: UIControlState())
            }
        }
        
        for item in equippedItems {
            guard let equipmentButton = equipmentButton(item.equippedSlot) else { continue }
            
            equipmentButton.item = item
        }
        
        collectionView.reloadData()
    }
    
    fileprivate func equipmentButton(_ equipmentSlot: EquipmentButton.EquipmentSlot) -> EquipmentButton? {
        return equipmentButtons.filter { $0.equipmentSlot == equipmentSlot }.first
    }
    
    fileprivate func equipmentButtons(_ itemSlot: ItemSlot) -> [EquipmentButton] {
        return equipmentButtons.filter { $0.slot == itemSlot }
    }
    
    fileprivate func addMenuTapHandlers() {
        guard let menu = menu else { return }
        
        for item in menu.items {
            guard let item = item as? REMenuItem else { continue }
            guard let tag = MenuItemTag(rawValue: item.tag) else { continue }
            
            switch tag {
            case .inventory:
                item.action = { [weak self] item in
                    self?.presentItemList()
                }
            case .spellbook:
                item.action = { [weak self] item in
                    self?.presentSpellsList()
                }
            case .skillsItem:
                item.action = { [weak self] item in
                    self?.presentsSkillsList()
                }
            case .heroTools:
                item.action = { [weak self] item in
                    self?.presentHeroTools()
                }
            case .worldMap:
                item.action = { [weak self] item in
                    self?.presentWorldMap()
                }
            case .loreBook:
                item.action = { [weak self] item in
                    self?.presentLoreBook()
                }
            }
        }
    }
    
    fileprivate func presentItem(_ item: Item) {
        let buttonStackView = ButtonStackView()
        buttonStackView.axis = .vertical
        
        if let attack = item.attack {
            let attackTitle = NSAttributedString(string: "Attack", attributes: [NSForegroundColorAttributeName: UIColor.headerTextColor(), NSFontAttributeName: UIFont.headingFont()])

            buttonStackView.addButton(attributedTitle: attackTitle, tapHandler: {
                guard let hero = self.hero else { return }
                
                let result = DiceRoller.rollAttack(forHero: hero, attack: attack)
                
                self.showAlertController(title: "Attack", message: result.attackRollText + "\n" + result.damageRollText)
            })
        }
        
        if item.equippedSlot != .none {
            let button = UnequipButton(item: item)
            button.addTarget(self, action: .unequipItem, for: .touchUpInside)
            
            let unequipTitle = NSAttributedString(string: "Unequip", attributes: [NSForegroundColorAttributeName: UIColor.red])
            buttonStackView.addButton(attributedTitle: unequipTitle, tapHandler: {
                self.unequipItem(button)
            })
        }
        
        presentObjectInOverlay(item, footerView: buttonStackView)
    }
    
    fileprivate func presentItemList() {
        guard let items = hero?.inventory.items.filter({$0.equippedSlot == .none}) else { return }
        
        showListWithSections(items.sectionedItems, title: "Inventory", allowsSelection: true)
    }
    
    fileprivate func presentItemList(_ equipmentButton: EquipmentButton) {
        guard let items = hero?.inventory.items.filter({$0.itemSlot == equipmentButton.slot && $0.equippedSlot == .none}) else { return }
        
        showList(items, title: equipmentButton.slot.rawValue, allowsSelection: true, equipmentButton: equipmentButton)
    }
    
    fileprivate func presentsSkillsList() {
        let itemSkills = hero?.inventory.equippedItems.flatMap { return $0.skills } ?? []
        let inventorySkills = hero?.inventory.items.flatMap { return $0.inventorySkills } ?? []
        let heroSkills = hero?.skills ?? []
        
        showList(itemSkills + heroSkills + inventorySkills, title: "Skills")
    }
    
    fileprivate func presentSpellsList() {
        let spells = hero?.spells ?? []
        let itemSpells = hero?.inventory.items.flatMap { return $0.spells } ?? []
        let itemSetSpells = hero?.inventory.equippedItemSets.flatMap { return $0.spells } ?? []
        
        showList(spells + itemSpells + itemSetSpells, title: "Spellbook", allowsSelection: true)
    }
    
    fileprivate func presentEquippedItemSetList() {
        let itemSets = hero?.inventory.equippedItemSets ?? []
        
        showList(itemSets, title: "Equipped Sets")
    }
    
    private func presentStatusEffectList() {
        guard let statusEffectList = UIStoryboard.statusEffectsViewController() else { return }
        statusEffectList.hero = hero
        
        navigationController?.show(statusEffectList, sender: self)
    }
    
    fileprivate func presentWorldMap() {
        guard let mapViewController = UIStoryboard.mapViewController() else { return }
        
        navigationController?.show(mapViewController, sender: self)
    }
    
    fileprivate func presentLoreBook() {
        let loreBookViewController = LoreBookViewController()
        
        navigationController?.show(loreBookViewController, sender: self)
    }
    
    private func presentDiceRoller() {
        guard let diceRollerViewController = UIStoryboard.diceRollerViewController() else { return }
        
        navigationController?.show(diceRollerViewController, sender: self)
    }
    
    fileprivate func presentObjectInOverlay<T: ListDisplayingGeneratable>(_ object: T, footerView: UIView? = nil) {
        let section = SectionList(sectionTitle: nil, objects: [object])
        let list = ListViewController<T>(sections: [section], delegate: nil)
        
        presentOverlayWithListViewController(list, footerView: footerView)
    }
    
    fileprivate func showList<T: ListDisplayingGeneratable>(_ objects: [T], title: String, allowsSelection: Bool = false, equipmentButton: EquipmentButton? = nil) where T: Nameable {
        let section = SectionList<T>(sectionTitle: nil, objects: objects.sortedElementsByName)
        
        showListWithSections([section], title: title, allowsSelection: allowsSelection, equipmentButton: equipmentButton)
    }
    
    fileprivate func showListWithSections<T: ListDisplayingGeneratable>(_ sections: [SectionList<T>], title: String, allowsSelection: Bool = false, equipmentButton: EquipmentButton? = nil) where T: Nameable {
        let list = ListViewController<T>(sections: sections, delegate: self)
        list.title = title
        list.tableView.allowsSelection = allowsSelection
        
        list.didSelectClosure = { [weak self] object in
            self?.didSelectObject(object, equipmentButton: equipmentButton)
        }
        
        presentListViewController(list)
    }
    
    fileprivate func presentListViewController<T>(_ viewController: ListViewController<T>) {
        viewController.imageContentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    fileprivate func presentOverlayWithListViewController<T>(_ viewController: ListViewController<T>, footerView: UIView? = nil) {
        let containingViewController = ContainingViewController(containedViewController: viewController, footerView: footerView)
        containingViewController.view.frame = view.bounds
        viewController.imageContentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        replaceChildViewController(presentedOverlayController, newViewController: containingViewController, animationDuration: animationDuration)
        presentedOverlayController = containingViewController
    }
    
    fileprivate func presentHeroTools() {
        let tools = HeroToolsViewController()
        tools.hero = hero
        
        let navController = UINavigationController(rootViewController: tools)
        navController.navigationBar.barStyle = .black
        
        present(navController, animated: true, completion: nil)
    }
    
    func dismissOverlay() {
        guard let presentedController = presentedOverlayController else { return }
        
        replaceChildViewController(presentedController, newViewController: nil, animationDuration: animationDuration)
        presentedOverlayController = nil
    }
    
    func unequipItem(_ button: UnequipButton) {
        button.item?.equippedSlot = .none
        updateEquippedItems()
        
        dismissOverlay()
        
        saveHero()
    }
    
    fileprivate func updateGoldText() {
        let goldString = String(hero?.inventory.gold ?? 0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
                
        goldLabel.attributedText = NSAttributedString(string: goldString, attributes: [NSFontAttributeName: UIFont.bodyFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor(), NSParagraphStyleAttributeName: paragraphStyle])
    }
    
    private func showAlertController(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Done", style: .cancel) { _ in })
        
        dismissOverlay()
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCellIdentifier", for: indexPath) as? StatCell
        let stat = hero?.stats[(indexPath as NSIndexPath).row]
        
        if let stat = stat, let value = hero?.statValueForType(stat.statType) {
            cell?.statTitle.text = stat.shortName
            cell?.statValue.text = String(value)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = hero else { return }
        let stat = hero.stats[(indexPath as NSIndexPath).row]
        
        let buttonStackView = ButtonStackView()
        buttonStackView.axis = .vertical
        
        let rollCheckTitle = String(format:"Roll %@ Check", stat.name)
        buttonStackView.addButton(title: rollCheckTitle, tapHandler: {
            let result = DiceRoller.roll(dice: .d20) + hero.statValueForType(stat.statType)
            
            self.showAlertController(title: rollCheckTitle, message: String(result))
        })
        
        switch stat.statType {
        case .Strength:
            let attackRollTitle = "Melee Attack Roll"
            buttonStackView.addButton(title: attackRollTitle, tapHandler: {
                let result = DiceRoller.roll(dice: .d20) + hero.attackModifier(forAttackType: .Melee)
                
                self.showAlertController(title: attackRollTitle, message: String(result))
            })

        case .Dexterity:
            
            let attackRollTitle = "Ranged Attack Roll"
            buttonStackView.addButton(title: attackRollTitle, tapHandler: {
                let result = DiceRoller.roll(dice: .d20) + hero.attackModifier(forAttackType: .Ranged)
                
                self.showAlertController(title: attackRollTitle, message: String(result))
            })
            
            let avoidRollTitle = "Avoid Physical Attack Roll"
            buttonStackView.addButton(title: avoidRollTitle, tapHandler: {
                let result = DiceRoller.roll(dice: .d20) + hero.damageAvoidanceForAvoidanceType(.Physical)
                
                self.showAlertController(title: avoidRollTitle, message: String(result))
            })
        case .Constitution: break
        case .Intelligence:
            
            let attackRollTitle = "Magical Attack Roll"
            buttonStackView.addButton(title: attackRollTitle, tapHandler: {
                let result = DiceRoller.roll(dice: .d20) + hero.attackModifier(forAttackType: .Magical)
                
                self.showAlertController(title: attackRollTitle, message: String(result))
            })
            
            let avoidRollTitle = "Avoid Magical Attack Roll"
            buttonStackView.addButton(title: avoidRollTitle, tapHandler: {
                let result = DiceRoller.roll(dice: .d20) + hero.damageAvoidanceForAvoidanceType(.Magical)
                
                self.showAlertController(title: avoidRollTitle, message: String(result))
            })
        case .Faith:
            
            let avoidRollTitle = "Avoid Mental Attack Roll"
            buttonStackView.addButton(title: avoidRollTitle, tapHandler: {
                let result = DiceRoller.roll(dice: .d20) + hero.damageAvoidanceForAvoidanceType(.Mental)
                
                self.showAlertController(title: avoidRollTitle, message: String(result))
            })
        }
        
        presentObjectInOverlay(stat, footerView: buttonStackView)
    }
    
    //MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(_ object: T, equipmentButton: EquipmentButton?) {
        if let item = object as? Item {
            guard let equipmentButton = equipmentButton else { return }
            
            switch item.itemSlot {
                case .Hand:
                    if item.twoHanded {
                        leftHandButton.item?.equippedSlot = .none
                        rightHandButton.item?.equippedSlot = .none
                    } else if let leftHandItem = leftHandButton.item, leftHandItem.twoHanded {
                        leftHandButton.item?.equippedSlot = .none
                    } else if let rightHandItem = rightHandButton.item, rightHandItem.twoHanded {
                        rightHandButton.item?.equippedSlot = .none
                    }
                default:
                    let equipmentButton = equipmentButtons(item.itemSlot).first
                    equipmentButton?.item?.equippedSlot = .none
            }
            
            item.equippedSlot = equipmentButton.equipmentSlot
            
            updateEquippedItems()
            saveHero()
            
            _ = navigationController?.popViewController(animated: true)
        } else if let spell = object as? Spell {
            guard let hero = hero else { return }
            
            let message: String
            
            if let attack = spell.attack {
                let result = DiceRoller.rollAttack(forHero: hero, attack: attack)
                
                message = result.attackRollText + "\n" + result.damageRollText
            } else {
                let result = DiceRoller.rollNonDamageAttack(forHero: hero, attackType: .Magical)
                
                message = result.attackRollText
            }
            
            showAlertController(title: "Cast", message: message)
        }
    }
    
    func didSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) {
        guard let selectedIndexPath = listViewController.tableView.indexPathForSelectedRow else { return }
        listViewController.tableView.deselectRow(at: selectedIndexPath, animated: true)
        
//        if let item = object as? Item {
//            let alertController = UIAlertController(title: "Use Item?", message: String(format: "Are you sure you want to use a %@?", item.name), preferredStyle: .alert)
//            
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            let accept = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
//                guard let itemUse = item.itemUse else { return }
//                
//                let dice = Dice.diceForUpperValue(value: itemUse.damageDiceValue)
//                let useRoll = DiceRoller.roll(dice: dice, count: itemUse.damageDiceNumber)
//                let modifier = itemUse.additionalDamage ?? 0
//                
//                let result = useRoll + modifier
//                
//                if item.consumable {
//                    self?.hero?.inventory.items.removeObject(item)
//                }
//            })
//            
//            alertController.addAction(cancel)
//            alertController.addAction(accept)
//            
//            navigationController?.present(alertController, animated: true, completion: nil)
//        }
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) { }
    
    func canSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) -> Bool {
        if let item = object as? Item {
            return item.usable
        }
        
        return true
    }
    
    func removeObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) {
        if let item = object as? Item {
            hero?.inventory.items.removeObject(item)
            
            guard let items = hero?.inventory.items.filter({$0.equippedSlot == .none}) else { return }
            
            var sections = [SectionList<T>]()
            
            for slot in ItemSlot.allValues {
                let slottedItems = items.filter { $0.itemSlot == slot }.filter { $0 is T}.map { $0 as! T } // swiftlint:disable:this force_cast
                let sectionList = SectionList(sectionTitle: nil, objects: slottedItems)
                
                sections.append(sectionList)
            }
            
            listViewController.sections = sections
            
        } else if let skill = object as? Skill {
            hero?.skills.removeObject(skill)

            guard let skills = hero?.skills.sortedElementsByName else { return }
            let castedSkills = skills.filter { $0 is T }.map { $0 as! T } // swiftlint:disable:this force_cast
            
            listViewController.sections = [SectionList<T>(sectionTitle: nil, objects: castedSkills)]
        } else if let spell = object as? Spell {
            hero?.spells.removeObject(spell)
            
            guard let spells = hero?.spells.sortedElementsByName else { return }
            let castedSpells = spells.filter { $0 is T }.map { $0 as! T } // swiftlint:disable:this force_cast
            
            listViewController.sections = [SectionList<T>(sectionTitle: nil, objects: castedSpells)]
        }
        
        saveHero()
    }
    
    // MARK: LCKMultipeerEventListener
    
    func multipeer(_ multipeer: LCKMultipeer, receivedMessage message: LCKMultipeerMessage, fromPeer peer: MCPeerID) {
        guard let object = try? JSONSerialization.jsonObject(with: message.data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] else { return }
        
        let objectName = object?[MessageValueKey] as? String ?? ""
        
        switch message.type {
            case LCKMultipeer.MessageType.item.rawValue:
                guard let item = ObjectProvider.itemForName(objectName) else { return }
                
                hero?.inventory.items.append(item)
                presentObjectInOverlay(item)
            case LCKMultipeer.MessageType.skill.rawValue:
                guard let skill = ObjectProvider.skillForName(objectName) else { return }
                
                hero?.skills.append(skill)
                presentObjectInOverlay(skill)
                break
            case LCKMultipeer.MessageType.spell.rawValue:
                guard let spell = ObjectProvider.spellForName(objectName) else { return }
                
                hero?.spells.append(spell)
                presentObjectInOverlay(spell)
                break
            case LCKMultipeer.MessageType.gold.rawValue:
                let goldValue = object?[MessageValueKey] as? NSNumber
                let heroGold = hero?.inventory.gold ?? 0
                
                hero?.inventory.gold = heroGold + (goldValue?.intValue ?? 0)
                updateGoldText()
                break
            case LCKMultipeer.MessageType.stat.rawValue:
                guard let stat = ObjectProvider.statForName(objectName) else { return }
                hero?.increaseStatBy(stat.statType, value: 1)
                
                collectionView.reloadData()
                break
            default:
                break
        }
        
        saveHero()
    }
}

private extension Selector {
    static let unequipItem = #selector(HeroViewController.unequipItem(_:))
}
