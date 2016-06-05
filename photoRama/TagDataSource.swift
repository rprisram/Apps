//
//  TagDataSource.swift
//  photoRama
//
//  Created by macbook on 4/18/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TagDataSource : NSObject, UITableViewDataSource {
    var tags  : Results<TagRealm>!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let name = tags[indexPath.row].valueForKey("name") as! String
        cell.textLabel?.text = name
        return cell
        
    }
}
