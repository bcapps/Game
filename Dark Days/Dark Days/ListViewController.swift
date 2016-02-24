//
//  ListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate {
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T)
}

class ListViewController<T: ListDisplayingGeneratable>: UITableViewController {
    private var dataSource: ListDataSource<ListDisplayable, InfoCell>?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    var objects = [T]() {
        didSet {
            
            let displayableObjects = ListDisplayable.displayableObjects(objects)
            
            dataSource = ListDataSource(collection: displayableObjects, configureCell: { cell, object in
                if let object = object {
                    cell.infoImage = object.image
                    cell.nameText = object.title
                    cell.infoAttributedText = object.attributedString
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
            //listDelegate?.didSelectObject(self, object: object)
        }
    }
}
