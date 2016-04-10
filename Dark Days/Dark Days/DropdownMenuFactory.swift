//
//  DropdownMenuFactory.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/29/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import AZDropdownMenu

final class DropdownMenuFactory {
    
    static func heroDropdownMenu() -> AZDropdownMenu {
        guard let inventoryImage = UIImage(named: "Inventory"), spellbookImage = UIImage(named: "Spellbook"), skillImage = UIImage(named: "Skills"), effectsImage = UIImage(named: "EffectsListIcon"), heroToolsImage = UIImage(named: "HeroTools") else { return AZDropdownMenu(dataSource: []) }
        
        let inventoryItem = AZDropdownMenuItemData(title: "Inventory", icon: inventoryImage)
        let spellbookItem = AZDropdownMenuItemData(title: "Spellbook", icon: spellbookImage)
        let skillsItem = AZDropdownMenuItemData(title: "Skills", icon: skillImage)
        let effectsMenu = AZDropdownMenuItemData(title: "Show/Hide Effects", icon: effectsImage)
        let heroTools = AZDropdownMenuItemData(title: "Hero Tools", icon: heroToolsImage)
        
        let menu = AZDropdownMenu(dataSource: [inventoryItem, spellbookItem, skillsItem, effectsMenu, heroTools])
        customizeMenu(menu)
        
        return menu
    }
    
    static func customizeMenu(menu: AZDropdownMenu) {
        menu.itemColor = .backgroundColor()
        menu.itemFontColor = .headerTextColor()
        menu.itemFontName = UIFont.headingFont().fontName
        menu.itemFontSize = UIFont.headingFont().pointSize
        menu.itemHeight = 54
    }
}
