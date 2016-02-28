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
        case ChooseMagicType
        case ChooseGod
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    private let heroBuilder = HeroBuilder()

    private var selectedStats = [Stat]()
    private var currentCreationState: HeroCreationState = .ChooseRace
    
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .backgroundColor()
        nameField.backgroundColor = .backgroundColor()
        nameField.textColor = .headerTextColor()
        nameField.font = .heavyLargeFont()
        nameField.attributedPlaceholder = NSAttributedString(string: "Enter Hero Name", attributes: [NSForegroundColorAttributeName: UIColor.sideTextColor(), NSFontAttributeName: UIFont.heavyLargeFont()])
        
        transitionToRaceList()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        nextButton.title = "Next"

        switch(currentCreationState) {
            case .ChooseRace:
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            case .ChooseSkill:
                transitionToRaceList()
            case .ChooseAttributes:
                if heroBuilder.race.raceType == .Human {
                    transitionToSkillList()
                }
                else {
                    transitionToRaceList()
                }
            case .ChooseMagicType:
                transitionToStatList()
            case .ChooseGod:
                transitionToMagicTypeList()
        }
        
        nextButton.enabled = false
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        nextButton.enabled = false

        switch(currentCreationState) {
            case .ChooseRace:
                switch heroBuilder.race.raceType {
                    case .Human:
                        transitionToSkillList()
                    case .Elf: fallthrough
                    case .Dwarf: fallthrough
                    default:
                        heroBuilder.skill = heroBuilder.race.startingSkill
                        transitionToStatList()
            }
            case .ChooseSkill:
                transitionToStatList()
            case .ChooseAttributes:
                transitionToMagicTypeList()
            case .ChooseMagicType:
                switch heroBuilder.magicType.status {
                    case .Mundane:
                        buildAndPersistHero()
                        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    case .Gifted:
                        nextButton.title = "Done"
                        transitionToGodList()
                }
            case .ChooseGod:
                buildAndPersistHero()
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func canSelectObject<T : ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool {
        if currentCreationState == .ChooseAttributes && heroBuilder.race.raceType == .Human {
            return selectedStats.count < 2
        }
        
        return true
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
            selectedStats.append(object)
        }
        else if let object = object as? MagicType {
            switch object.status {
                case .Mundane:
                    nextButton.title = "Done"
                case .Gifted:
                    nextButton.title = "Next"
            }

            heroBuilder.magicType = object
        }
        else if let object = object as? God {
            heroBuilder.god = object
        }
    }
    
    func didDeselectObject<T : ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        if let object = object as? Stat {
            selectedStats.removeObject(object)
        }
    }
    
    private func transitionToStatList() {
        selectedStats.removeAll()
        currentCreationState = .ChooseAttributes
        
        let statListViewController = ListViewController<Stat>(objects: heroBuilder.race.startingStats, delegate: self)
        statListViewController.tableView.allowsMultipleSelection = heroBuilder.race.raceType == .Human
        
        title = "Choose Stat"
        
        switchToViewController(statListViewController)
    }
    
    private func transitionToMagicTypeList() {
        currentCreationState = .ChooseMagicType
        
        let magicTypeListViewController = ListViewController<MagicType>(objects: ObjectProvider.objectsForJSON("MagicTypes"), delegate: self)
        
        title = "Choose Magic Type"
        
        switchToViewController(magicTypeListViewController)
    }
    
    private func transitionToRaceList() {
        currentCreationState = .ChooseRace
        
        let raceListViewController = ListViewController<Race>(objects: ObjectProvider.objectsForJSON("Races"), delegate: self)
        
        title = "Choose Race"
        
        switchToViewController(raceListViewController)
    }
    
    private func transitionToSkillList() {
        currentCreationState = .ChooseSkill
        
        var startingSkills = [Skill]()
        
        let human = ObjectProvider.skillForName("Human Perseverance")
        let warcry = ObjectProvider.skillForName("War Cry")
        let feint = ObjectProvider.skillForName("Feint")
        let powerattack = ObjectProvider.skillForName("Power Attack")
        
        if let human = human, warcry = warcry, feint = feint, powerattack = powerattack {
            startingSkills.appendContentsOf([human, warcry, feint, powerattack])
        }
        
        let skillListViewController = ListViewController<Skill>(objects: startingSkills, delegate: self)
        
        title = "Choose Skill"
        
        switchToViewController(skillListViewController)
    }
    
    private func transitionToGodList() {
        currentCreationState = .ChooseGod
        
        let godListViewController = ListViewController<God>(objects: God.startingGods, delegate: self)
        
        title = "Choose God"
        
        switchToViewController(godListViewController)
    }
    
    private func buildAndPersistHero() {
        heroBuilder.name = nameField.text ?? "Default Name"
        
        switch heroBuilder.magicType.status {
            case .Mundane:
                heroBuilder.increaseStatValue(1, type: .Strength)
                heroBuilder.increaseStatValue(1, type: .Constitution)
                heroBuilder.increaseStatValue(1, type: .Dexterity)
            case .Gifted:
                heroBuilder.increaseStatValue(1, type: .Faith)
        }
        
        for stat in selectedStats {
            switch heroBuilder.race.raceType {
            case .Elf: fallthrough
            case .Dwarf:
                heroBuilder.increaseStatValue(2, type: stat.statType)
            case .Human:
                heroBuilder.increaseStatValue(1, type: stat.statType)
            }
        }
        
        if let hero = heroBuilder.build() {
            HeroPersistence().persistHero(hero)
        }
    }
    
    private func switchToViewController(viewController: UIViewController) {
        setFrameForChildViewController(viewController)
        
        if let currentChildViewController = self.childViewControllers.first {
            replaceChildViewController(currentChildViewController, newViewController: viewController, animationDuration: 0.4)
        }
        else {
            addViewController(viewController)
        }
    }
    
    private func setFrameForChildViewController(viewController: UIViewController) {
        var frame = viewController.view.frame
        frame.origin.y = CGRectGetMaxY(nameField.frame) + 10
        frame.size.height -= CGRectGetMaxY(nameField.frame) + 10
        viewController.view.frame = frame
    }
}

private extension God {
    static var startingGods: [God] {
        let optionalKazu = ObjectProvider.godForName("Kazu, God of Deceit")
        let optionalDolo = ObjectProvider.godForName("Dolo, God of Agony")
        let optionalShiro = ObjectProvider.godForName("Shiro, God of Hope")
        
        guard let kazu = optionalKazu, dolo = optionalDolo, shiro = optionalShiro else { return [] }
        
        return [kazu, dolo, shiro]
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
