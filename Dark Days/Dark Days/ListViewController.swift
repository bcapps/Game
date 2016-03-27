//
//  ListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate: class {
    func didSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T)
    func didDeselectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T)
    func canSelectObject<T: ListDisplayingGeneratable>(listViewController: ListViewController<T>, object: T) -> Bool
}

// custom initializer that takes objects.

class ListViewController<T: ListDisplayingGeneratable>: UITableViewController {    
    init(sections: [SectionList<T>], delegate: ListViewControllerDelegate?) {
        self.sections = sections
        self.listDelegate = delegate
        
        super.init(style: .Plain)
    }
    
    var sections = [SectionList<T>]() {
        didSet {
            reloadDataSource()
        }
    }
    
    var imageContentInset: UIEdgeInsets?
    
    private weak var listDelegate: ListViewControllerDelegate?
    private var dataSource: ListDataSource<T, InfoCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .Interactive

        reloadDataSource()
        
        tableView.customize()
    }
    
    func objectForIndexPath(indexPath: NSIndexPath) -> T? {
        return self.dataSource?.objectForIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let object = dataSource?.objectForIndexPath(indexPath)
        
        if let object = object, listDelegate = listDelegate {
            if listDelegate.canSelectObject(self, object: object) == false {
                return nil
            }
        }
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource?.objectForIndexPath(indexPath)
        
        if let object = object {
            listDelegate?.didSelectObject(self, object: object)
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource?.objectForIndexPath(indexPath)
        
        if let object = object {
            listDelegate?.didDeselectObject(self, object: object)
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let text = self.dataSource?.sectionForIndex(section).sectionTitle else { return nil }
        
        return ListHeaderView.headerViewWithText(text, width: tableView.frame.size.width)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {        
        let sectionTitle = sections[section].sectionTitle ?? ""
        
        return sectionTitle.isNotEmpty ? 44 : 0
    }
    
    private func reloadDataSource() {
        dataSource = ListDataSource(sections: sections, configureCell: { cell, object in
            let displayableObject = ListDisplayable.displayableObject(object)
            
            cell.infoImage = displayableObject.image
            cell.nameText = displayableObject.title
            cell.infoAttributedText = displayableObject.attributedString
            cell.contentInset = self.imageContentInset ?? UIEdgeInsets()
        })
                
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

private class ListHeaderView: UITableViewHeaderFooterView {
    static func headerViewWithText(text: String, width: CGFloat) -> UITableViewHeaderFooterView {
        let containingView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        containingView.contentView.backgroundColor = .backgroundColor()
        
        let labelFrame = CGRect(x: 10, y: 0, width: CGRectGetWidth(containingView.frame), height: CGRectGetHeight(containingView.frame))
        let label = UILabel(frame: labelFrame)
        
        label.attributedText = NSAttributedString.attributedStringWithHeadingAttributes(text)
        label.textAlignment = .Center
        
        let separatorFrame = CGRect(x: 0, y: CGRectGetHeight(containingView.frame) - 1, width: CGRectGetWidth(containingView.frame), height: 1)
        let separatorView = UIView(frame: separatorFrame)
        separatorView.backgroundColor = .grayColor()
        
        containingView.addSubview(label)
        containingView.addSubview(separatorView)
        
        return containingView
    }
}
