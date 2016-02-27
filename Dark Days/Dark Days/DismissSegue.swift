//
//  DismissSegue.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    
    override func perform() {
        sourceViewController.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
