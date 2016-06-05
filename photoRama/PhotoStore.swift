//
//  PhotoStore.swift
//  photoRama
//
//  Created by macbook on 4/14/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoStore{
    let session : NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    //MARK: Image storage
    let imageStore = ImageStore()
    
    //MARK: Core Data Fetch request for all photos & Tags
    func fetchMainQueuePhotos(predicate : NSPredicate? = nil, sortDescriptors : String? = nil) throws -> Results<PhotoRealm>
    {   let realm = try! Realm.init(configuration: Realm.Configuration.defaultConfiguration)
        guard let predicate = predicate else { return  realm.objects(PhotoRealm).sorted(sortDescriptors!) }
        
        return realm.objects(PhotoRealm).filter(predicate).sorted(sortDescriptors!)
        
    }
    
    func fetchMainQueueTags(predicate : NSPredicate? = nil,sortDescriptors : String? = nil)
        throws -> Results<TagRealm> {
           let realm = try! Realm.init(configuration: Realm.Configuration.defaultConfiguration)
            guard let predicate = predicate else { return  realm.objects(TagRealm).sorted(sortDescriptors!) }
            
            return realm.objects(TagRealm).filter(predicate).sorted(sortDescriptors!)
    }
    
    
    //MARK: Fetch Photos and associated JSON data retrieval call
    func fetchRecentPhotos(completion : (PhotosResult) -> Void){
        let url = FlickrAPI.recentPhotosURL()
        let req = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(req) { (data, response, error) -> Void in
        var result = self.processRecentPhotosRequest(data, error: error)
            if case let .Success(photos) = result{
                    let sortByDateTaken = "dateTaken"
                    
                    let photos = try! self.fetchMainQueuePhotos(nil, sortDescriptors: sortByDateTaken)
                    let mainQueuePhotos = NSArray(objects: photos) as! ([PhotoRealm])
                    result = .Success(mainQueuePhotos)
                
            }
        
        completion(result)
        }
        task.resume()
    }
    
    func processRecentPhotosRequest(data : NSData?, error : NSError?) -> PhotosResult {
        
        guard let jsonData = data else {
            return PhotosResult.Failure(error!)
        }
        return FlickrAPI.photosFromJSONData(jsonData)
    }
    
    //MARK: Fetch one image adn store in file
    func fetchImageForPhoto(photo : PhotoRealm, Completion : (ImageResult)-> Void)
    {
        //if its already downloaded, dont download again!
        let photoKey = photo.photoKey
        if let img = self.imageStore.retrieveImage(photoKey) {
            photo.image = img
            Completion(.Success(img))
            return
        }
        let url = NSURL(string: photo.remoteURL)
        let request = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
         let result = self.processImageRequest(data, error: error)
            if case let .Success(img) = result{
                photo.image = img
                self.imageStore.setImage(img, Key: photoKey)
            }
        Completion(result)
        }
        task.resume()
    }
    
    func processImageRequest(data : NSData?, error : NSError?) -> ImageResult
    {
        guard let imageData = data,
              let image = UIImage(data: imageData)
            else {
                   return .Failure(ImageError.ImageCreationError)
                 }
        return .Success(image)
    }
    
}

//MARK: Enums for Image creation Handling
enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum ImageError : ErrorType{
    case ImageCreationError
}
