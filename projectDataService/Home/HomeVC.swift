//
//  HomeVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class HomeVC: DefaultVC {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonView.layer.cornerRadius = 30.0
        self.profileView.layer.cornerRadius = 10.0
        self.searchView.layer.cornerRadius = 10.0
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func switchClicked(_ sender: Any) {
        if self.searchView.isHidden {
            self.profileView.isHidden = true
            self.searchView.isHidden = false
        } else {
            self.profileView.isHidden = false
            self.searchView.isHidden = true
        }
    }
}
