//
//  CrashManager.swift
//  Dark Days
//
//  Created by Andrew Harrison on 9/2/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import HockeySDK

final class CrashManager {
    
    init(identifier: String) {
        BITHockeyManager.shared().configure(withIdentifier: identifier)
        BITHockeyManager.shared().crashManager.crashManagerStatus = .autoSend
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }
}
