//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by duycuong on 1/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MealTableViewCell: BaseTableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
