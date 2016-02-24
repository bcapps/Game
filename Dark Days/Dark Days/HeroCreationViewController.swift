//
//  HeroCreationViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

public class HeroCreationViewController: UIViewController, RaceListViewControllerDelegate, SkillsListViewControllerDelegate {
    
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
        
        view.backgroundColor = .backgroundColor()
        nameField.backgroundColor = .backgroundColor()
        nameField.textColor = .headerTextColor()
        nameField.font = .smallFont()
        nameField.attributedPlaceholder = NSAttributedString.attributedStringWithSmallAttributes("Hero Name")
        
        transitionToRaceList()
    }
    
    internal func didSelectRace(raceListViewController: RaceListViewController, race: Race) {
        heroBuilder.race = race
        nextButton.enabled = true
    }
    
    internal func didSelectSkill(skillsListViewController: SkillsListViewController, skill: Skill) {
        heroBuilder.skill = skill
        nextButton.enabled = true
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
                
                transitionToItemList()
            }
        }
        else if currentCreationState == .ChooseSkill {
            transitionToItemList()
        }
        else if currentCreationState == .ChooseAttributes {
            
        }
    }
    
    private func transitionToItemList() {
        currentCreationState = .ChooseAttributes
        
        let itemListViewController = ItemListViewController()
        itemListViewController.items = ObjectProvider.objectsForJSON("Items")
        
        switchToViewController(itemListViewController)
    }
    
    private func transitionToRaceList() {
        currentCreationState = .ChooseRace
        
        let raceListViewController = RaceListViewController()
        raceListViewController.raceListDelegate = self
        raceListViewController.races = ObjectProvider.objectsForJSON("Races")
        
        switchToViewController(raceListViewController)
    }
    
    private func transitionToSkillList() {
        currentCreationState = .ChooseSkill

        let skillListViewController = SkillsListViewController()
        skillListViewController.skillsListDelegate = self
        skillListViewController.skills = ObjectProvider.objectsForJSON("Skills")
        
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
