//
//  HeroCreationViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

public class HeroCreationViewController: UIViewController, ListViewControllerDelegate {
    
    private enum HeroCreationState: String {
        case ChooseRace
        case ChooseSkill
        case ChooseAttributes
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    private let heroBuilder = HeroBuilder()
    private let statListViewController = StatSelectionViewController(style: .Plain)

    private var currentCreationState: HeroCreationState = .ChooseRace
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let nameFieldFont = UIFont(name: "Avenir-Heavy", size: 21.0) ?? UIFont.systemFontOfSize(21.0)
        
        view.backgroundColor = .backgroundColor()
        nameField.backgroundColor = .backgroundColor()
        nameField.textColor = .headerTextColor()
        nameField.font = nameFieldFont
        nameField.attributedPlaceholder = NSAttributedString(string: "Enter Hero Name", attributes: [NSForegroundColorAttributeName: UIColor.sideTextColor(), NSFontAttributeName: nameFieldFont])
        
        transitionToRaceList()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        nextButton.title = "Next"

        if currentCreationState == .ChooseRace {
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        else if currentCreationState == .ChooseSkill {
            transitionToRaceList()
        }
        else if currentCreationState == .ChooseAttributes {
            if heroBuilder.race.raceType == .Human {
                transitionToSkillList()
            }
            else {
                transitionToRaceList()
            }
        }
        
        nextButton.enabled = false
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        nextButton.enabled = false

        if currentCreationState == .ChooseRace {
            if heroBuilder.race.raceType == .Human {
                transitionToSkillList()
            }
            else {
                heroBuilder.skill = heroBuilder.race.startingSkill
                
                transitionToStatList()
            }
        }
        else if currentCreationState == .ChooseSkill {
            transitionToStatList()
            nextButton.title = "Done"
        }
        else if currentCreationState == .ChooseAttributes {
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            
            heroBuilder.name = nameField.text ?? "Default Name"
            
            for stat in statListViewController.selectedStats {
                switch heroBuilder.race.raceType {
                case .Elf: fallthrough
                case .Dwarf:
                    heroBuilder.setStatValueForStat(2, stat: stat)
                case .Human:
                    heroBuilder.setStatValueForStat(1, stat: stat)
                }
            }
            
            HeroPersistence().persistHero(heroBuilder.build())
        }
    }
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        nextButton.enabled = true
        
        if let object = object as? Race {
            heroBuilder.race = object
        }
        else if let object = object as? Skill {
            heroBuilder.skill = object
        }
    }
    
    private func transitionToStatList() {
        currentCreationState = .ChooseAttributes
        
        statListViewController.objects = heroBuilder.race.startingStats
        
        title = "Choose Stat"
        
        switchToViewController(statListViewController)
    }
    
    private func transitionToRaceList() {
        currentCreationState = .ChooseRace
        
        let raceListViewController = ListViewController<Race>(style: .Plain)
        raceListViewController.listDelegate = self
        raceListViewController.objects = ObjectProvider.objectsForJSON("Races")
        
        title = "Choose Race"
        
        switchToViewController(raceListViewController)
    }
    
    private func transitionToSkillList() {
        currentCreationState = .ChooseSkill
        
        let skillListViewController = ListViewController<Skill>(style: .Plain)
        skillListViewController.listDelegate = self
        skillListViewController.objects = ObjectProvider.objectsForJSON("Skills")
        
        title = "Choose Skill"
        
        switchToViewController(skillListViewController)
    }
    
    private func switchToViewController(viewController: UIViewController) {
        setFrameForChildViewController(viewController)
        switchToChildViewController(viewController)
    }
    
    private func setFrameForChildViewController(viewController: UIViewController) {
        var frame = viewController.view.frame
        frame.origin.y = CGRectGetMaxY(nameField.frame) + 10
        frame.size.height -= CGRectGetMaxY(nameField.frame) + 10
        viewController.view.frame = frame
    }
}

private extension Race {
    var startingStats: [Stat] {
        switch raceType {
        case .Elf:
            let dexterity = ObjectProvider.statForName("Dexterity")
            let intelligence = ObjectProvider.statForName("Intelligence")
            
            if let dexterity = dexterity, intelligence = intelligence {
                return [dexterity, intelligence]
            }
        case .Dwarf:
            let constitution = ObjectProvider.statForName("Constitution")
            let faith = ObjectProvider.statForName("Faith")
            
            if let constitution = constitution, faith = faith {
                return [constitution, faith]
            }
        case .Human:
            return ObjectProvider.objectsForJSON("Stats")
        }
        
        return []
    }
    
    var startingSkill: Skill? {
        switch raceType {
        case .Elf:
            return ObjectProvider.skillForName("Elven Accuracy")
        case .Dwarf:
            return ObjectProvider.skillForName("Dwarven Resilience")
        case .Human:
            return nil
        }
    }
}
