//
//  UserCell.swift
//  projectDataService
//
//  Created by TRAING Serey on 06/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(name: String, city: String) {
        self.nameLabel.text = name
        self.cityLabel.text = city
    }
}
