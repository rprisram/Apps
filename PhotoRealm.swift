//
//  PhotoRealm.swift
//  photoRama
//
//  Created by macbook on 4/25/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class PhotoRealm: Object {

    dynamic var title : String = ""
    dynamic var photoID : String = ""
    dynamic var dateTaken = NSDate()
    dynamic var photoKey = NSUUID().UUIDString
    dynamic var remoteURL : String = ""
    
    let tags = List<TagRealm>()
    var image : UIImage?
    
    override static func ignoredProperties() -> [String]
    {
        return ["image"]
    }
    
    func addTagObject(tag: TagRealm)
    {
        do {
            let realm = try! Realm.init(configuration: Realm.Configuration.defaultConfiguration)
            try realm.write({
                    self.tags.append(tag)
                })
        } catch {
            print("Error adding tags to the photo - \(error)")
        }
        
    }
    
    func removeTagObject(tag: TagRealm)
    {

        do {
            let realm = try! Realm.init(configuration: Realm.Configuration.defaultConfiguration)
            try realm.write({
                if let index = self.tags.indexOf(tag) {
                self.tags.removeAtIndex(index)
                }
            })
        } catch {
            print("Error adding tags to the photo - \(error)")
        }
        
    }
}

extension PhotoRealm : Equatable {}

func ==( lhs: PhotoRealm ,rhs : PhotoRealm) -> Bool
{
    return lhs.photoID == rhs.photoID
}
