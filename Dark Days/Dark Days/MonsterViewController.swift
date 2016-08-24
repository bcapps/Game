//
//  MonsterViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class MonsterViewController: UIViewController {
    
    private var monsterView: MonsterView {
        get {
            return view as! MonsterView // swiftlint:disable:this force_cast
        }
    }
    
    override func loadView() {        
        self.view = MonsterView.instantiateViewFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monsterView.backgroundColor = UIColor.backgroundColor()
        monsterView.viewModel = MonsterView.ViewModel(name: "Animated Armor", type: "Medium construct, unaligned", health: "20", speed: "25 ft", damageImmunities: ["poison, psychic"], conditionImmunites: ["blinded", "charmed", "deafened", "exhaustion", "frightened", "paralyzed", "petrified", "poisoned"], languages: ["Common", "Dwarven"], abilities: ["Cool stuff"], actions: ["Hit Stuff 1", "Hit Stuff 2"])
        
        print("HI")
    }
}
