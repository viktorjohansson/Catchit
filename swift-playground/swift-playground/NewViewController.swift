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

class NewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var comments = []
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(comments)
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
        
        cell.label?.text = self.comments[indexPath.row] as? String
        cell.label.numberOfLines = 0
        
        print(indexPath)
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let label = UILabel(frame: CGRectMake(0, 0, screenSize.width - 100, 0))
            label.text = self.comments[indexPath.row] as? String
            label.font = label.font.fontWithSize(12)
            // Calculates the required height for this comment depending on content
            var newLabelHeight = label.requiredHeight()
            if newLabelHeight < 30 {
                newLabelHeight = 35
            }
            let size = CGSize(width: screenSize.width, height: newLabelHeight + 10)
            print(size)
            return size
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
