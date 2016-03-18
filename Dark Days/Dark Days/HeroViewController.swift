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
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var multipeer: LCKMultipeer?
    
    var hero: Hero? {
        didSet {
            multipeer = LCKMultipeer(multipeerUserType: .Client, peerName: hero?.name ?? "No Name", serviceName: "DarkDays")
            multipeer?.startMultipeerConnectivity()
            multipeer?.addEventListener(self)
        }
    }
    
    private let menu = DropdownMenuFactory.heroDropdownMenu()
    private let animationDuration = 0.35
    
    private let overlayView = OverlayView()
    private var presentedOverlayController: UIViewController?
    
    deinit {
        multipeer?.stopMultipeerConnectivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = hero?.name
        view.backgroundColor = .backgroundColor()
        
        overlayView.frame = view.frame
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissOverlay"))
        overlayView.addGestureRecognizer(tapRecognizer)
        
        addItemSlotToEquipmentButtons()
        updateEquippedItems()
        addMenuTapHandlers()
        
        let itemSpacing = collectionViewFlowLayout.minimumInteritemSpacing
        let numberOfItems = CGFloat(5)
        
        collectionViewFlowLayout.itemSize = CGSize(width: (CGRectGetWidth(view.frame) - (itemSpacing * numberOfItems)) / numberOfItems, height: 45)
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
        var button: UnequipButton?
        
        if item.equipped {
            button = UnequipButton(item: item)
            button?.addTarget(self, action: Selector("unequipItem:"), forControlEvents: .TouchUpInside)
        }
        
        presentObjectInOverlay(item, footerView: button)
    }
    
    private func presentItemList() {
        guard let items = hero?.inventory.items.filter({$0.equipped == false}) else { return }
        
        showList(items, title: "Inventory")
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
    
    func presentObjectInOverlay<T: ListDisplayingGeneratable>(object: T, footerView: UIView? = nil) {
        let section = SectionList(sectionTitle: nil, objects: [object])
        let list = ListViewController<T>(sections: [section], delegate: nil)
        
        presentOverlayWithListViewController(list, footerView: footerView)
    }
    
    func showList<T: ListDisplayingGeneratable>(objects: [T], title: String, allowsSelection: Bool = false) {
        
        let section = SectionList(sectionTitle: nil, objects: objects)
        let list = ListViewController<T>(sections: [section], delegate: self)
        list.title = title
        list.tableView.allowsSelection = allowsSelection
        
        presentListViewController(list)
    }
    
    private func presentListViewController<T>(viewController: ListViewController<T>) {
        viewController.imageContentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentOverlayWithListViewController<T>(viewController: ListViewController<T>, footerView: UIView? = nil) {
        var frame = CGRectInset(view.frame, 50, 85)
        frame.origin.y = 50
        
        let containingViewController = ContainingViewController(containedViewController: viewController, footerView: footerView)
        containingViewController.view.frame = frame
        viewController.imageContentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        overlayView.showOverlayViewInView(view, animationDuration: animationDuration)
        
        replaceChildViewController(presentedOverlayController, newViewController: containingViewController, animationDuration: animationDuration)
        presentedOverlayController = containingViewController
    }
    
    func dismissOverlay() {
        if let presentedController = presentedOverlayController {
            overlayView.removeOverlayView(animationDuration)
            
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
                break
            default:
                break
        }
        
        saveHero()
    }
}

private class ContainingViewController: UIViewController {
    
    let containedViewController: UITableViewController
    let footerView: UIView?
    let footerViewBorder = BorderGenerator.newTopBorder(0, height: 0)
    
    init(containedViewController: UITableViewController, footerView: UIView?) {
        self.containedViewController = containedViewController
        self.footerView = footerView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.containedViewController = UITableViewController()
        self.footerView = UIView()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 12.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.grayColor().CGColor
        
        containedViewController.tableView.separatorStyle = .None
        containedViewController.tableView.allowsSelection = false
        containedViewController.view.frame = view.bounds
        
        addViewController(containedViewController)
        
        if let footerView = footerView {
            view.addSubview(footerView)
            footerView.layer.addSublayer(footerViewBorder)
            containedViewController.tableView.contentInset.bottom = 15
        }
    }
    
    private override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containedViewController.view.frame = view.bounds
        let height: CGFloat = 40.0
        footerView?.frame = CGRect(x: 0, y: view.frame.size.height - height, width: view.frame.size.width, height: height)
        footerViewBorder.frame = CGRect(x: 0, y: 0, width: footerView?.frame.size.width ?? 0, height: 1.0)
    }
}

private class OverlayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showOverlayViewInView(view: UIView, animationDuration: NSTimeInterval) {
        alpha = 0.0
        view.addSubview(self)
        
        UIView.animateWithDuration(animationDuration) {
            self.alpha = 1.0
        }
    }
    
    func removeOverlayView(animationDuration: NSTimeInterval) {
        UIView.animateWithDuration(animationDuration, animations: {
            self.alpha = 0.0
        }, completion: { completed in
            self.removeFromSuperview()
        })
    }
}

private class BorderGenerator {
    static func newTopBorder(width: CGFloat, height: CGFloat) -> CALayer {
        let border: CALayer = CALayer()
        border.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        border.backgroundColor = UIColor.grayColor().CGColor
        
        return border
    }
}
