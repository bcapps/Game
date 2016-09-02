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
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier(identifier)
        BITHockeyManager.sharedHockeyManager().crashManager.crashManagerStatus = .AutoSend
        BITHockeyManager.sharedHockeyManager().startManager()
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
    }
}
