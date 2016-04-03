//
//  CharacterListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroListViewController: ListViewController<Hero> {
    
    override init(sections: [SectionList<Hero>], delegate: ListViewControllerDelegate?) {
        super.init(sections: sections, delegate: delegate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Heroes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: .addButtonTapped)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Toolkit"), style: .Plain, target: self, action: .toolkitButtonTapped)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sections = [SectionList(sectionTitle: nil, objects: HeroPersistence().allPersistedHeroes().sortedElementsByName)]
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { action, indexPath in
            guard let hero = self.objectForIndexPath(indexPath) else { return }
            
            HeroPersistence().removeHero(hero)
            self.sections = [SectionList(sectionTitle: nil, objects: HeroPersistence().allPersistedHeroes().sortedElementsByName)]
        }
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let heroVC = UIStoryboard.heroViewController() else { return }
        heroVC.hero = self.objectForIndexPath(indexPath)
            
        navigationController?.pushViewController(heroVC, animated: true)
    }
    
    func addButtonTapped() {
        guard let heroCreationFlow = UIStoryboard.heroCreationViewController() else { return }
        navigationController?.presentViewController(heroCreationFlow, animated: true, completion: nil)
    }
    
    func toolkitButtonTapped() {
        guard let toolkitVC = UIStoryboard.toolsViewController() else { return }
        navigationController?.presentViewController(toolkitVC, animated: true, completion: nil)
    }
}

private extension Selector {
    static let addButtonTapped = #selector(HeroListViewController.addButtonTapped)
    static let toolkitButtonTapped = #selector(HeroListViewController.toolkitButtonTapped)
}
