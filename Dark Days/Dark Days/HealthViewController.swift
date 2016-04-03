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
    
    @IBAction private func healthUp(sender: AnyObject) {
        adjustHealthByValue(1)
    }
    
    @IBAction private func healthDown(sender: AnyObject) {
        adjustHealthByValue(-1)
    }
    
    private func adjustHealthByValue(value: Int) {
        guard let hero = hero else { return }
        
        if hero.currentHealth + value > hero.maximumHealth {
            hero.currentHealth = hero.maximumHealth
        } else if hero.currentHealth + value < 0 {
            hero.currentHealth = 0
        } else {
            hero.currentHealth = hero.currentHealth + value
        }
        
        healthDownButton.enabled = hero.currentHealth != 0
        healthUpButton.enabled = hero.currentHealth != hero.maximumHealth
        
        healthLabel.text = String(hero.currentHealth) + "/" + String(hero.maximumHealth)
        healthLabel.textColor = textColor(Double(hero.currentHealth), maximumHealth: Double(hero.maximumHealth))
        
        HeroPersistence().persistHero(hero)
    }
    
    private func textColor(currentHealth: Double, maximumHealth: Double) -> UIColor {
        if currentHealth / maximumHealth < 0.33 {
            return .redColor()
        } else if currentHealth / maximumHealth < 0.66 {
            return .yellowColor()
        } else {
            return .greenColor()
        }
    }
}
