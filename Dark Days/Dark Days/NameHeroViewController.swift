//
//  NameHeroViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 3/18/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class NameHeroViewController: UIViewController {
    
    typealias NameFieldTextChanged = (_ text: String) -> Void
    typealias GenderSelectionChanged = (_ newGender: Gender) -> Void
    
    @IBOutlet weak var nameField: UITextField!
    
    var nameFieldChanged: NameFieldTextChanged?
    var genderSelectionChanged: GenderSelectionChanged?
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        nameFieldChanged?(sender.text ?? "")
    }
    
    @IBAction func genderSelectorChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            genderSelectionChanged?(.Female)
        case 0: fallthrough
        default:
            genderSelectionChanged?(.Male)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameField.attributedPlaceholder = .attributedStringWithSmallAttributes("Name Hero")
        nameField.becomeFirstResponder()
    }
}
