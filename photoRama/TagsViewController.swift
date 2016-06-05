//
//  TagsViewController.swift
//  photoRama
//
//  Created by macbook on 4/18/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TagsViewController: UITableViewController {
    
    var tagDataSource = TagDataSource()
    var selectedIndexPaths = [NSIndexPath]()
    var photoStore :PhotoStore!
    var photo: PhotoRealm!
    override func awakeFromNib() {
        super.awakeFromNib()
        print("tags viewC initialized")
    }
    @IBAction func addNewTag(sender: AnyObject) {
            let alertController = UIAlertController(title: "Add New Tag", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.autocapitalizationType = .Words
                textField.placeholder = "Tag Name"
                }
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (okAction) -> Void in
                if let tagName = alertController.textFields?.first?.text {
                        do {
                                let realm = try! Realm.init(configuration: Realm.Configuration.defaultConfiguration)
                                try realm.write({
                                    let tagObject = TagRealm()
                                    tagObject.name = tagName
                                    realm.add(tagObject)
                                })
                        
                        }
                        catch let error{
                            print("Error while saving the tag - \(error)")
                        }
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                        self.updateTags()
                    
                }
                
                }
            alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
         presentViewController(alertController, animated: true, completion: nil)
        
        
        }
    @IBAction func done(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.dataSource = tagDataSource
        tableView.delegate = self
        updateTags()
    }
    
    func updateTags(){

        let tags = try! photoStore.fetchMainQueueTags(nil,sortDescriptors: "name")
        print("tags count - \(tags.count)")
        tagDataSource.tags = tags
        for tag in photo.tags {
            
            if let index = tagDataSource.tags.indexOf(tag) {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                selectedIndexPaths.append(indexPath)
            }

            }
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate Methods

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if selectedIndexPaths.indexOf(indexPath) != nil{
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tag = tagDataSource.tags[indexPath.row]
        if  let index = selectedIndexPaths.indexOf(indexPath) {
            selectedIndexPaths.removeAtIndex(index)
            self.photo.removeTagObject(tag)
        } else {
            selectedIndexPaths.append(indexPath)
            self.photo.addTagObject(tag)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
      }
}  
