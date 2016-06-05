//
//  PhotosViewController.swift
//  photoRama
//
//  Created by macbook on 4/14/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit
import RealmSwift

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photoStore : PhotoStore!
    var photoDataSource : PhotoDataSource!
    var photosSource :Results<PhotoRealm>!
    
    var photoKey = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("firing viewdidload")
        
//        photoDataSource = PhotoDataSource()
//        collectionView.dataSource = photoDataSource
//        collectionView.delegate = self


        photoStore.fetchRecentPhotos(){result in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                switch result
                {
                case let .Success(photos) :
                    print("this current count - \(photos.count)")
                    let allPhotos = try! self.photoStore.fetchMainQueuePhotos(nil, sortDescriptors: "dateTaken")
                    print("whole count - \(allPhotos.count)")
                    
                    self.photosSource = allPhotos
                    self.photoDataSource = PhotoDataSource()
                    self.photoDataSource.photos = self.photosSource
                    self.collectionView.dataSource = self.photoDataSource
                    self.collectionView.delegate = self
                    
                    self.collectionView.reloadData()
                case let .Failure(error) :
                    //self.photosSource.
                    print(" Errors fetching the photos \(error)")
                }
                
            })

        }
       
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print("willdisplayCell")
       let photo = photosSource[indexPath.row]
        photoStore.fetchImageForPhoto(photo) { (result) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let photoIndex = self.photosSource.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                if let photoCell = self.collectionView.cellForItemAtIndexPath(photoIndexPath) as? PhotoCollectionViewCell{
                    photoCell.updateWithImage(photo.image)
                    }
                
                
            })
        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItem"{
            let photoInfoViewController = segue.destinationViewController as! PhotoInfoViewController
            photoInfoViewController.photoStore = self.photoStore
            let photoIndexPath = collectionView.indexPathsForSelectedItems()?.first!
            let photoSelected = photosSource[photoIndexPath!.row]
            photoInfoViewController.photo = photoSelected
            
        }
    }
}