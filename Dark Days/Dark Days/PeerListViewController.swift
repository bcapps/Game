//
//  PeerListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/10/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class PeerListViewController: UITableViewController, LCKMultipeerEventListener {
    
    let multipeer: LCKMultipeer
    var objectToSend: Any?
    var goldToSend: Int?
    
    var peers: [MCPeerID] {
        get {
            return multipeer.connectedPeers.filter({$0.displayName != "DM"})
        }
    }
    
    // MARK: NSObject
    
    required init?(coder aDecoder: NSCoder) {
        self.multipeer = LCKMultipeer()
        
        super.init(style: .Plain)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.customize()
        
        title = "Peer List"
        
        multipeer.addEventListener(self)
    }
    
    // MARK: PeerListViewController
    
    init(multipeerManager: LCKMultipeer) {
        self.multipeer = multipeerManager
        
        super.init(style: .Plain)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self)) ?? UITableViewCell()
        
        let peerID = peers[indexPath.row]
        
        cell.textLabel?.attributedText = .attributedStringWithBodyAttributes(peerID.displayName)
        cell.backgroundColor = .backgroundColor()
        cell.selectionStyle = .Gray
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let peerID = peers[indexPath.row]

        if let item = objectToSend as? Item {
            multipeer.sendItemToPeer(item, peer: peerID)
        } else if let skill = objectToSend as? Skill {
            multipeer.sendSkillToPeer(skill, peer: peerID)
        } else if let spell = objectToSend as? Spell {
            multipeer.sendSpellToPeer(spell, peer: peerID)
        } else if let gold = goldToSend {
            multipeer.sendGoldToPeer(gold, peer: peerID)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: LCKMultipeerEventListener
    
    func multipeer(multipeer: LCKMultipeer, connectedPeersStateDidChange connectedPeers: [AnyObject]) {
        tableView.reloadData()
    }
}
