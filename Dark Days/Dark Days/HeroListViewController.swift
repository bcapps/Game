//
//  CharacterListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroListViewController: ListViewController<Hero> {
    
    override init(objects: [Hero], delegate: ListViewControllerDelegate?) {
        super.init(objects: objects, delegate: delegate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Heroes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addButtonTapped"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        objects = HeroPersistence().allPersistedHeroes()
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { action, indexPath in
            let hero = self.objects[indexPath.row]
            
            HeroPersistence().removeHero(hero)
            self.objects = HeroPersistence().allPersistedHeroes()
        }
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let heroVC = UIStoryboard.heroViewController()
        
        if let heroVC = heroVC as? HeroViewController {
            heroVC.hero = self.objects[indexPath.row]
            
            navigationController?.pushViewController(heroVC, animated: true)
        }
    }
    
    
    internal func addButtonTapped() {
        if let heroCreationFlow = UIStoryboard.heroCreationViewController() {
            navigationController?.presentViewController(heroCreationFlow, animated: true, completion: nil)
        }
    }
}
