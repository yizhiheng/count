//
//  TableViewCell.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-05.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
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
        
        self.layer.shadowOffset = CGSizeMake(3, 3)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOpacity = 0.3
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addTapped(sender: AnyObject) {
    }

    @IBAction func minusTapped(sender: AnyObject) {
    }
}
