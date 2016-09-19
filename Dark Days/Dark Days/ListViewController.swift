//
//  ListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate: class {
    func didSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T)
    func didDeselectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T)
    func canSelectObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T) -> Bool
    func removeObject<T: ListDisplayingGeneratable>(_ listViewController: ListViewController<T>, object: T)
}

class ListViewController<T: ListDisplayingGeneratable>: UITableViewController {    
    init(sections: [SectionList<T>], delegate: ListViewControllerDelegate?) {
        self.sections = sections
        self.listDelegate = delegate
        
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sections = [SectionList<T>]() {
        didSet {
            reloadDataSource()
        }
    }
    
    var imageContentInset: UIEdgeInsets?
    
    typealias DidSelectObject = (_ object: T) -> ()
    
    fileprivate weak var listDelegate: ListViewControllerDelegate?
    fileprivate var dataSource: ListDataSource<T, InfoCell>?
    
    var didSelectClosure: DidSelectObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .cell)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .interactive
        
        reloadDataSource()
        
        tableView.customize()
    }
    
    func objectForIndexPath(_ indexPath: IndexPath) -> T? {
        return self.dataSource?.objectForIndexPath(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let object = dataSource?.objectForIndexPath(indexPath) else { return nil }
        
        if listDelegate?.canSelectObject(self, object: object) == false {
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let object = dataSource?.objectForIndexPath(indexPath) else { return }
        
        didSelectClosure?(object)
        
        listDelegate?.didSelectObject(self, object: object)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let object = dataSource?.objectForIndexPath(indexPath) else { return }
        
        listDelegate?.didDeselectObject(self, object: object)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Remove") { action, indexPath in
            guard let object = self.dataSource?.objectForIndexPath(indexPath) else { return }
            
            self.listDelegate?.removeObject(self, object: object)
            
            self.tableView.reloadData()
        }
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let text = self.dataSource?.sectionForIndex(section).sectionTitle else { return nil }
        
        return ListHeaderView.headerViewWithText(text, width: tableView.frame.size.width)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {        
        let sectionTitle = sections[section].sectionTitle ?? ""
        
        return sectionTitle.isNotEmpty ? 44 : 0
    }
    
    fileprivate func reloadDataSource() {
        dataSource = ListDataSource(sections: sections, configureCell: { cell, object in
            let displayableObject = ListDisplayable.displayableObject(object)
            
            cell.infoImage = displayableObject.image
            cell.accessoryImage = displayableObject.accessoryImage
            cell.infoAttributedText = displayableObject.attributedString
            cell.contentInset = self.imageContentInset ?? UIEdgeInsets()
        })
                
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

private class ListHeaderView: UITableViewHeaderFooterView {
    static func headerViewWithText(_ text: String, width: CGFloat) -> UITableViewHeaderFooterView {
        let containingView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        containingView.contentView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        let labelFrame = CGRect(x: 0, y: 0, width: containingView.frame.width, height: containingView.frame.height)
        let label = UILabel(frame: labelFrame)
        
        label.attributedText = NSAttributedString.attributedStringWithHeadingAttributes(text)
        label.textAlignment = .center
        
        containingView.addSubview(label)
        
        return containingView
    }
}
