//
//  MonsterViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class MonsterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var monster: Monster? {
        didSet {
            guard let monster = monster else { monsterView.viewModel = nil; return }
            
            monsterView.viewModel = MonsterViewModelTranslator.transform(monster)
        }
    }
    
    private var monsterView: MonsterView {
        get {
            return view as! MonsterView // swiftlint:disable:this force_cast
        }
    }
    
    override func loadView() {        
        self.view = MonsterView.instantiateViewFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monsterView.statCollectionView?.registerNibForClass(StatCell.self, reuseIdentifier: "StatCellIdentifier")
        
        monsterView.statCollectionView?.delegate = self
        monsterView.statCollectionView?.dataSource = self
        
        monsterView.backgroundColor = UIColor.backgroundColor()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StatCellIdentifier", forIndexPath: indexPath) as? StatCell
        let stat = monsterView.viewModel?.stats[indexPath.row]
        
        cell?.statTitle.text = stat?.name
        cell?.statValue.text = stat?.value
        
        return cell ?? UICollectionViewCell()
    }
}
