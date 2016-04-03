//
//  HeroViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import AZDropdownMenu

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
    
    var multipeer: LCKMultipeer?
    
    var hero: Hero? {
        didSet {
            multipeer?.stopMultipeerConnectivity()
            multipeer?.removeEventListener(self)
            
            multipeer = LCKMultipeer(multipeerUserType: .Client, peerName: hero?.name ?? "No Name", serviceName: "DarkDays")
            
            multipeer?.startMultipeerConnectivity()
            multipeer?.addEventListener(self)
        }
    }
    
    var effectsViewController: EffectsTableViewController?
    
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
        
        let itemSpacing = collectionViewFlowLayout.minimumInteritemSpacing
        let numberOfItems = CGFloat(5)
        
        collectionViewFlowLayout.itemSize = CGSize(width: (CGRectGetWidth(view.frame) - (itemSpacing * numberOfItems)) / numberOfItems, height: 45)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let _ = segue.destinationViewController.view
        
        if let viewController = segue.destinationViewController as? HealthViewController {
            viewController.hero = hero
        } else if let viewController = segue.destinationViewController as? EffectsTableViewController {
            effectsViewController = viewController
            viewController.hero = hero
        }
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
        
        for equipmentButton in equipmentButtons {
            equipmentButton.item = nil
            
            if equipmentButton == leftHandButton {
                equipmentButton.setImage(UIImage(named: "LeftHand"), forState: .Normal)
            } else if equipmentButton == rightHandButton {
                equipmentButton.setImage(UIImage(named: "RightHand"), forState: .Normal)
            }
        }
        
        for item in equippedItems {
            guard let equipmentButton = freeEquipmentButtonForItemSlot(item.itemSlot) else { continue }
            
            equipmentButton.item = item
        }
        
        collectionView.reloadData()
        effectsViewController?.tableView?.reloadData()
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
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
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
            })
        }
    }
    
    private func presentItem(item: Item) {
        var button: UnequipButton?
        
        if item.equipped {
            button = UnequipButton(item: item)
            button?.addTarget(self, action: .unequipItem, forControlEvents: .TouchUpInside)
        }
        
        presentObjectInOverlay(item, footerView: button)
    }
    
    private func presentItemList() {
        guard let items = hero?.inventory.items.filter({$0.equipped == false}) else { return }
        
        var sections = [SectionList<Item>]()
        
        for slot in ItemSlot.allValues {
            sections.append(SectionList(sectionTitle: nil, objects: items.filter { $0.itemSlot == slot }))
        }
        
        showListWithSections(items.sectionedItems, title: "Inventory", allowsSelection: true)        
    }
    
    private func presentItemList(itemSlot: ItemSlot) {
        guard let items = hero?.inventory.items.filter({$0.itemSlot == itemSlot && $0.equipped == false}) else { return }
        
        showList(items, title: itemSlot.rawValue, allowsSelection: true)
    }
    
    private func presentsSkillsList() {
        guard let skills = hero?.skills else { return }
        
        showList(skills, title: "Skills")
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
    
    private func showList<T: ListDisplayingGeneratable where T: Nameable>(objects: [T], title: String, allowsSelection: Bool = false) {        
        let section = SectionList<T>(sectionTitle: nil, objects: objects.sortedElementsByName)
        
        showListWithSections([section], title: title, allowsSelection: allowsSelection)
    }
    
    private func showListWithSections<T: ListDisplayingGeneratable where T: Nameable>(sections: [SectionList<T>], title: String, allowsSelection: Bool = false) {
        let list = ListViewController<T>(sections: sections, delegate: self)
        list.title = title
        list.tableView.allowsSelection = allowsSelection
        
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
    
    func dismissOverlay() {
        guard let presentedController = presentedOverlayController else { return }
        
        replaceChildViewController(presentedController, newViewController: nil, animationDuration: animationDuration)
        presentedOverlayController = nil
    }
    
    func unequipItem(button: UnequipButton) {
        button.item.equipped = false
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
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        if let item = object as? Item {
            switch item.itemSlot {
                case .Hand:
                    if item.twoHanded {
                        leftHandButton.item?.equipped = false
                        rightHandButton.item?.equipped = false
                    } else if let leftHandItem = leftHandButton.item where leftHandItem.twoHanded {
                        leftHandButton.item?.equipped = false
                    } else if let rightHandItem = rightHandButton.item where rightHandItem.twoHanded {
                        rightHandButton.item?.equipped = false
                    }
                default:
                    let equipmentButton = freeEquipmentButtonForItemSlot(item.itemSlot)
                    equipmentButton?.item?.equipped = false
            }
            
            item.equipped = true
            
            updateEquippedItems()
            saveHero()
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) { }
    
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool { return true }
    
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
            default:
                break
        }
        
        saveHero()
    }
}

private extension Selector {
    static let unequipItem = #selector(HeroViewController.unequipItem(_:))
}
