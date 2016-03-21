//
//  evenTableViewCell.swift
//  World-Cosplay
//
//  Created by Long Hoang on 3/21/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import UIKit

class evenTableViewCell: UITableViewCell {

    @IBOutlet weak var firstImageView:UIImageView!
    @IBOutlet weak var secondImageView:UIImageView!
    @IBOutlet weak var thirdImageView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
