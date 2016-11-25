//
//  LoreBookViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 10/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class LoreBookViewController: UITableViewController {
    
    enum LoreType: Int {
        case god
        case calendar
        case race
        
        static var numberOfLoreTypes: Int {
            return 3
        }
        
        var loreTypeDisplayString: String {
            switch self {
            case .god:
                return "Gods of Idris"
            case .calendar:
                return "Calendar"
            case .race:
                return "Races of Idris"
            }
        }
        
        var loreTypeViewController: UIViewController? {
            switch self {
            case .god:
                return ListViewController<God>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Gods"))], delegate: nil)
            case .race:
                return ListViewController<Race>(sections: [SectionList(sectionTitle: nil, objects: ObjectProvider.sortedObjectsForJSON("Races"))], delegate: nil)
            case .calendar:
                return UIStoryboard.calendarViewController()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hero Tools"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
                
        tableView.customize()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoreType.numberOfLoreTypes
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        
        if let text = LoreType(rawValue: (indexPath as NSIndexPath).row)?.loreTypeDisplayString {
            cell.textLabel?.attributedText = .attributedStringWithHeadingAttributes(text)
        }
        
        cell.selectionStyle = .gray
        cell.backgroundColor = .backgroundColor()
        
        return cell
    }
    
    // MARK: - UITableViewControllerDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let loreType = LoreType(rawValue: (indexPath as NSIndexPath).row) else { return }
        guard let viewController = loreType.loreTypeViewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
