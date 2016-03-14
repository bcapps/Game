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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addButtonTapped"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Toolkit"), style: .Plain, target: self, action: Selector("toolkitButtonTapped"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sections = [SectionList(sectionTitle: nil, objects: HeroPersistence().allPersistedHeroes())]
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { action, indexPath in
            let hero = self.objectForIndexPath(indexPath)
            
            if let hero = hero {
                HeroPersistence().removeHero(hero)
                self.sections = [SectionList(sectionTitle: nil, objects: HeroPersistence().allPersistedHeroes())]
            }
        }
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let heroVC = UIStoryboard.heroViewController()
        
        if let heroVC = heroVC as? HeroViewController {
            heroVC.hero = self.objectForIndexPath(indexPath)
            
            navigationController?.pushViewController(heroVC, animated: true)
        }
    }
    
    internal func addButtonTapped() {
        if let heroCreationFlow = UIStoryboard.heroCreationViewController() {
            navigationController?.presentViewController(heroCreationFlow, animated: true, completion: nil)
        }
    }
    
    internal func toolkitButtonTapped() {
        let toolkitVC = UIStoryboard.toolsViewController()
        
        if let toolkitVC = toolkitVC {
            navigationController?.presentViewController(toolkitVC, animated: true, completion: nil)
        }
    }
}
