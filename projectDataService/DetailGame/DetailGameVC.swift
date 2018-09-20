//
//  DetailGameVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class DetailGameVC: DefaultVC {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var askLoanButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGame()
    }

    func setupGame() {
        if let game = self.game {
            self.descriptionLabel.text = game.description
            self.editorLabel.text = "\(game.publishers?.first)"
            self.genreLabel.text = "\(game.genres?.first)"
            
            let arr = game.urlCover?.components(separatedBy: "/")
            var tmp = ""
            if let value = arr?.last {
                tmp = "https://images.igdb.com/igdb/image/upload/t_cover_small_2x/" + value
            }
            
            if let url = URL(string: tmp) {
                let data = try? Data(contentsOf: url)
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showListUser(_ sender: Any) {
        
    }
    
    @IBAction func addListClicked(_ sender: Any) {
    }
}
