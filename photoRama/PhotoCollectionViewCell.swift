//
//  PhotoCollectionViewCell.swift
//  photoRama
//
//  Created by macbook on 4/15/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    
    func updateWithImage(image :UIImage?)
    {
        if let img = image {
            spinner.stopAnimating()
            imageView.image = img
        } else
        {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareforReuse")
        updateWithImage(nil)
    }
}
