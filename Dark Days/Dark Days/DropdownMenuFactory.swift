//
//  DropdownMenuFactory.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/29/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import REMenu

enum MenuItemTag: Int {
    case inventory
    case spellbook
    case skillsItem
    case heroTools
    case worldMap
    case loreBook
}

final class DropdownMenuFactory {
    
    static func heroDropdownMenu(hero: Hero) -> REMenu {
        guard let inventoryImage = UIImage(named: "Inventory"), let spellbookImage = UIImage(named: "Spellbook"), let skillImage = UIImage(named: "Skills"), let heroToolsImage = UIImage(named: "HeroTools"), let worldMapImage = UIImage(named: "WorldMapIcon"), let loreBookImage = UIImage(named: "LoreIcon") else { return REMenu() }
        
        let inventoryItem: REMenuItem = REMenuItem(title: "Inventory", subtitle: "", image: inventoryImage, highlightedImage: nil, action: nil)
        inventoryItem.tag = MenuItemTag.inventory.rawValue
        
        let spellbookItem: REMenuItem = REMenuItem(title: "Spellbook", subtitle: "", image: spellbookImage, highlightedImage: nil, action: nil)
        spellbookItem.tag = MenuItemTag.spellbook.rawValue

        let skillsItem: REMenuItem = REMenuItem(title: "Skills", subtitle: "", image: skillImage, highlightedImage: nil, action: nil)
        skillsItem.tag = MenuItemTag.skillsItem.rawValue

        let heroTools: REMenuItem = REMenuItem(title: "Hero Tools", subtitle: "", image: heroToolsImage, highlightedImage: nil, action: nil)
        heroTools.tag = MenuItemTag.heroTools.rawValue

        let worldMap: REMenuItem = REMenuItem(title: "World Map", subtitle: "", image: worldMapImage, highlightedImage: nil, action: nil)
        worldMap.tag = MenuItemTag.worldMap.rawValue

        let loreBook: REMenuItem = REMenuItem(title: "Lore", subtitle: "", image: loreBookImage, highlightedImage: nil, action: nil)
        loreBook.tag = MenuItemTag.loreBook.rawValue
        
        var items: [REMenuItem] = [inventoryItem, spellbookItem, skillsItem, loreBook]
        
        if let item = ObjectProvider.itemForName("Map of Idris"), hero.inventory.items.contains(item) {
            items.append(worldMap)
        }
        
        items.append(heroTools)
        
        let menu = REMenu(items: items)
        
        customizeMenu(menu!) // swiftlint:disable:this force_unwrapping
        return menu! // swiftlint:disable:this force_unwrapping
    }
    
    static func customizeMenu(_ menu: REMenu) {
        menu.font = .headingFont()
        menu.textColor = .headerTextColor()
        menu.liveBlur = true
        menu.liveBlurBackgroundStyle = .dark
        menu.closeAnimationDuration = 0.1
        menu.itemHeight = 54
    }
}
