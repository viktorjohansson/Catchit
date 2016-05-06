    //
//  NewViewController.swift
//  swift-playground
//
//  Created by viktor johansson on 11/03/16.
//  Copyright © 2016 viktor johansson. All rights reserved.
//

import UIKit

extension UILabel{
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
}

class NewViewController: UIViewController, UICollectionViewDelegate, PostServiceDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    var header: PostCollectionReusableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    let postService = PostService()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var currentUsername: String?
    var postImage: UIImage!
    var postImageUrl: String!
    var likesCount: Int!
    var commentsCount: Int!
    var userName: String!
    var userAvatar: UIImage!
    var userAvatarUrl: String!
    var achievementScore: Int!
    var achievementDescription: String!
    var postId: Int!
    var comments: [String] = []
    var commentUserAvatarUrls: [String] = []
    var commentUserAvatars: [UIImage] = []
    var commentUserNames: [String] = []
    var commentUserIds: [Int] = []
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setPostData(json: AnyObject) {
        postImageUrl = json["image_url"] as! String
        userName = json["user_name"] as! String
        userAvatarUrl = json["user_avatar_url"] as! String
        likesCount = json["likes_count"] as! Int
        commentsCount = json["comments_count"] as! Int
        achievementDescription = json["achievement_description"] as! String
        achievementScore = json["achievement_score"] as! Int
        commentUserNames = (json["commenter_infos"] as! NSArray)[0] as! [String]
        commentUserAvatarUrls = (json["commenter_infos"] as! NSArray)[1] as! [String]
        commentUserIds = (json["commenter_infos"] as! NSArray)[2] as! [Int]
        comments = (json["commenter_infos"] as! NSArray)[3] as! [String]
        loadImageFromUrls()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postService.getPost(postId!)
        self.postService.delegate = self
        self.currentUsername = userDefaults.objectForKey("email") as? String
        textField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("commentCell", forIndexPath: indexPath) as! CommentsCollectionViewCell
        
        let profileLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile(_:)))
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile(_:)))
        
        cell.profileLabel.addGestureRecognizer(profileLabelTapGesture)
        cell.profileImage.addGestureRecognizer(profileImageTapGesture)
        cell.label?.text = self.comments[indexPath.row]
        cell.profileLabel.text = self.commentUserNames[indexPath.row]
        cell.profileImage.image = self.commentUserAvatars[indexPath.row]
        cell.label.numberOfLines = 0
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let label = UILabel(frame: CGRectMake(0, 0, screenSize.width - 100, 0))
            label.text = self.comments[indexPath.row]
            label.font = label.font.fontWithSize(12)
            // Calculates the required height for this comment depending on content
            var newLabelHeight = label.requiredHeight()
            if newLabelHeight < 30 {
                newLabelHeight = 35
            }
            let size = CGSize(width: screenSize.width, height: newLabelHeight + 10)
            return size
    }
    
    func collectionView(collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                                                          atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                               withReuseIdentifier: "commentsTopBar",
                                                                               forIndexPath: indexPath) as! PostCollectionReusableView
        //let bucketlistImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(bucketlistPress(_:)))
        //headerView.bucketlistImage.addGestureRecognizer(bucketlistImageTapGesture)
        let achievementTapGesture = UITapGestureRecognizer(target: self, action: #selector(showAchievement(_:)))
        let likesTapGesture = UITapGestureRecognizer(target: self, action: #selector(showLikes(_:)))
        let profileLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile(_:)))
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile(_:)))
        
        headerView.achievementLabel.addGestureRecognizer(achievementTapGesture)
        headerView.likesCount.addGestureRecognizer(likesTapGesture)
        headerView.profileLabel.addGestureRecognizer(profileLabelTapGesture)
        headerView.profileImage.addGestureRecognizer(profileImageTapGesture)
        headerView.postImage.image = postImage
        headerView.achievementLabel.text = achievementDescription
        headerView.commentsCount.text = String(commentsCount) + " kommentarer"
        headerView.likesCount.text = String(likesCount) + " gilla-markeringar"
        headerView.profileLabel.text = userName
        headerView.profileImage.image = userAvatar
        headerView.scoreLabel.text = String(achievementScore) + "p"
        
        header = headerView
        return headerView
    }

    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 165, moveSpeed: 0.5)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 165, moveSpeed: 0)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        createComment()
        return true
    }
    
    
    // Lifting the view up
    func animateViewMoving (up:Bool, moveValue :CGFloat, moveSpeed:Double){
        let movementDuration:NSTimeInterval = moveSpeed
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func createComment () {
        // This should not use all this counts, bad for the performance, check if atIndex really is needed.
        postService.createComment(textField.text!, postId: postId)
        let indexPath = NSIndexPath(forItem: self.comments.count, inSection: 0)
        comments.insert(textField.text!, atIndex: self.comments.count)
        commentUserNames.insert(currentUsername!, atIndex: self.commentUserNames.count)
        commentUserAvatars.insert(UIImage(named: "avatar")!, atIndex: self.commentUserAvatars.count)
        collectionView.insertItemsAtIndexPaths([indexPath])
        textField.text = ""
    }
    
    @IBAction func showAchievement(sender: AnyObject?) {
        self.performSegueWithIdentifier("showAchievementFromComments", sender: sender)
    }
    
    @IBAction func showLikes(sender: AnyObject?) {
        self.performSegueWithIdentifier("showLikesFromComments", sender: sender)
    }
    
    @IBAction func showProfile(sender: AnyObject?) {
        self.performSegueWithIdentifier("showProfileFromComments", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Tillbaka"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func loadImageFromUrls() {
        if self.commentUserAvatarUrls.count > 0 {
            for avatarUrl in self.commentUserAvatarUrls {
                let url = NSURL(string: "http://192.168.1.116:3000" + avatarUrl)
                let data = NSData(contentsOfURL:url!)
                if data != nil {
                    commentUserAvatars.append(UIImage(data: data!)!)
                }
            }
            
        }
        var url = NSURL(string: "http://192.168.1.116:3000" + postImageUrl)
        var data = NSData(contentsOfURL: url!)
        postImage = UIImage(data: data!)
        url = NSURL(string: "http://192.168.1.116:3000" + userAvatarUrl)
        data = NSData(contentsOfURL: url!)
        userAvatar = UIImage(data: data!)

        NSOperationQueue.mainQueue().addOperationWithBlock(collectionView.reloadData)
    }

}
