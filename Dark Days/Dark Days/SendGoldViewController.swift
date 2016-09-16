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
    
    typealias SendGoldButtonTappedBlock = (_ gold: Int) -> Void
    
    var sendGoldTapped: SendGoldButtonTappedBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Get Gold"
        goldTextField.becomeFirstResponder()
        goldTextField.attributedPlaceholder = .attributedStringWithSmallAttributes("0")
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sendGoldButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func sendGoldButtonTapped(_ sender: UIBarButtonItem) {
        let gold = Int(goldTextField.text ?? "0") ?? 0
        
        sendGoldTapped?(gold)
    }
}
