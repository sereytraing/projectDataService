//
//  GameCell.swift
//  projectDataService
//
//  Created by TRAING Serey on 05/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10.0
    }
    
    func bindData(name: String, imageUrl: String? = nil) {
        self.nameLabel.text = name
        
        let arr = imageUrl?.components(separatedBy: "/")
        var tmp = ""
        if let value = arr?.last {
            tmp = "https://images.igdb.com/igdb/image/upload/t_cover_small_2x/" + value
        }
        
        if let url = URL(string: tmp) {
            let data = try? Data(contentsOf: url)
            self.imageView.image = UIImage(data: data!)
        } else {
            //self.imageView.image = UIImage(named: "fish_1")
        }
    }
    
}
