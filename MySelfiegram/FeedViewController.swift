//
//  FeedViewController.swift
//  MySelfiegram
//
//  Created by Daniel Mathews on 2015-11-05.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit
import Photos

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var posts:[Post]? = [Post]()
    
    var words = ["Hello", "my", "name", "is", "Selfigram"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIImage has an initalized where you can pass in the name of an image in your project to create an UIImage
        // UIImage(named: "grumpy-cat") can return nil if there is no image called "grumpy-cat" in your project
        // Our definition of Post did not include the possibility of a nil UIImage
        // so, therefore we have to add a ! at the end of it
        
//        let post0 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 0")
//        let post1 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 1")
//        let post2 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 2")
//        let post3 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 3")
//        let post4 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 4")
        
//        posts = [post0, post1, post2, post3, post4]
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! SelfieCell
        
        let post = self.posts?[indexPath.row]
        
        if let imageUrl = post?.imageURL {
            
            // The foundation of the Photos framework is a PHAsset (a photo or video asset)
            // Photos frameworks has this function that takes as input an array of photo URLs and
            // returns the corresponding PHAsset reference ids for those urls
            let asset = PHAsset.fetchAssetsWithALAssetURLs([imageUrl], options: nil)
            
            // Photos Framework comes with an default image manager we can use to get more than just an id reference for the PHAsset
            let mgr = PHImageManager.defaultManager()
            
            // We use the method requestImageForAsset to get an image from the PHAsset
            // we pass in a desired size and how we want the image to fit the size (AspectFill)
            mgr.requestImageForAsset(asset.firstObject as! PHAsset, targetSize: CGSize(width: 600,height: 600), contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { image, info in
                
                // we get back an image and then set it to our cell's selfieImageView.image property
                cell.selfieImageView.image = image
                
            })
            
        }
        
        cell.usernameLabel.text = post?.user.username
        cell.commentLabel.text = post?.comment
        
        return cell
    }
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulators Photo Library
            pickerController.sourceType = .PhotoLibrary
        } else {
            // 4. We check if we are running on am iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera)
            pickerController.sourceType = .Camera
            pickerController.cameraDevice = .Front
            pickerController.cameraCaptureMode = .Photo
        }
        
        // Preset the pickerController on screen
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting the local URL on the phone where the image is stored 
        //    we are getting this from the UIImagePickerControllerReferenceURL key in that dictionary
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            
            //2. We create a Post object from the image
            let me = User(aUsername: "danny", aProfileImage: UIImage(named: "grumpy-cat")!)
            let post = Post(imageURL: imageURL, user: me, comment: "My Photo")
            
            //3. Add post to our posts array
            posts?.append(post)
            
        }
        
        //4. We remember to dismiss the Image Picker from our screen.
        dismissViewControllerAnimated(true, completion: nil)
        
        //5. Now that we have added a post, reload our table
        tableView.reloadData()
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
