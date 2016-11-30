//
//  ButtonStackView.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class ButtonStackView: UIStackView {
    
    func addButton(title: String, tapHandler: @escaping ((Void) -> Void)) {
        let button = ClosureButton(type: .system)
        button.setTitle(title, for: .normal)
        button.closure = tapHandler
        
        addArrangedSubview(button)
    }
}

private class ClosureButton: UIButton {
    var closure: ((Void) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: .ButtonTouchUpInside, for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchUpInside(sender: UIButton) {
        closure?()
    }
}

private extension Selector {
    static let ButtonTouchUpInside = #selector(ClosureButton.touchUpInside(sender:))
}
