//
//  HeroCreationViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class HeroCreationViewController: UIViewController, ListViewControllerDelegate {
    
    private enum HeroCreationState: String {
        case NameHero
        case ChooseRace
        case ChooseSkill
        case ChooseAttributes
        case ChooseMagicType
        case ChooseGod
    }
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    
    private let heroBuilder = HeroBuilder()

    private var selectedStats = [Stat]()
    private var currentCreationState: HeroCreationState = .ChooseRace
    private var heroName: String?
    private var heroGender = Gender.Male
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .backgroundColor()
        
        transitionToNameHero()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        nextButton.title = "Next"
        
        switch currentCreationState {
            case .NameHero:
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            case .ChooseRace:
                transitionToNameHero()
            case .ChooseSkill:
                transitionToRaceList()
            case .ChooseAttributes:
                if heroBuilder.race.raceType == .Human {
                    transitionToSkillList()
                } else {
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
        backButton.title = "Back"

        switch currentCreationState {
                case .NameHero:
            transitionToRaceList()
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
    
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool {
        if currentCreationState == .ChooseAttributes && heroBuilder.race.raceType == .Human {
            return selectedStats.count < 2
        }
        
        return true
    }
    
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        nextButton.enabled = true
        
        if let object = object as? Race {
            heroBuilder.race = object
        } else if let object = object as? Skill {
            heroBuilder.skill = object
        } else if let object = object as? Stat {
            selectedStats.append(object)
            
            if selectedStats.count < 2 && heroBuilder.race.raceType == .Human {
                nextButton.enabled = false
            }
        } else if let object = object as? MagicType {
            switch object.status {
                case .Mundane:
                    nextButton.title = "Done"
                case .Gifted:
                    nextButton.title = "Next"
            }

            heroBuilder.magicType = object
        } else if let object = object as? God {
            heroBuilder.god = object
        }
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) {
        if let object = object as? Stat {
            selectedStats.removeObject(object)
            nextButton.enabled = false
        }
    }
    
    private func transitionToStatList() {
        selectedStats.removeAll()
        currentCreationState = .ChooseAttributes
        
        let section = SectionList(sectionTitle: nil, objects: heroBuilder.race.startingStats)
        
        let statListViewController = ListViewController<Stat>(sections: [section], delegate: self)
        statListViewController.tableView.allowsMultipleSelection = heroBuilder.race.raceType == .Human
        statListViewController.imageContentInset = listEdgeInsets()
        title = "Choose Stat"
        
        switchToViewController(statListViewController)
    }
    
    private func transitionToMagicTypeList() {
        currentCreationState = .ChooseMagicType
        
        let section = SectionList<MagicType>(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("MagicTypes"))

        let magicTypeListViewController = ListViewController<MagicType>(sections: [section], delegate: self)
        magicTypeListViewController.imageContentInset = listEdgeInsets()
        
        title = "Choose Magic Type"
        
        switchToViewController(magicTypeListViewController)
    }
    
    private func transitionToNameHero() {
        backButton.title = "Cancel"
        currentCreationState = .NameHero
        
        guard let nameHero = UIStoryboard.nameHeroViewController() as? NameHeroViewController else { return }
        self.heroGender = .Male
        
        nameHero.nameFieldChanged = { name in
            self.heroName = name
            
            self.nextButton.enabled = self.heroName?.isEmpty == false ?? false
        }
        
        nameHero.genderSelectionChanged = { gender in
            self.heroGender = gender
        }
        
        switchToViewController(nameHero)
    }
    
    private func transitionToRaceList() {
        currentCreationState = .ChooseRace
        
        let section = SectionList<Race>(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Races"))
        let raceListViewController = ListViewController<Race>(sections: [section], delegate: self)
        
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
        
        let section = SectionList<Skill>(sectionTitle: nil, objects: startingSkills)
        let skillListViewController = ListViewController<Skill>(sections: [section], delegate: self)
        skillListViewController.imageContentInset = listEdgeInsets()
        
        title = "Choose Skill"
        
        switchToViewController(skillListViewController)
    }
    
    private func transitionToGodList() {
        currentCreationState = .ChooseGod
        
        let section = SectionList<God>(sectionTitle: nil, objects: God.startingGods)
        let godListViewController = ListViewController<God>(sections: [section], delegate: self)
        godListViewController.imageContentInset = listEdgeInsets()
        
        title = "Choose God"
        
        switchToViewController(godListViewController)
    }
    
    private func buildAndPersistHero() {
        heroBuilder.name = heroName ?? "Default Name"
        heroBuilder.gender = heroGender
        
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
    
    private func listEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    private func switchToViewController(viewController: UIViewController) {
        if let currentChildViewController = self.childViewControllers.first {
            replaceChildViewController(currentChildViewController, newViewController: viewController, animationDuration: 0.4)
        } else {
            addViewController(viewController)
        }
        
        var frame = view.frame
        frame.origin.y = 64
        frame.size.height -= 64
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
