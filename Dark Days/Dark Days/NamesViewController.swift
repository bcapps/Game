//
//  NamesViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class NamesViewController: UITableViewController {
    fileprivate enum Names: Int {
        case humanMale
        case humanFemale
        case dwarfMale
        case dwarfFemale
        case elfMale
        case elfFemale
        case tavern
        case town
        case insanity
        
        func titleForName() -> String {
            switch self {
            case .humanFemale:
                return "Human Female"
            case .humanMale:
                return "Human Male"
            case .dwarfFemale:
                return "Dwarf Female"
            case .dwarfMale:
                return "Dwarf Male"
            case .elfFemale:
                return "Elf Female"
            case .elfMale:
                return "Elf Male"
            case .tavern:
                return "Tavern"
            case .town:
                return "Town"
            case .insanity:
                return "Insanity"
            }
        }
        
        func nameForType() -> String? {
            switch self {
            case .humanFemale:
                return NameProvider.HumanFemaleNames.randomObject() as? String
            case .humanMale:
                return NameProvider.HumanMaleNames.randomObject() as? String
            case .dwarfFemale:
                return NameProvider.DwarfFemaleNames.randomObject() as? String
            case .dwarfMale:
                return NameProvider.DwarfMaleNames.randomObject() as? String
            case .elfFemale:
                return NameProvider.ElfFemaleNames.randomObject() as? String
            case .elfMale:
                return NameProvider.ElfMaleNames.randomObject() as? String
            case .tavern:
                return NameProvider.TavernNames.randomObject() as? String
            case .town:
                return NameProvider.TownNames.randomObject() as? String
            case .insanity:
                return InsanityProvider.Insanities.randomObject() as? String
            }
        }
        
        static let allValues: [Names] = [.humanMale, .humanFemale, .dwarfMale, .dwarfFemale, .elfMale, .elfFemale, .tavern, .town, .insanity]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.customize()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Names.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let nameType = Names.allValues[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.attributedText = .attributedStringWithHeadingAttributes(nameType.titleForName())
        cell.backgroundColor = .backgroundColor()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameType = Names.allValues[(indexPath as NSIndexPath).row]
        let randomName = nameType.nameForType()
        
        let alertController = UIAlertController(title: randomName, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        alertController.addAction(cancelAction)
        
        navigationController?.present(alertController, animated: true, completion: nil)
    }
}
