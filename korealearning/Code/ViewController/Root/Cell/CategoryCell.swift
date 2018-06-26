//
//  CategoryCell.swift
//  korealearning
//
//  Created by Hien Nguyen on 6/24/18.
//  Copyright © 2018 Hien Nguyen. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!

    var category: Category! {
        didSet {
            updateCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        selectedBackgroundView = view
    }

    func updateCell() {
        lbTitle.text = category.title
        ivIcon.image = UIImage(named: category.icon)
    }
}
