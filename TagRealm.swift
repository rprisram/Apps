//
//  TagRealm.swift
//  photoRama
//
//  Created by macbook on 4/25/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import RealmSwift

class TagRealm: Object {
    
    dynamic var name : String = ""
    var photos : [PhotoRealm] {
        return linkingObjects(PhotoRealm.self, forProperty: "tags")
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

extension TagRealm : Equatable {}

func == (lhs: TagRealm, rhs: TagRealm) -> Bool
{
    return lhs.name == rhs.name
}
