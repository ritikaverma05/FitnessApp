//
//  CollectionViewCell.swift
//  Fitness
//
//  Created by RITIKA VERMA on 26/01/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var planCost: UILabel!
    @IBOutlet weak var planImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 30
        containerView.layer.masksToBounds = true
    }

}
