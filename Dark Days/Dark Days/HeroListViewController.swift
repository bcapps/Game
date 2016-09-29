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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Heroes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addButtonTapped)
        
        #if DEBUG
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Toolkit"), style: .plain, target: self, action: .toolkitButtonTapped)
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshHeroList()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            guard let hero = self.objectForIndexPath(indexPath) else { return }
            
            HeroPersistence().removeHero(hero)
            self.refreshHeroList()
        }
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let heroVC = UIStoryboard.heroViewController() else { return }
        heroVC.hero = self.objectForIndexPath(indexPath)
            
        navigationController?.pushViewController(heroVC, animated: true)
    }
    
    func addButtonTapped() {
        guard let heroCreationFlow = UIStoryboard.heroCreationViewController() else { return }
        navigationController?.present(heroCreationFlow, animated: true, completion: nil)
    }
    
    func toolkitButtonTapped() {
        guard let toolkitVC = UIStoryboard.toolsViewController() else { return }
        navigationController?.present(toolkitVC, animated: true, completion: nil)
    }
    
    func refreshHeroList() {
        self.sections = [SectionList(sectionTitle: nil, objects: HeroPersistence().allPersistedHeroes().sortedElementsByName)]
    }
}

private extension Selector {
    static let addButtonTapped = #selector(HeroListViewController.addButtonTapped)
    static let toolkitButtonTapped = #selector(HeroListViewController.toolkitButtonTapped)
}
