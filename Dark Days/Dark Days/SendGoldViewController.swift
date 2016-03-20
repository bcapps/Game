//
//  SendGoldViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 3/18/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class SendGoldViewController: UIViewController {
    
    @IBOutlet weak var sendGoldButton: UIBarButtonItem!
    @IBOutlet weak var goldTextField: UITextField!
    
    typealias SendGoldButtonTappedBlock = (gold: Int) -> Void
    
    var sendGoldTapped: SendGoldButtonTappedBlock?
    
    @IBAction func textFieldDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        sendGoldButton.enabled = !text.isEmpty
    }
    
    @IBAction func sendGoldButtonTapped(sender: UIBarButtonItem) {
        let gold = Int(goldTextField.text ?? "0") ?? 0
        
        sendGoldTapped?(gold: gold)
    }
}
