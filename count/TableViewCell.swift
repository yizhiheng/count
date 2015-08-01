//
//  TableViewCell.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-05.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var countLabel: SpringLabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
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
    override func awakeFromNib() {
        super.awakeFromNib()
        //addShadow(countLabel, contentLabel)
        
//        self.layer.shadowOffset = CGSizeMake(3, 3)
//        self.layer.shadowRadius = 3
//        self.layer.shadowColor = UIColor.grayColor().CGColor
//        self.layer.shadowOpacity = 0.5
        
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 0.3
        addButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        minusButton.layer.cornerRadius = 15
        minusButton.layer.borderWidth = 0.3
        minusButton.layer.borderColor = UIColor.lightGrayColor().CGColor

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
