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
        case Item
        case Gold
    }
    
    func sendItemToPeer(item: Item, peer: MCPeerID) -> Bool {
        return sendObjectToPeer(item.name, type: .Item, peer: peer)
    }
    
    func sendGoldToPeer(gold: Int, peer: MCPeerID) -> Bool {
        let gold = NSNumber(integer: gold)
        
        return sendObjectToPeer(gold, type: .Gold, peer: peer)
    }
    
    private func sendObjectToPeer(object: AnyObject, type: MessageType, peer: MCPeerID) -> Bool {
        let dictionary = [MessageValueKey: object]
        
        guard let data = try? NSJSONSerialization.dataWithJSONObject(dictionary, options: .PrettyPrinted) else {
            return false
        }
        
        let message = LCKMultipeerMessage(messageType: type.rawValue, messageData: data)
        
        return sendMessage(message, toPeer: peer)
    }
}
