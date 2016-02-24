//
//  ListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate {
    func didSelectObject<T: Displayable>(listViewController: ListViewController<T>, object: T)
}

class ListViewController<T: Displayable>: UITableViewController {
    private var dataSource: ListDataSource<T, InfoCell>?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    var objects = [T]() {
        didSet {
            dataSource = ListDataSource(collection: objects, configureCell: { cell, object in
                if let object = object {
                    cell.infoImage = object.image
                    cell.nameText = object.title
                    cell.infoAttributedText = object.attributedStringForDisplayable()
                }
            })
            
            tableView.dataSource = dataSource
            tableView.reloadData()
        }
    }
    
    var listDelegate: ListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.customize()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource?.collection[indexPath.row]
        
        if let object = object {
            listDelegate?.didSelectObject(self, object: object)
        }
    }
}

extension Displayable {
    func attributedStringForDisplayable() -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        if let information = information {
            let info = NSAttributedString.attributedStringWithBodyAttributes(information)
            
            attributedString.appendAttributedString(info)
        }
        
        if let additionalInfo = additionalInfo {
            attributedString.appendAttributedString(NSAttributedString(string: "\n\n"))
            
            if let title = additionalInfoTitle {
                let attributedTitle = NSAttributedString.attributedStringWithHeadingAttributes(title)
                attributedString.appendAttributedString(attributedTitle)
                attributedString.appendAttributedString(NSAttributedString(string: "\n"))
            }
            
            let additionalInfo = NSAttributedString.attributedStringWithBodyAttributes(additionalInfo)
            
            attributedString.appendAttributedString(additionalInfo)
        }
        
        if let subtext = subtext {
            attributedString.appendAttributedString(NSAttributedString(string: "\n"))
            
            let subtext = NSAttributedString.attributedStringWithSmallAttributes(subtext)
            attributedString.appendAttributedString(subtext)
        }
        
        return attributedString
    }
}
