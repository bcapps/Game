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
            
            let controller = UIAlertController(title: attack.name, message: attack.attackString, preferredStyle: .alert)
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
    var attackString: String {
        get {
            let attackRoll = DiceRoller.roll(dice: .d20)
            let digits = CharacterSet.decimalDigits
            
            var damageWithNumberReplacement = String()
            
            for substring in damage.components(separatedBy: " ") {
                let decimalRange = substring.rangeOfCharacter(from: digits, options: NSString.CompareOptions(), range: nil)
                
                damageWithNumberReplacement.append(substring)
                
                if decimalRange != nil {
                    let separatedStrings = substring.components(separatedBy: "d")
                    
                    if separatedStrings.count == 2 {
                        let damageDiceString = separatedStrings[0]
                        let damageRollString = separatedStrings[1]
                        
                        if let damageDice = Int(damageDiceString), let damageRoll = Int(damageRollString) {
                            var totalDamage = 0
                            
                            let damageRandomizer = GKShuffledDistribution(forDieWithSideCount: damageRoll)
                            
                            for _ in 1...damageDice {
                                totalDamage += damageRandomizer.nextInt()
                            }
                            
                            damageWithNumberReplacement.append("(\(totalDamage))")
                        }
                    }
                }
                
                damageWithNumberReplacement.append(" ")
            }
            
            return "Attack Roll: \(attackRoll)" + "\n" + "Damage Roll: " + damageWithNumberReplacement
        }
    }
}
