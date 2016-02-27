//
//  ListDataSource.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

// TODO: Subscripting to make objects private.

final class ListDataSource<T, U where U: UITableViewCell>: NSObject, UITableViewDataSource {
    
    typealias TableViewCellConfigureBlock = (cell: U, object: T) -> Void

    private let objects: [T]
    private let configureCell: TableViewCellConfigureBlock
    
    subscript(index: Int) -> T {
        get {
            return objects[index]
        }
    }
    
    init(objects: [T], configureCell: TableViewCellConfigureBlock) {
        self.objects = objects
        self.configureCell = configureCell
        
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = objects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(U.self, type: .Cell)
        
        configureCell(cell: cell, object: object)
        
        return cell
    }
}
