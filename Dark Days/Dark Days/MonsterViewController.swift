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
        
        monsterView.statCollectionView?.registerNibForClass(StatCell.self, reuseIdentifier: "StatCellIdentifier")
        
        monsterView.statCollectionView?.delegate = self
        monsterView.statCollectionView?.dataSource = self
        monsterView.backgroundColor = UIColor.backgroundColor()
        
        monsterView.attackTapped = { attack in
            guard let monster = self.monster else { return }
            guard let attack = monster.attack(forName: attack.name) else { return }
            
            let controller = UIAlertController(title: attack.name, message: self.attackStringForAttack(attack), preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
            
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StatCellIdentifier", forIndexPath: indexPath) as? StatCell
        let stat = monsterView.viewModel?.stats[indexPath.row]
        
        cell?.statTitle.text = stat?.name
        cell?.statValue.text = stat?.value
        
        return cell ?? UICollectionViewCell()
    }
    
    private func attackStringForAttack(attack: MonsterAttack) -> String {
        let damage = attack.damage
        
        let attackRoll = GKShuffledDistribution(forDieWithSideCount: 20).nextInt()
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        
        var damageWithNumberReplacement = String()
        
        for substring in damage.componentsSeparatedByString(" ") {
            let decimalRange = substring.rangeOfCharacterFromSet(digits, options: NSStringCompareOptions(), range: nil)
            
            damageWithNumberReplacement.appendContentsOf(substring)
            
            if decimalRange != nil {
                let separatedStrings = substring.componentsSeparatedByString("d")
                
                if separatedStrings.count == 2 {
                    let damageDiceString = separatedStrings[0]
                    let damageRollString = separatedStrings[1]
                    
                    if let damageDice = Int(damageDiceString), damageRoll = Int(damageRollString) {
                        var totalDamage = 0
                        
                        let damageRandomizer = GKShuffledDistribution(forDieWithSideCount: damageRoll)
                        
                        for _ in 1...damageDice {
                            totalDamage += damageRandomizer.nextInt()
                        }
                        
                        damageWithNumberReplacement.appendContentsOf("(\(totalDamage))")
                    }
                }
            }
            
            damageWithNumberReplacement.appendContentsOf(" ")
        }
        
        return "Attack Roll: \(attackRoll)" + "\n" + "Damage Roll: " + damageWithNumberReplacement
    }
}
