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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return peers.count
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self)) ?? UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let peerID = peers[indexPath.row]
            
            cell.textLabel?.attributedText = .attributedStringWithBodyAttributes(peerID.displayName)
        default:
            print("No handling")
        }
        
        cell.backgroundColor = .backgroundColor()
        cell.selectionStyle = .Gray
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let peerID = peers[indexPath.row]
            
            if let item = objectToSend as? Item {
                multipeer.sendItemToPeer(item, peer: peerID)
            } else if let skill = objectToSend as? Skill {
                multipeer.sendSkillToPeer(skill, peer: peerID)
            } else if let spell = objectToSend as? Spell {
                multipeer.sendSpellToPeer(spell, peer: peerID)
            } else if let stat = objectToSend as? Stat {
                multipeer.sendStatToPeer(stat, peer: peerID)
            } else if let gold = goldToSend {
                multipeer.sendGoldToPeer(gold, peer: peerID)
            }
        default:
            print("No handling")
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return peers.isNotEmpty ? "Multipeer Heroes" : nil
        default: return nil
        }
    }
    
    // MARK: LCKMultipeerEventListener
    
    func multipeer(multipeer: LCKMultipeer, connectedPeersStateDidChange connectedPeers: [AnyObject]) {
        tableView.reloadData()
    }
}
