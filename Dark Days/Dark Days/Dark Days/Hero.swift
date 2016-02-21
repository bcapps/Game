//
//  Hero.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

enum Gender: String {
    case Female
    case Male
}

struct Hero {
    let name: String
    let gender: Gender
    let inventory: Inventory
    let stats: [Stat]
    let race: Race
    let skills: [Skill]
}
