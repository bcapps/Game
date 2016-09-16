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

final class ListDataSource<T, U>: NSObject, UITableViewDataSource where U: UITableViewCell {
    
    typealias TableViewCellConfigureBlock = (_ cell: U, _ object: T) -> Void

    fileprivate let sections: [SectionList<T>]
    fileprivate let configureCell: TableViewCellConfigureBlock
    
    init(sections: [SectionList<T>], configureCell: @escaping TableViewCellConfigureBlock) {
        self.sections = sections
        self.configureCell = configureCell
        
        super.init()
    }
    
    func objectForIndexPath(_ indexPath: IndexPath) -> T? {
        return self.sections[(indexPath as NSIndexPath).section].objects[(indexPath as NSIndexPath).row]
    }
    
    func sectionForIndex(_ index: Int) -> SectionList<T> {
        return self.sections[index]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].objects.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.sections[(indexPath as NSIndexPath).section].objects[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(U.self, type: .cell)
        
        if let cell = cell {
            configureCell(cell, object)
        }
        
        return cell ?? UITableViewCell()
    }
}
