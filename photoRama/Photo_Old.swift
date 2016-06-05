//
//  Photo.swift
//  photoRama
//
//  Created by macbook on 4/17/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Photo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var image : UIImage?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.title = ""
        self.photoID = ""
        self.datetaken = NSDate()
        self.photoKey = NSUUID().UUIDString
        self.remoteURL = NSURL()
        
    }
    func addTagObject(tag : NSManagedObject){
        let currentTags = mutableSetValueForKey("tags")
        currentTags.addObject(tag)
     }
    
    func removeTagObject(tag : NSManagedObject){
     let currentTags = mutableSetValueForKey("tags")
        currentTags.removeObject(tag)
    }

}
