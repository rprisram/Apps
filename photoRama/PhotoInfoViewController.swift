//
//  PhotoInfoViewController.swift
//  photoRama
//
//  Created by macbook on 4/15/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    var photo : PhotoRealm! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    var photoStore : PhotoStore!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "showTags" {
            print("inside prep for segue")
            let tagsViewController = segue.destinationViewController as! TagsViewController
            tagsViewController.photo = photo
            tagsViewController.photoStore = photoStore
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoStore.fetchImageForPhoto(photo) { (result) -> Void in
            switch result
            {
            case let .Success(image) : self.imageView.image = image
            case let .Failure(error) : print("Error Fetching the image - \(error)")
            }
        }
        
    }
}
