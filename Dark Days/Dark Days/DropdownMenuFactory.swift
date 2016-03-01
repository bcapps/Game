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
        let inventoryItem = AZDropdownMenuItemData(title: "Inventory", icon: UIImage(named: "Inventory")!)
        let spellbookItem = AZDropdownMenuItemData(title: "Spellbook", icon: UIImage(named: "Spellbook")!)
        let skillsItem = AZDropdownMenuItemData(title: "Skills", icon: UIImage(named: "Skills")!)
        
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