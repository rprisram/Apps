//
//  FlickerAPI.swift
//  photoRama
//
//  Created by macbook on 4/14/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "4cc71ede4a18054e47bdb7b714947f73"
    static var counter = 0
    private static let dateFormatter : NSDateFormatter = {
       let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }()
    //MARK: Methods to construct and return URL
    static func recentPhotosURL() -> NSURL {
        return flickrURL(.RecentPhotos, parameters: ["extras" : "url_h,date_taken"])
    }
    
    private static func flickrURL(method : Method, parameters : [String : String]?) -> NSURL
    {
        let components = NSURLComponents(string: baseURLString)!
        var queryItem = [NSURLQueryItem]()
        let baseParams = [
            "method" : method.rawValue,
            "api_key": apiKey,
            "format" : "json",
            "nojsoncallback" : "1"
                        ]
        for (key, value) in baseParams{
            let item = NSURLQueryItem(name: key, value: value)
            queryItem.append(item)
        }
        
        if let additionalParams  = parameters{
            for (key,value) in additionalParams{
                let item = NSURLQueryItem(name: key, value: value)
                queryItem.append(item)
            }
        }
        
        components.queryItems = queryItem
        return components.URL!
    }
    
    //MARK: Methods to retrieve Photo type data from JSON Data
    static func photosFromJSONData(data : NSData) -> PhotosResult
    {
        do{
            let jsonObj : AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                guard let jsonDict = jsonObj as? [NSObject:AnyObject],
                    let photos = jsonDict["photos"] as? [String : AnyObject],
                    let photosArray =  photos["photo"] as? [[String : AnyObject]]
                    else {
                        return .Failure(FlickrError.InvalidJSONData)
                }
                
                var finalPhotos = [PhotoRealm]()
                for photo in photosArray
                {
                    if let photoItem = photoFromPhotosArray(photo){
                    finalPhotos.append(photoItem)
                    
                    }
                }
            
            return .Success(finalPhotos)
        }
        catch let jsonError {
            return .Failure(jsonError)
        }
    }
    private static func photoFromPhotosArray(photoObj : [String : AnyObject]) -> PhotoRealm?
    {
       
        guard let photoID = photoObj["id"] as? String,
             let title = photoObj["title"] as? String,
             let dateString = photoObj["datetaken"] as? String,
             let datetaken = dateFormatter.dateFromString(dateString),
             let tempURL = photoObj["url_h"] as? String,
             let tmpURL = NSURL(string: tempURL),
             let remoteURL = Optional(tmpURL.absoluteString)
        else {
                return nil
             }
        
        //Existing check
        let predicate = NSPredicate(format: "photoID == %@", photoID)
        let existingPhotos = realm.objects(PhotoRealm).filter(predicate)
        if existingPhotos.count > 0 {
            
            return existingPhotos.first
        }

        var photoRealm : PhotoRealm!
        do{
            try realm.write {
                photoRealm = PhotoRealm()
                photoRealm.photoID = photoID
                photoRealm.title = title
                photoRealm.dateTaken = datetaken
                photoRealm.remoteURL = remoteURL
                realm.add(photoRealm)
            }
            
        } catch {
            print("Error writing individual Photo Object - \(error)")
        }
        return photoRealm
        //return Photo(photoID: photoID, title: title, dateTaken: dateTaken, remoteURL: remoteURL)
    }
}
//MARK: ENUMs declared for this API
enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case Success([PhotoRealm])
    case Failure(ErrorType)
}

enum FlickrError : ErrorType{
    case InvalidJSONData
    case NotAJSONObj
}



