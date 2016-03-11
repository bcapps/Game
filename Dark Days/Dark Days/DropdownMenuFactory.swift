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
        guard let inventoryImage = UIImage(named: "Inventory"), spellbookImage = UIImage(named: "Spellbook"), skillImage = UIImage(named: "Skills") else { return AZDropdownMenu(dataSource: []) }
        
        let inventoryItem = AZDropdownMenuItemData(title: "Inventory", icon: inventoryImage)
        let spellbookItem = AZDropdownMenuItemData(title: "Spellbook", icon: spellbookImage)
        let skillsItem = AZDropdownMenuItemData(title: "Skills", icon: skillImage)
        
        let menu = AZDropdownMenu(dataSource: [inventoryItem, spellbookItem, skillsItem])
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
