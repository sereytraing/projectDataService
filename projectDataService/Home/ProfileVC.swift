//
//  ProfileVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class ProfileVC: DefaultVC {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var myGameCollectionView: UICollectionView!
    @IBOutlet weak var editProfileButtonView: UIView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editProfileButtonView.layer.cornerRadius = 20.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAllComments(_ sender: Any) {
        
    }
    
    @IBAction func showEditProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateProfile", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "UpdateProfileVC") as? UpdateProfileVC {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
