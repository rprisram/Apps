//
//  PhotoDataSource.swift
//  photoRama
//
//  Created by macbook on 4/15/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoDataSource : NSObject, UICollectionViewDataSource {
    
    var photos  : Results<PhotoRealm>!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        print("in cell for ItematindexPath")
        
        //let photoImg = photos[indexPath.row]
        
        cell.updateWithImage(nil)
        return cell
    }
    
    
    
}
