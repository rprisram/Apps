//
//  ImageStore.swift
//  Homepwner
//
//  Created by macbook on 4/7/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit

class ImageStore : NSObject {
    let cache = NSCache()
    func setImage(image : UIImage,Key : String)
    {
        cache.setObject(image, forKey: Key)
        let imageURL = imageURLForKey(Key)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            data.writeToURL(imageURL, atomically: true)
        }
    }
    
    func retrieveImage(Key : String) -> UIImage?
    {
        if let existingImage = cache.objectForKey(Key) as? UIImage{
                return existingImage
        }
        
            let imageURL = imageURLForKey(Key)
            guard let image = UIImage(contentsOfFile: imageURL.path!) else {return nil}
            cache.setObject(image, forKey: Key)
        return image
        
    }
    
    func eraseImage(Key : String)
    {
        cache.removeObjectForKey(Key)
        let imageURL = imageURLForKey(Key)
        do {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        } catch let deleteError {
            print("Error in Deleting from file disk - \(deleteError)")
        }
    }
    
    func imageURLForKey(Key : String) -> NSURL{
        let documentDirectories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.URLByAppendingPathComponent(Key)
    }
}
