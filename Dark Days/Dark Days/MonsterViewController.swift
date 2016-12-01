//
//  MonsterViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import GameplayKit
class MonsterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var monster: Monster? {
        didSet {
            guard let monster = monster else { monsterView.viewModel = nil; return }
            
            monsterView.viewModel = MonsterViewModelTranslator.transform(monster)
        }
    }
    
    fileprivate var monsterView: MonsterView {
        get {
            return view as! MonsterView // swiftlint:disable:this force_cast
        }
    }
    
    override func loadView() {        
        self.view = MonsterView.instantiateViewFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monsterView.statCollectionView?.registerNibForClass(StatCell.self, reuseIdentifier: "StatCellIdentifier")
        
        monsterView.statCollectionView?.delegate = self
        monsterView.statCollectionView?.dataSource = self
        monsterView.backgroundColor = UIColor.backgroundColor()
        
        monsterView.attackTapped = { attack in
            guard let monster = self.monster else { return }
            guard let attack = monster.attack(forName: attack.name) else { return }
            
            let message = attack.attackStringForMonster(monster: monster)
            let controller = UIAlertController(title: attack.name, message: message, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatCellIdentifier", for: indexPath) as? StatCell
        let stat = monsterView.viewModel?.stats[(indexPath as NSIndexPath).row]
        
        cell?.statTitle.text = stat?.name
        cell?.statValue.text = stat?.value
        
        return cell ?? UICollectionViewCell()
    }
}

private extension MonsterAttack {
    
    func attackStringForMonster(monster: Monster) -> String {
        let attackDiceRoll = (DiceRoller.roll(dice: .d20))
        let attackModifier = monster.attackModifier(forAttackType: attack.attackType)
        
        let naturalText = attackDiceRoll == 20 ? " (Natural 20!)" : ""
        
        let dice = Dice.diceForUpperValue(value: attack.damageDiceValue)
        let attackDamageRoll = DiceRoller.roll(dice: dice, count: attack.damageDiceNumber)
        let damageModifier = monster.damageModifier(forAttack: attack)
        
        let attackResult = String(format: "Attack Roll: %@%@", String(attackDiceRoll + attackModifier), naturalText)
        let damageResult = String(format: "Damage: %@", String(attackDamageRoll + damageModifier))
        
        return attackResult + "\n" + damageResult
    }
}

private extension Monster {
    
    func damageModifier(forAttack attack: Attack) -> Int {
        return stats.filter { $0.name == attack.damageStat.shortName }.first?.value ?? 0
    }
    
    func attackModifier(forAttackType type: AttackModifierType) -> Int {
        switch type {
        case .Melee:
            return stats.filter { $0.name == "STR" }.first?.value ?? 0
        case .Ranged:
            return stats.filter { $0.name == "DEX" }.first?.value ?? 0
        case .Magical:
            return stats.filter { $0.name == "INT" }.first?.value ?? 0
        }
    }
}
