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
        
        super.init(style: .plain)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.customize()
        
        title = "Peer List"
        
        multipeer.add(self)
    }
    
    // MARK: PeerListViewController
    
    init(multipeerManager: LCKMultipeer) {
        self.multipeer = multipeerManager
        
        super.init(style: .plain)
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return peers.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self)) ?? UITableViewCell()
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            let peerID = peers[(indexPath as NSIndexPath).row]
            
            cell.textLabel?.attributedText = .attributedStringWithBodyAttributes(peerID.displayName)
        default:
            print("No handling")
        }
        
        cell.backgroundColor = .backgroundColor()
        cell.selectionStyle = .gray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            let peerID = peers[(indexPath as NSIndexPath).row]
            
            if let item = objectToSend as? Item {
                _ = multipeer.sendItemToPeer(item, peer: peerID)
            } else if let skill = objectToSend as? Skill {
                _ = multipeer.sendSkillToPeer(skill, peer: peerID)
            } else if let spell = objectToSend as? Spell {
                _ = multipeer.sendSpellToPeer(spell, peer: peerID)
            } else if let stat = objectToSend as? Stat {
                _ = multipeer.sendStatToPeer(stat, peer: peerID)
            } else if let gold = goldToSend {
                _ = multipeer.sendGoldToPeer(gold, peer: peerID)
            }
        default:
            print("No handling")
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return peers.isNotEmpty ? "Multipeer Heroes" : nil
        default: return nil
        }
    }
    
    // MARK: LCKMultipeerEventListener
    
    private func multipeer(_ multipeer: LCKMultipeer, connectedPeersStateDidChange connectedPeers: [AnyObject]) {
        tableView.reloadData()
    }
}
