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
            
            effectsViewController?.hero = hero
        }
    }
    
    fileprivate let effectsViewController = UIStoryboard.effectsViewController()
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
        guard let evc = effectsViewController else { return }
        let container = ContainingViewController(containedViewController: evc, footerView: nil)
        container.view.frame = view.bounds
        
        replaceChildViewController(presentedOverlayController, newViewController: container, animationDuration: animationDuration)
        presentedOverlayController = container
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
        effectsViewController?.tableView?.reloadData()
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
            }
        }
    }
    
    fileprivate func presentItem(_ item: Item) {
        var button: UnequipButton?
        
        if item.equippedSlot != .none {
            button = UnequipButton(item: item)
            button?.addTarget(self, action: .unequipItem, for: .touchUpInside)
        }
        
        presentObjectInOverlay(item, footerView: button)
    }
    
    fileprivate func presentItemList() {
        guard let items = hero?.inventory.items.filter({$0.equippedSlot == .none}) else { return }
        
        showListWithSections(items.sectionedItems, title: "Inventory", allowsSelection: false)
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
        guard let spells = hero?.spells else { return }
        
        showList(spells, title: "Spellbook")
    }
    
    fileprivate func presentWorldMap() {
        guard let mapViewController = UIStoryboard.mapViewController() else { return }
        
        navigationController?.show(mapViewController, sender: self)
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
            guard let equipmentButton = equipmentButton else { return }
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
        button.item.equippedSlot = .none
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
    
    fileprivate func setEffectsViewHidden(_ hidden: Bool) {
        effectsViewController?.view.isHidden = hidden
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
        guard let stat = hero?.stats[(indexPath as NSIndexPath).row] else { return }
        
        presentObjectInOverlay(stat)
    }
    
    //MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(_ object: T, equipmentButton: EquipmentButton) {
        if let item = object as? Item {
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
        }
    }
    
    func didSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) { }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) { }
    
    func canSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) -> Bool { return true }
    
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
