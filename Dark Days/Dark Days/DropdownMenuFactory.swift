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
        guard let inventoryImage = UIImage(named: "Inventory"), let spellbookImage = UIImage(named: "Spellbook"), let skillImage = UIImage(named: "Skills"), let heroToolsImage = UIImage(named: "HeroTools") else { return REMenu() }
        
        let inventoryItem: REMenuItem = REMenuItem(title: "Inventory", subtitle: "", image: inventoryImage, highlightedImage: nil, action: nil)
        let spellbookItem: REMenuItem = REMenuItem(title: "Spellbook", subtitle: "", image: spellbookImage, highlightedImage: nil, action: nil)
        let skillsItem: REMenuItem = REMenuItem(title: "Skills", subtitle: "", image: skillImage, highlightedImage: nil, action: nil)
        let heroTools: REMenuItem = REMenuItem(title: "Hero Tools", subtitle: "", image: heroToolsImage, highlightedImage: nil, action: nil)

        let menu = REMenu(items: [inventoryItem, spellbookItem, skillsItem, heroTools])
        
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
