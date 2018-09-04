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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAllComments(_ sender: Any) {
        
    }
}
