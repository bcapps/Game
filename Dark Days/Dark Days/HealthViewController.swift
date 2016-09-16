//
//  HealthViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/13/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HealthViewController: UIViewController {
    
    var hero: Hero? {
        didSet {            
            adjustHealthByValue(0)
        }
    }
    
    @IBOutlet weak var healthLabel: UILabel!
    
    @IBOutlet weak var healthUpButton: UIButton!
    @IBOutlet weak var healthDownButton: UIButton!
    
    @IBAction fileprivate func healthUp(_ sender: AnyObject) {
        adjustHealthByValue(1)
    }
    
    @IBAction fileprivate func healthDown(_ sender: AnyObject) {
        adjustHealthByValue(-1)
    }
    
    fileprivate func adjustHealthByValue(_ value: Int) {
        guard let hero = hero else { return }
        
        if hero.currentHealth + value > hero.maximumHealth {
            hero.currentHealth = hero.maximumHealth
        } else if hero.currentHealth + value < 0 {
            hero.currentHealth = 0
        } else {
            hero.currentHealth = hero.currentHealth + value
        }
        
        healthDownButton.isEnabled = hero.currentHealth != 0
        healthUpButton.isEnabled = hero.currentHealth != hero.maximumHealth
        
        healthLabel.text = String(hero.currentHealth) + "/" + String(hero.maximumHealth)
        healthLabel.textColor = textColor(Double(hero.currentHealth), maximumHealth: Double(hero.maximumHealth))
        
        HeroPersistence().persistHero(hero)
    }
    
    fileprivate func textColor(_ currentHealth: Double, maximumHealth: Double) -> UIColor {
        if currentHealth / maximumHealth < (1 / 3) {
            return UIColor.red
        } else if currentHealth / maximumHealth < (2 / 3) {
            return UIColor.yellow
        } else {
            return UIColor.green
        }
    }
}
