//
//  CommentCell.swift
//  projectDataService
//
//  Created by TRAING Serey on 06/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(rate: Int, review: String) {
        self.rateLabel.text = "\(rate)"
        self.reviewLabel.text = review
    }
}
