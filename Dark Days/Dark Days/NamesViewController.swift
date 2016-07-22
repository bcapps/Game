//
//  NamesViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class NamesViewController: UITableViewController {
    private enum Names: Int {
        case HumanMale
        case HumanFemale
        case DwarfMale
        case DwarfFemale
        case ElfMale
        case ElfFemale
        case Tavern
        case Town
        case Insanity
        
        func titleForName() -> String {
            switch self {
            case .HumanFemale:
                return "Human Female"
            case .HumanMale:
                return "Human Male"
            case .DwarfFemale:
                return "Dwarf Female"
            case .DwarfMale:
                return "Dwarf Male"
            case .ElfFemale:
                return "Elf Female"
            case .ElfMale:
                return "Elf Male"
            case .Tavern:
                return "Tavern"
            case .Town:
                return "Town"
            case .Insanity:
                return "Insanity"
            }
        }
        
        func nameForType() -> String? {
            switch self {
            case .HumanFemale:
                return NameProvider.HumanFemaleNames.randomObject() as? String
            case .HumanMale:
                return NameProvider.HumanMaleNames.randomObject() as? String
            case .DwarfFemale:
                return NameProvider.DwarfFemaleNames.randomObject() as? String
            case .DwarfMale:
                return NameProvider.DwarfMaleNames.randomObject() as? String
            case .ElfFemale:
                return NameProvider.ElfFemaleNames.randomObject() as? String
            case .ElfMale:
                return NameProvider.ElfMaleNames.randomObject() as? String
            case .Tavern:
                return NameProvider.TavernNames.randomObject() as? String
            case .Town:
                return NameProvider.TownNames.randomObject() as? String
            case .Insanity:
                return InsanityProvider.Insanities.randomObject() as? String
            }
        }
        
        static let allValues: [Names] = [.HumanMale, .HumanFemale, .DwarfMale, .DwarfFemale, .ElfMale, .ElfFemale, .Tavern, .Town, .Insanity]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.customize()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Names.allValues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
        
        let nameType = Names.allValues[indexPath.row]
        
        cell.textLabel?.attributedText = .attributedStringWithHeadingAttributes(nameType.titleForName())
        cell.backgroundColor = .backgroundColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nameType = Names.allValues[indexPath.row]
        let randomName = nameType.nameForType()
        
        let alertController = UIAlertController(title: randomName, message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive) { action in
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        alertController.addAction(cancelAction)
        
        navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
}
