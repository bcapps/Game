//
//  MonsterView.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class MonsterView: UIScrollView {
    
    struct ViewModel {
        let name: String
        let type: String
        let health: String
        let speed: String
        //let stats: []
        let damageImmunities: [String]
        let conditionImmunites: [String]
        let languages: [String]
        let abilities: [String]
        let actions: [String]
    }
    
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var typeLabel: UILabel?
    @IBOutlet private weak var healthLabel: UILabel?
    @IBOutlet private weak var speedLabel: UILabel?
    @IBOutlet private weak var statCollectionView: UICollectionView?
    @IBOutlet private weak var damageImmunitiesLabel: UILabel?
    @IBOutlet private weak var conditionImmunitesLabel: UILabel?
    @IBOutlet private weak var languagesLabel: UILabel?
    @IBOutlet private weak var abilitiesStackView: UIStackView?
    @IBOutlet private weak var actionsStackView: UIStackView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel?.font = UIFont.petiteCapsFont(ofSize: 28)
        typeLabel?.font = UIFont.notoSansItalic(ofSize: 14)
    }

    var viewModel: ViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            
            nameLabel?.attributedText = nameAttributedString(forName: vm.name)
            healthLabel?.attributedText = attributedText("Health ", descriptiveText: vm.health)
            speedLabel?.attributedText = attributedText("Speed ", descriptiveText: vm.speed)
            
            typeLabel?.attributedText = attributedText("", descriptiveText: vm.type)
            damageImmunitiesLabel?.attributedText = attributedText("Damage Immunities ", descriptiveText: vm.damageImmunities)
            conditionImmunitesLabel?.attributedText = attributedText("Condition Immunities ", descriptiveText: vm.conditionImmunites)
            languagesLabel?.attributedText = attributedText("Languages ", descriptiveText: vm.languages)
        }
    }
    
    private func attributedText(heading: String, descriptiveText: String) -> NSAttributedString {
        return attributedText(heading, descriptiveText: [descriptiveText])
    }
    
    private func attributedText(heading: String, descriptiveText: [String]) -> NSAttributedString {
        let subHeading = NSAttributedString(string: heading, attributes: subHeadingAttributes())
        let descriptiveText = NSAttributedString(string: descriptiveText.joinWithSeparator(", "), attributes: descriptiveTextAttributes())
        
        return NSAttributedString.joinAttributedStrings(subHeading, attrString2: descriptiveText)
    }
    
    private func subHeadingAttributes() -> [String: AnyObject] {
        return [NSFontAttributeName: UIFont.notoSansBold(ofSize: 15), NSForegroundColorAttributeName: UIColor.headerTextColor()]
    }
    
    private func descriptiveTextAttributes() -> [String: AnyObject] {
        return [NSFontAttributeName: UIFont.notoSansRegular(ofSize: 15), NSForegroundColorAttributeName: UIColor.bodyTextColor()]
    }
    
    private func nameAttributedString(forName name: String) -> NSAttributedString {
        let attributes = [NSFontAttributeName: UIFont.petiteCapsFont(ofSize: 28), NSForegroundColorAttributeName: UIColor.headerTextColor()]
        
        return NSAttributedString(string: name, attributes: attributes)
    }
}

private extension NSAttributedString {
    
    static func joinAttributedStrings(attrString1: NSAttributedString, attrString2: NSAttributedString) -> NSAttributedString {
        let joined = NSMutableAttributedString()
        joined.appendAttributedString(attrString1)
        joined.appendAttributedString(attrString2)
        
        return joined
    }
}
