//
//  UpdateProfileVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import DropDown

class UpdateProfileVC: UIViewController {


    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var dropdownView: UIView!
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDropDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitClicked(_ sender: Any) {
    }
    
    @IBAction func dropdownClicked(_ sender: Any) {
          self.dropDown.show()
    }
    
    func setupDropDown() {
        self.dropDown.anchorView = self.dropdownView
        self.dropDown.dataSource = ["1", "2", "3"]
        self.dropDown.selectionAction = { [weak self] (index, item) in
            self?.dropdownButton.setTitle(item, for: .normal)
        }
        self.dropDown.dismissMode = .onTap
    }
}
