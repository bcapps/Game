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
        nextButton.title = "Next"

        if currentCreationState == .ChooseRace {
            if heroBuilder.race.raceType == .Human {
                transitionToSkillList()
            }
            else {
                if heroBuilder.race.raceType == .Elf {
                    heroBuilder.skill = ObjectProvider.skillForName("Elven Accuracy")
                }
                else if heroBuilder.race.raceType == .Dwarf {
                    heroBuilder.skill = ObjectProvider.skillForName("Dwarven Resilience")
                }
                
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
        else if let object = object as? Stat {
            heroBuilder.setStatValueForStat(1, stat: object)
        }
    }
    
    private func transitionToStatList() {
        currentCreationState = .ChooseAttributes
        
        let statListViewController = ListViewController<Stat>(style: .Plain)
        statListViewController.listDelegate = self
        statListViewController.objects = ObjectProvider.objectsForJSON("Stats")
        
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
