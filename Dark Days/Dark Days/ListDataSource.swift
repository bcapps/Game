//
//  ListDataSource.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

struct SectionList<T> {
    let sectionTitle: String?
    let objects: [T]
}

final class ListDataSource<T, U where U: UITableViewCell>: NSObject, UITableViewDataSource {
    
    typealias TableViewCellConfigureBlock = (cell: U, object: T) -> Void

    private let sections: [SectionList<T>]
    private let configureCell: TableViewCellConfigureBlock
    
    init(sections: [SectionList<T>], configureCell: TableViewCellConfigureBlock) {
        self.sections = sections
        self.configureCell = configureCell
        
        super.init()
    }
    
    func objectForIndexPath(indexPath: NSIndexPath) -> T? {
        return self.sections[indexPath.section].objects[indexPath.row]
    }
    
    func sectionForIndex(index: Int) -> SectionList<T> {
        return self.sections[index]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].objects.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = self.sections[indexPath.section].objects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(U.self, type: .Cell)
        
        if let cell = cell {
            configureCell(cell: cell, object: object)
        }
        
        return cell ?? UITableViewCell()
    }
}
