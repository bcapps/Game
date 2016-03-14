//
//  HeroViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import AZDropdownMenu

final class HeroViewController: UIViewController, ListViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var helmetButton: EquipmentButton!
    @IBOutlet weak var accessoryButton: EquipmentButton!
    @IBOutlet weak var leftHandButton: EquipmentButton!
    @IBOutlet weak var rightHandButton: EquipmentButton!
    @IBOutlet weak var chestButton: EquipmentButton!
    @IBOutlet weak var bootsButton: EquipmentButton!
    
    @IBOutlet var equipmentButtons: [EquipmentButton]! // swiftlint:disable:this force_unwrapping
    
    var hero: Hero?
    
    private let menu = DropdownMenuFactory.heroDropdownMenu()
    private let animationDuration = 0.35
    
    private var overlayView: UIView?
    private var presentedOverlayController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = hero?.name
        view.backgroundColor = .backgroundColor()
        
        overlayView = UIView(frame: view.frame)
        overlayView?.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        overlayView?.userInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissOverlay"))
        overlayView?.addGestureRecognizer(tapRecognizer)
        
        addItemSlotToEquipmentButtons()
        updateEquippedItems()
        addMenuTapHandlers()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let _ = segue.destinationViewController.view
        
        if let viewController = segue.destinationViewController as? HealthViewController {
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
        
        let button = UnequipButton(item: item)
        button.backgroundColor = .backgroundColor()
        button.setTitle("Unequip", forState: .Normal)
        button.titleLabel?.font = UIFont.bodyFont()
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.7), forState: .Highlighted)
        button.addTarget(self, action: Selector("unequipItem:"), forControlEvents: .TouchUpInside)
        
        presentOverlayWithListViewController(itemsList, footerView: button)
    }
    
    private func presentItemList() {
        guard let items = hero?.inventory.items.filter({$0.equipped == false}) else { return }

        let itemsList = ListViewController<Item>(objects: items, delegate: nil)
        itemsList.title = "Inventory"
        itemsList.tableView.allowsSelection = false
        
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
        skillsList.tableView.allowsSelection = false
        
        presentListViewController(skillsList)
    }
    
    private func presentSpellsList() {
        guard let spells = hero?.spells else { return }
        
        let spellsList = ListViewController<Spell>(objects: spells, delegate: nil)
        spellsList.title = "Spellbook"
        spellsList.tableView.allowsSelection = false
        
        presentListViewController(spellsList)
    }
    
    private func presentStat(stat: Stat) {
        let statList = ListViewController<Stat>(objects: [stat], delegate: nil)
        
        presentOverlayWithListViewController(statList)
    }
    
    private func presentListViewController<T>(viewController: ListViewController<T>) {
        viewController.imageContentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentOverlayWithListViewController<T>(viewController: ListViewController<T>, footerView: UIView? = nil) {
        var frame = CGRectInset(view.frame, 40, 75)
        frame.origin.y = 50
        
        let containingViewController = UIViewController()
        containingViewController.view.frame = frame
        containingViewController.view.layer.cornerRadius = 12.0
        containingViewController.view.layer.borderWidth = 1.0
        containingViewController.view.layer.borderColor = UIColor.grayColor().CGColor
        
        viewController.tableView.separatorStyle = .None
        viewController.tableView.allowsSelection = false
        viewController.view.frame = containingViewController.view.bounds
        viewController.imageContentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        containingViewController.addViewController(viewController)
        
        if let footerView = footerView {
            let height: CGFloat = 40.0
            let footerViewFrame = CGRect(x: 0, y: viewController.view.frame.size.height - height, width: viewController.view.frame.size.width, height: height)
            footerView.frame = footerViewFrame
            containingViewController.view.addSubview(footerView)
            viewController.tableView.contentInset.bottom = 15
            
            footerView.layer.addSublayer(BorderGenerator.newTopBorder(footerView.frame.size.width, height: 1.0))
        }
        
        if let overlayView = overlayView {
            overlayView.alpha = 0.0
            view.addSubview(overlayView)
            UIView.animateWithDuration(animationDuration) {
                overlayView.alpha = 1.0
            }
        }
        
        replaceChildViewController(presentedOverlayController, newViewController: containingViewController, animationDuration: animationDuration)
        presentedOverlayController = containingViewController
    }
    
    func dismissOverlay() {
        if let presentedController = presentedOverlayController {
            UIView.animateWithDuration(animationDuration, animations: {
                self.overlayView?.alpha = 0.0
                }, completion: { completed in
                    self.overlayView?.removeFromSuperview()
            })
            
            replaceChildViewController(presentedController, newViewController: nil, animationDuration: animationDuration)
            presentedOverlayController = nil
        }
    }
    
    func unequipItem(button: UnequipButton) {
        button.item.equipped = false
        updateEquippedItems()
        
        dismissOverlay()
        
        saveHero()
    }
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StatCellIdentifier", forIndexPath: indexPath) as? StatCell
        let stat = hero?.stats[indexPath.row]
        
        cell?.statTitle.text = stat?.shortName
        if let value = stat?.currentValue {
            cell?.statValue.text = String(value)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let stat = hero?.stats[indexPath.row]
        
        if let stat = stat {
            presentStat(stat)
        }
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
}

private class BorderGenerator {
    static func newTopBorder(width: CGFloat, height: CGFloat) -> CALayer {
        let border: CALayer = CALayer()
        border.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        border.backgroundColor = UIColor.grayColor().CGColor
        
        return border
    }
}
