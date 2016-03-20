//
//  NameHeroViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 3/18/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class NameHeroViewController: UIViewController {
    
    typealias NameFieldTextChanged = (text: String) -> Void
    
    @IBOutlet weak var nameField: UITextField!
    var nameFieldChanged: NameFieldTextChanged?
    
    @IBAction func textFieldChanged(sender: UITextField) {
        nameFieldChanged?(text: sender.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.becomeFirstResponder()
    }
}
