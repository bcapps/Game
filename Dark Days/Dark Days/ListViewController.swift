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
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T)
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool
}

class ListViewController<T: ListDisplayingGeneratable>: UITableViewController {
    private var dataSource: ListDataSource<T, InfoCell>?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    var objects = [T]() {
        didSet {
            
            dataSource = ListDataSource(collection: objects, configureCell: { cell, object in
                if let object = object {
                    let displayableObject = ListDisplayable.displayableObject(object)

                    cell.infoImage = displayableObject.image
                    cell.nameText = displayableObject.title
                    cell.infoAttributedText = displayableObject.attributedString
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
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let object = dataSource?.collection[indexPath.row]
        
        
        if let object = object, listDelegate = listDelegate {
            if listDelegate.canSelectObject(self, object: object) == false {
                return nil
            }
        }
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource?.collection[indexPath.row]
        
        if let object = object {
            listDelegate?.didSelectObject(self, object: object)
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource?.collection[indexPath.row]
        
        if let object = object {
            listDelegate?.didDeselectObject(self, object: object)
        }
    }
}
