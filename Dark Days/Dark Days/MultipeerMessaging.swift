//
//  MultipeerMessaging.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 3/18/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

let MessageValueKey = "value"

extension LCKMultipeer {
    
    enum MessageType: UInt {
        case item
        case spell
        case skill
        case stat
        case gold
    }
    
    func sendItemToPeer(_ item: Item, peer: MCPeerID) -> Bool {
        return sendObjectToPeer(item.name as AnyObject, type: .item, peer: peer)
    }
    
    func sendSpellToPeer(_ spell: Spell, peer: MCPeerID) -> Bool {
        return sendObjectToPeer(spell.name as AnyObject, type: .spell, peer: peer)
    }
    
    func sendSkillToPeer(_ skill: Skill, peer: MCPeerID) -> Bool {
        return sendObjectToPeer(skill.name as AnyObject, type: .skill, peer: peer)
    }
    
    func sendStatToPeer(_ stat: Stat, peer: MCPeerID) -> Bool {
        return sendObjectToPeer(stat.name as AnyObject, type: .stat, peer: peer)
    }
    
    func sendGoldToPeer(_ gold: Int, peer: MCPeerID) -> Bool {
        let gold = NSNumber(value: gold as Int)
        
        return sendObjectToPeer(gold, type: .gold, peer: peer)
    }
    
    fileprivate func sendObjectToPeer(_ object: AnyObject, type: MessageType, peer: MCPeerID) -> Bool {
        guard let data = try? JSONSerialization.data(withJSONObject: [MessageValueKey: object], options: .prettyPrinted) else {
            return false
        }
        
        let message = LCKMultipeerMessage(messageType: type.rawValue, messageData: data)
        
        return send(message, toPeer: peer)
    }
}
