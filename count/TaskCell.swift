//
//  TableViewCell.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-05.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.

import UIKit

class TaskCell: UICollectionViewCell {
    
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var countLabel: SpringLabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var boundView: TaskCell!
    
    var content: String? {
        didSet {
            contentLabel.text = content
        }
    }
    var count: Int? {
        didSet {
            countLabel.text = "\(count!)"
        }
    }
    
    override func drawRect(rect: CGRect) {
        
    }
    
    func updateUI() {
        boundView.layer.cornerRadius = 3.0
        boundView.layer.masksToBounds = true
        self.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 3.0).CGPath
        self.layer.shadowOffset = CGSizeMake(0.5, 0.5)
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 1
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 0.3
        addButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        minusButton.layer.cornerRadius = 15
        minusButton.layer.borderWidth = 0.3
        minusButton.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
}
