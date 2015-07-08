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
        
        addShadow(self, countLabel, contentLabel, addButton, minusButton)
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addTapped(sender: AnyObject) {
        println("123")

    }

    @IBAction func minusTapped(sender: AnyObject) {
    }
}
