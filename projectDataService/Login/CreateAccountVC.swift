//
//  CreateAccountVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import DropDown

class CreateAccountVC: DefaultVC {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var genreButtonFirst: UIButton!
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDropDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func createClicked(_ sender: Any) {
    }
    
    func setupDropDown() {
        self.dropDown.anchorView = self.dropDownView
        self.dropDown.dataSource = ["1", "2", "3"]
        self.dropDown.selectionAction = { [weak self] (index, item) in
            self?.genreButtonFirst.setTitle(item, for: .normal)
        }
        self.dropDown.dismissMode = .onTap
    }
    
    @IBAction func genreFirstClicked(_ sender: Any) {
        self.dropDown.show()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
