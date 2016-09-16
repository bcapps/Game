//
//  HeroCreationViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class HeroCreationViewController: UIViewController, ListViewControllerDelegate {
    
    fileprivate enum HeroCreationState: String {
        case NameHero
        case ChooseRace
        case ChooseSkill
        case ChooseAttributes
        case ChooseMagicType
        case ChooseGod
    }
    
    var nextButton: UIBarButtonItem! {
        return navigationItem.rightBarButtonItem
    }
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    
    fileprivate let heroBuilder = HeroBuilder()

    fileprivate var selectedStats = [Stat]()
    fileprivate var currentCreationState: HeroCreationState = .ChooseRace
    fileprivate var heroName: String?
    fileprivate var heroGender = Gender.Male
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .backgroundColor()
        
        transitionToNameHero()
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        nextButton.title = "Next"
        
        switch currentCreationState {
            case .NameHero:
                presentingViewController?.dismiss(animated: true, completion: nil)
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
        
        nextButton.isEnabled = false
    }
    
    @IBAction func nextButtonTapped(_ sender: AnyObject) {
        nextButton.isEnabled = false
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
                        guard let hero = buildAndPersistHero() else { return }
                        dismissAfterCreation(hero)
                    case .Gifted:
                        nextButton.title = "Done"
                        transitionToGodList()
                }
            case .ChooseGod:
                guard let hero = buildAndPersistHero() else { return }
                dismissAfterCreation(hero)
        }
    }
    
    func canSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) -> Bool {
        if currentCreationState == .ChooseAttributes && heroBuilder.race.raceType == .Human {
            return selectedStats.count < 2
        }
        
        return true
    }
    
    func didSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) {
        nextButton.isEnabled = true
        
        if let object = object as? Race {
            heroBuilder.race = object
        } else if let object = object as? Skill {
            heroBuilder.skill = object
        } else if let object = object as? Stat {
            selectedStats.append(object)
            
            switch heroBuilder.race.raceType {
            case .Human:
                let remainingStats = 2 - selectedStats.count
                title = "Choose Stats (\(remainingStats))"
            default: break
            }
            
            if selectedStats.count < 2 && heroBuilder.race.raceType == .Human {
                nextButton.isEnabled = false
            } else {
                title = "Stats Chosen"
            }
        } else if let object = object as? MagicType {
            let title: String
            
            switch object.status {
                case .Mundane:
                    title = "Done"
                case .Gifted:
                    title = "Next"
            }
            
            let barButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: .NextButtonTappedSelector)
            navigationItem.setRightBarButton(barButtonItem, animated: true)

            heroBuilder.magicType = object
        } else if let object = object as? God {
            heroBuilder.god = object
        }
    }
    
    func didDeselectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) {
        if let object = object as? Stat {
            selectedStats.removeObject(object)
            nextButton.isEnabled = false
            
            switch heroBuilder.race.raceType {
            case .Human:
                let remainingStats = 2 - selectedStats.count
                title = "Choose Stats (\(remainingStats))"
            default: break
            }
        }
    }
    
    func removeObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) { }
    
    fileprivate func transitionToStatList() {
        selectedStats.removeAll()
        currentCreationState = .ChooseAttributes
        
        let section = SectionList(sectionTitle: nil, objects: heroBuilder.race.startingStats)
        
        let statListViewController = ListViewController<Stat>(sections: [section], delegate: self)
        statListViewController.tableView.allowsMultipleSelection = heroBuilder.race.raceType == .Human
        statListViewController.imageContentInset = listEdgeInsets()
        
        switch heroBuilder.race.raceType {
        case .Human: title = "Choose Stats (2)"
        default: title = "Choose Stat"
        }
        
        switchToViewController(statListViewController)
    }
    
    fileprivate func transitionToMagicTypeList() {
        currentCreationState = .ChooseMagicType
        
        let section = SectionList<MagicType>(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("MagicTypes"))

        let magicTypeListViewController = ListViewController<MagicType>(sections: [section], delegate: self)
        magicTypeListViewController.imageContentInset = listEdgeInsets()
        
        title = "Choose Magic Type"
        
        switchToViewController(magicTypeListViewController)
    }
    
    fileprivate func transitionToNameHero() {
        backButton.title = "Cancel"
        currentCreationState = .NameHero
        
        guard let nameHero = UIStoryboard.nameHeroViewController() else { return }
        self.heroGender = .Male
        
        nameHero.nameFieldChanged = { name in
            self.heroName = name
            
            self.nextButton.isEnabled = self.heroName?.isNotEmpty ?? false
        }
        
        nameHero.genderSelectionChanged = { gender in
            self.heroGender = gender
        }
        
        title = "Name Hero"
        
        switchToViewController(nameHero)
    }
    
    fileprivate func transitionToRaceList() {
        currentCreationState = .ChooseRace
        
        let section = SectionList<Race>(sectionTitle: nil, objects: ObjectProvider.objectsForJSON("Races"))
        let raceListViewController = ListViewController<Race>(sections: [section], delegate: self)
        
        title = "Choose Race"
        
        switchToViewController(raceListViewController)
    }
    
    fileprivate func transitionToSkillList() {
        currentCreationState = .ChooseSkill
        
        var startingSkills = [Skill]()
        
        let human = ObjectProvider.skillForName("Human Perseverance")
        let warcry = ObjectProvider.skillForName("War Cry")
        let feint = ObjectProvider.skillForName("Feint")
        let powerattack = ObjectProvider.skillForName("Power Attack")
        
        if let human = human, let warcry = warcry, let feint = feint, let powerattack = powerattack {
            startingSkills.append(contentsOf: [human, warcry, feint, powerattack])
        }
        
        let section = SectionList<Skill>(sectionTitle: nil, objects: startingSkills)
        let skillListViewController = ListViewController<Skill>(sections: [section], delegate: self)
        skillListViewController.imageContentInset = listEdgeInsets()
        
        title = "Choose Skill"
        
        switchToViewController(skillListViewController)
    }
    
    fileprivate func transitionToGodList() {
        currentCreationState = .ChooseGod
        
        let section = SectionList<God>(sectionTitle: nil, objects: God.startingGods)
        let godListViewController = ListViewController<God>(sections: [section], delegate: self)
        godListViewController.imageContentInset = listEdgeInsets()
        
        title = "Choose God"
        
        switchToViewController(godListViewController)
    }
    
    fileprivate func buildAndPersistHero() -> Hero? {
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
        
        guard let hero = heroBuilder.build() else { return nil }
        
        HeroPersistence().persistHero(hero)
        
        return hero
    }
    
    fileprivate func dismissAfterCreation(_ createdHero: Hero) {
        guard let heroVC = UIStoryboard.heroViewController() else { return }
        heroVC.hero = createdHero
        
        guard let navController = presentingViewController as? UINavigationController else { return }
        
        navController.pushViewController(heroVC, animated: false)
        navController.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func listEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    fileprivate func switchToViewController(_ viewController: UIViewController) {
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
        guard let kazu = ObjectProvider.godForName("Kazu, God of Deceit") else { return [] }
        guard let dolo = ObjectProvider.godForName("Dolo, God of Agony") else { return [] }
        guard let shiro = ObjectProvider.godForName("Shiro, God of Hope") else { return [] }
        
        return [kazu, dolo, shiro]
    }
}

private extension Race {
    var startingStats: [Stat] {
        switch raceType {
        case .Elf:
            guard let dexterity = ObjectProvider.statForName("Dexterity") else { return [] }
            guard let intelligence = ObjectProvider.statForName("Intelligence") else { return [] }
            
            return [dexterity, intelligence]
        case .Dwarf:
            guard let constitution = ObjectProvider.statForName("Constitution") else { return [] }
            guard let faith = ObjectProvider.statForName("Faith") else { return [] }
            
            return [constitution, faith]
        case .Human:
            return ObjectProvider.objectsForJSON("Stats")
        }
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

private extension Selector {
    static let NextButtonTappedSelector = #selector(HeroCreationViewController.nextButtonTapped(_:))
}
