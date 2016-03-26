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
    typealias GenderSelectionChanged = (newGender: Gender) -> Void
    
    @IBOutlet weak var nameField: UITextField!
    
    var nameFieldChanged: NameFieldTextChanged?
    var genderSelectionChanged: GenderSelectionChanged?
    
    @IBAction func textFieldChanged(sender: UITextField) {
        nameFieldChanged?(text: sender.text ?? "")
    }
    
    @IBAction func genderSelectorChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            genderSelectionChanged?(newGender: .Female)
        case 0: fallthrough
        default:
            genderSelectionChanged?(newGender: .Male)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.becomeFirstResponder()
    }
}
