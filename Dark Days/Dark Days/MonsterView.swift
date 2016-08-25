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
        
        struct Attack {
            let name: String
            let damage: String
        }
        
        struct Trait {
            let name: String
            let description: String
        }
        
        struct Stat {
            let name: String
            let value: String
        }

        let name: String
        let type: String
        let health: String
        let speed: String
        let damageImmunities: [String]
        let conditionImmunites: [String]
        let languages: [String]
        let stats: [Stat]
        let attacks: [Attack]
        let traits: [Trait]
    }
    
    @IBOutlet weak var statCollectionView: UICollectionView?
    
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var typeLabel: UILabel?
    @IBOutlet private weak var healthLabel: UILabel?
    @IBOutlet private weak var speedLabel: UILabel?
    @IBOutlet private weak var damageImmunitiesLabel: UILabel?
    @IBOutlet private weak var conditionImmunitesLabel: UILabel?
    @IBOutlet private weak var languagesLabel: UILabel?
    @IBOutlet private weak var traitsStackView: UIStackView?
    @IBOutlet private weak var attacksStackView: UIStackView?
    @IBOutlet private weak var attackTitleLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        statCollectionView?.allowsSelection = false
        attackTitleLabel?.attributedText = attackTitleAttributedString(forTitle: "Attacks")
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
            
            attacksStackView?.removeAllSubviews()
            attacksStackView?.addArrangedSubviews(labels(forAttacks: vm.attacks))
            
            traitsStackView?.removeAllSubviews()
            traitsStackView?.addArrangedSubviews(labels(forTraits: vm.traits))
        }
    }
    
    var attackTapped: (ViewModel.Attack -> Void)?
    
    private func attributedText(heading: String, descriptiveText: String) -> NSAttributedString {
        return attributedText(heading, descriptiveText: [descriptiveText])
    }
    
    private func attributedText(heading: String, descriptiveText: [String]) -> NSAttributedString {
        let subHeading = NSAttributedString(string: heading, attributes: subHeadingAttributes())
        let descriptiveText = NSAttributedString(string: descriptiveText.joinWithSeparator(", "), attributes: descriptiveTextAttributes())
        
        return NSAttributedString.joinAttributedStrings(subHeading, attrString2: descriptiveText)
    }
    
    private func subHeadingAttributes() -> [String: AnyObject] {
        return [NSFontAttributeName: UIFont.notoSansBold(ofSize: 16), NSForegroundColorAttributeName: UIColor.headerTextColor()]
    }
    
    private func descriptiveTextAttributes() -> [String: AnyObject] {
        return [NSFontAttributeName: UIFont.notoSansRegular(ofSize: 14), NSForegroundColorAttributeName: UIColor.bodyTextColor()]
    }
    
    private func nameAttributedString(forName name: String) -> NSAttributedString {
        let attributes = [NSFontAttributeName: UIFont.petiteCapsFont(ofSize: 28), NSForegroundColorAttributeName: UIColor.headerTextColor()]
        
        return NSAttributedString(string: name, attributes: attributes)
    }
    
    private func attackTitleAttributedString(forTitle title: String) -> NSAttributedString {
        let attributes = [NSFontAttributeName: UIFont.petiteCapsFont(ofSize: 23), NSForegroundColorAttributeName: UIColor.headerTextColor()]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    private func labels(forAttacks attacks: [ViewModel.Attack]) -> [UIButton] {
        return attacks.flatMap {
            let button = AttackButton(type: .System)
            button.attack = $0
            button.setAttributedTitle(attributedText($0.name + " ", descriptiveText: $0.damage), forState: .Normal)
            button.addTarget(self, action: .ActionButtonSelector, forControlEvents: .TouchUpInside)
            return button
        }
    }
    
    private func labels(forTraits traits: [ViewModel.Trait]) -> [UILabel] {
        return traits.flatMap {
            let label = UILabel()
            label.attributedText = attributedText($0.name + " ", descriptiveText: $0.description)
            label.numberOfLines = 0
            
            return label
        }
    }
    
    @objc private func attackButtonTapped(button: AttackButton) {
        guard let attack = button.attack else { return }
        attackTapped?(attack)
    }
}

private class AttackButton: UIButton {
    var attack: MonsterView.ViewModel.Attack?
}

private extension Selector {
    static let ActionButtonSelector = #selector(MonsterView.attackButtonTapped(_:))
}

private extension NSAttributedString {
    
    static func joinAttributedStrings(attrString1: NSAttributedString, attrString2: NSAttributedString) -> NSAttributedString {
        let joined = NSMutableAttributedString()
        joined.appendAttributedString(attrString1)
        joined.appendAttributedString(attrString2)
        
        return joined
    }
}

private extension UIStackView {
    
    func addArrangedSubviews(subviews: [UIView]) {
        for view in subviews {
            addArrangedSubview(view)
        }
    }
    
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
