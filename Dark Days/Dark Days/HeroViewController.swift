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
            
            multipeer?.stopMultipeerConnectivity()
            multipeer?.removeEventListener(self)
            
            multipeer = LCKMultipeer(multipeerUserType: .Client, peerName: hero?.name ?? "No Name", serviceName: "DarkDays")
            
            multipeer?.startMultipeerConnectivity()
            multipeer?.addEventListener(self)
            
            effectsViewController?.hero = hero
        }
    }
    
    private let effectsViewController = UIStoryboard.effectsViewController()
    private let menu = DropdownMenuFactory.heroDropdownMenu()
    private let animationDuration = 0.35
    
    private var presentedOverlayController: UIViewController?
    
    deinit {
        multipeer?.stopMultipeerConnectivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = hero?.name
        view.backgroundColor = .backgroundColor()
        
        addItemSlotToEquipmentButtons()
        updateEquippedItems()
        updateGoldText()
        addMenuTapHandlers()
        
        if let god = hero?.god {
            godLabel.attributedText = .attributedStringWithSmallAttributes("Follower of " + god.name)
        }
        
        let itemSpacing = collectionViewFlowLayout.minimumInteritemSpacing
        let numberOfItems = CGFloat(5)
        
        collectionViewFlowLayout.itemSize = CGSize(width: (CGRectGetWidth(view.frame) - (itemSpacing * numberOfItems)) / numberOfItems, height: 45)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        updateGoldText()
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        menu.close()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let _ = segue.destinationViewController.view
        
        if let viewController = segue.destinationViewController as? HealthViewController {
            viewController.hero = hero
        }
    }
    
    @IBAction func effectsViewButtonTapped(sender: AnyObject) {
        guard let evc = effectsViewController else { return }
        let container = ContainingViewController(containedViewController: evc, footerView: nil)
        container.view.frame = view.bounds
        
        replaceChildViewController(presentedOverlayController, newViewController: container, animationDuration: animationDuration)
        presentedOverlayController = container
    }
    
    @IBAction func equipmentButtonTapped(button: EquipmentButton) {
        if let item = button.item {
            presentItem(item)
        } else {
            presentItemList(button)
        }
    }
    
    @IBAction func menuButtonTapped(sender: UIBarButtonItem) {
        if menu.isOpen {
            menu.close()
        } else {
            menu.showFromNavigationController(navigationController)
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
        
        helmetButton.equipmentSlot = .Helmet
        accessoryButton.equipmentSlot = .Accessory
        leftHandButton.equipmentSlot = .LeftHand
        rightHandButton.equipmentSlot = .RightHand
        chestButton.equipmentSlot = .Chest
        bootsButton.equipmentSlot = .Boots
    }
    
    private func updateEquippedItems() {
        guard let equippedItems = hero?.inventory.equippedItems else { return }
        
        for equipmentButton in equipmentButtons {
            equipmentButton.item = nil
            
            if equipmentButton == leftHandButton {
                equipmentButton.setImage(UIImage(named: "LeftHand"), forState: .Normal)
            } else if equipmentButton == rightHandButton {
                equipmentButton.setImage(UIImage(named: "RightHand"), forState: .Normal)
            }
        }
        
        for item in equippedItems {
            guard let equipmentButton = equipmentButton(item.equippedSlot) else { continue }
            
            equipmentButton.item = item
        }
        
        collectionView.reloadData()
        effectsViewController?.tableView?.reloadData()
    }
    
    private func equipmentButton(equipmentSlot: EquipmentButton.EquipmentSlot) -> EquipmentButton? {
        return equipmentButtons.filter { $0.equipmentSlot == equipmentSlot }.first
    }
    
    private func equipmentButtons(itemSlot: ItemSlot) -> [EquipmentButton] {
        return equipmentButtons.filter { $0.slot == itemSlot }
    }
    
    private func addMenuTapHandlers() {
        for (index, item) in menu.items.enumerate() {
            guard let item = item as? REMenuItem else { continue }
            
            switch index {
            case 0:
                item.action = { [weak self] item in
                    self?.presentItemList()
                }
            case 1:
                item.action = { [weak self] item in
                    self?.presentSpellsList()
                }
            case 2:
                item.action = { [weak self] item in
                    self?.presentsSkillsList()
                }
            case 3:
                item.action = { [weak self] item in
                    self?.presentHeroTools()
                }
            default:
                print("No Action")
            }
        }
    }
    
    private func presentItem(item: Item) {
        var button: UnequipButton?
        
        if item.equippedSlot != .None {
            button = UnequipButton(item: item)
            button?.addTarget(self, action: .unequipItem, forControlEvents: .TouchUpInside)
        }
        
        presentObjectInOverlay(item, footerView: button)
    }
    
    private func presentItemList() {
        guard let items = hero?.inventory.items.filter({$0.equippedSlot == .None}) else { return }
        
        showListWithSections(items.sectionedItems, title: "Inventory", allowsSelection: false)
    }
    
    private func presentItemList(equipmentButton: EquipmentButton) {
        guard let items = hero?.inventory.items.filter({$0.itemSlot == equipmentButton.slot && $0.equippedSlot == .None}) else { return }
        
        showList(items, title: equipmentButton.slot.rawValue, allowsSelection: true, equipmentButton: equipmentButton)
    }
    
    private func presentsSkillsList() {
        let itemSkills = hero?.inventory.equippedItems.flatMap { return $0.skills } ?? []
        let heroSkills = hero?.skills ?? []
        
        showList(itemSkills + heroSkills, title: "Skills")
    }
    
    private func presentSpellsList() {
        guard let spells = hero?.spells else { return }
        
        showList(spells, title: "Spellbook")
    }
    
    private func presentObjectInOverlay<T: ListDisplayingGeneratable>(object: T, footerView: UIView? = nil) {
        let section = SectionList(sectionTitle: nil, objects: [object])
        let list = ListViewController<T>(sections: [section], delegate: nil)
        
        presentOverlayWithListViewController(list, footerView: footerView)
    }
    
    private func showList<T: ListDisplayingGeneratable where T: Nameable>(objects: [T], title: String, allowsSelection: Bool = false, equipmentButton: EquipmentButton? = nil) {
        let section = SectionList<T>(sectionTitle: nil, objects: objects.sortedElementsByName)
        
        showListWithSections([section], title: title, allowsSelection: allowsSelection, equipmentButton: equipmentButton)
    }
    
    private func showListWithSections<T: ListDisplayingGeneratable where T: Nameable>(sections: [SectionList<T>], title: String, allowsSelection: Bool = false, equipmentButton: EquipmentButton? = nil) {
        let list = ListViewController<T>(sections: sections, delegate: self)
        list.title = title
        list.tableView.allowsSelection = allowsSelection
        
        list.didSelectClosure = { [weak self] object in
            guard let equipmentButton = equipmentButton else { return }
            self?.didSelectObject(object, equipmentButton: equipmentButton)
        }
        
        presentListViewController(list)
    }
    
    private func presentListViewController<T>(viewController: ListViewController<T>) {
        viewController.imageContentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentOverlayWithListViewController<T>(viewController: ListViewController<T>, footerView: UIView? = nil) {
        let containingViewController = ContainingViewController(containedViewController: viewController, footerView: footerView)
        containingViewController.view.frame = view.bounds
        viewController.imageContentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        replaceChildViewController(presentedOverlayController, newViewController: containingViewController, animationDuration: animationDuration)
        presentedOverlayController = containingViewController
    }
    
    private func presentHeroTools() {
        let tools = HeroToolsViewController()
        tools.hero = hero
        
        let navController = UINavigationController(rootViewController: tools)
        navController.navigationBar.barStyle = .Black
        
        presentViewController(navController, animated: true, completion: nil)
    }
    
    func dismissOverlay() {
        guard let presentedController = presentedOverlayController else { return }
        
        replaceChildViewController(presentedController, newViewController: nil, animationDuration: animationDuration)
        presentedOverlayController = nil
    }
    
    func unequipItem(button: UnequipButton) {
        button.item.equippedSlot = .None
        updateEquippedItems()
        
        dismissOverlay()
        
        saveHero()
    }
    
    private func updateGoldText() {
        let goldString = String(hero?.inventory.gold ?? 0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByTruncatingTail
                
        goldLabel.attributedText = NSAttributedString(string: goldString, attributes: [NSFontAttributeName: UIFont.bodyFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor(), NSParagraphStyleAttributeName: paragraphStyle])
    }
    
    private func setEffectsViewHidden(hidden: Bool) {
        effectsViewController?.view.hidden = hidden
    }
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StatCellIdentifier", forIndexPath: indexPath) as? StatCell
        let stat = hero?.stats[indexPath.row]
        
        if let stat = stat, value = hero?.statValueForType(stat.statType) {
            cell?.statTitle.text = stat.shortName
            cell?.statValue.text = String(value)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let stat = hero?.stats[indexPath.row] else { return }
        
        presentObjectInOverlay(stat)
    }
    
    //MARK: ListViewControllerDelegate
    
    func didSelectObject<T: ListDisplayingGeneratable>(object: T, equipmentButton: EquipmentButton) {
        if let item = object as? Item {
            switch item.itemSlot {
                case .Hand:
                    if item.twoHanded {
                        leftHandButton.item?.equippedSlot = .None
                        rightHandButton.item?.equippedSlot = .None
                    } else if let leftHandItem = leftHandButton.item where leftHandItem.twoHanded {
                        leftHandButton.item?.equippedSlot = .None
                    } else if let rightHandItem = rightHandButton.item where rightHandItem.twoHanded {
                        rightHandButton.item?.equippedSlot = .None
                    }
                default:
                    let equipmentButton = equipmentButtons(item.itemSlot).first
                    equipmentButton?.item?.equippedSlot = .None
            }
            
            item.equippedSlot = equipmentButton.equipmentSlot
            
            updateEquippedItems()
            saveHero()
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool { return true }
    
    func removeObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        if let item = object as? Item {
            hero?.inventory.items.removeObject(item)
            
            guard let items = hero?.inventory.items.filter({$0.equippedSlot == .None}) else { return }
            
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
    
    func multipeer(multipeer: LCKMultipeer, receivedMessage message: LCKMultipeerMessage, fromPeer peer: MCPeerID) {
        guard let object = try? NSJSONSerialization.JSONObjectWithData(message.data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject] else { return }
        
        let objectName = object?[MessageValueKey] as? String ?? ""
        
        switch message.type {
            case LCKMultipeer.MessageType.Item.rawValue:
                guard let item = ObjectProvider.itemForName(objectName) else { return }
                
                hero?.inventory.items.append(item)
                presentObjectInOverlay(item)
            case LCKMultipeer.MessageType.Skill.rawValue:
                guard let skill = ObjectProvider.skillForName(objectName) else { return }
                
                hero?.skills.append(skill)
                presentObjectInOverlay(skill)
                break
            case LCKMultipeer.MessageType.Spell.rawValue:
                guard let spell = ObjectProvider.spellForName(objectName) else { return }
                
                hero?.spells.append(spell)
                presentObjectInOverlay(spell)
                break
            case LCKMultipeer.MessageType.Gold.rawValue:
                let goldValue = object?[MessageValueKey] as? NSNumber
                let heroGold = hero?.inventory.gold ?? 0
                
                hero?.inventory.gold = heroGold + (goldValue?.longValue ?? 0)
                updateGoldText()
                break
            case LCKMultipeer.MessageType.Stat.rawValue:
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
