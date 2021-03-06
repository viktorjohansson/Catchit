//
//  ProfileCollectionReusableView.swift
//  swift-playground
//
//  Created by viktor johansson on 05/05/16.
//  Copyright © 2016 viktor johansson. All rights reserved.
//

import UIKit

class ProfileCollectionReusableView: UICollectionReusableView {
    // MARK: Setup
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var followCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var completeProgressView: UIProgressView! {
        didSet { resize(4, sender: self.completeProgressView) }
    }
    
    func resize(factor: Int, sender: UIProgressView) {
        sender.transform = CGAffineTransformMakeScale(1, 4)
    }
}
