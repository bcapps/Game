//
//  DropdownMenuFactory.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/29/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import REMenu

final class DropdownMenuFactory {
    
    static func heroDropdownMenu() -> REMenu {
        guard let inventoryImage = UIImage(named: "Inventory"), spellbookImage = UIImage(named: "Spellbook"), skillImage = UIImage(named: "Skills"), heroToolsImage = UIImage(named: "HeroTools") else { return REMenu() }
        
        let inventoryItem = REMenuItem(title: "Inventory", subtitle: nil, image: inventoryImage, highlightedImage: nil, action: nil)
        let spellbookItem = REMenuItem(title: "Spellbook", subtitle: nil, image: spellbookImage, highlightedImage: nil, action: nil)
        let skillsItem = REMenuItem(title: "Skills", subtitle: nil, image: skillImage, highlightedImage: nil, action: nil)
        let heroTools = REMenuItem(title: "Hero Tools", subtitle: nil, image: heroToolsImage, highlightedImage: nil, action: nil)

        let menu = REMenu(items: [inventoryItem, spellbookItem, skillsItem, heroTools])
        
        customizeMenu(menu)
        
        return menu
    }
    
    static func customizeMenu(menu: REMenu) {
        menu.font = .headingFont()
        menu.textColor = .headerTextColor()
        menu.liveBlur = true
        menu.liveBlurBackgroundStyle = .Dark
        menu.closeAnimationDuration = 0.1
        menu.itemHeight = 54
    }
}
