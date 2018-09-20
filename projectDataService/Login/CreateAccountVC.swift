//
//  CreateAccountVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import AlamofireObjectMapper

class CreateAccountVC: DefaultVC {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var genreButtonFirst: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDropDown()
        self.containerView.layer.cornerRadius = 10.0
        self.createButton.layer.cornerRadius = 20.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func createClicked(_ sender: Any) {
        if let username = self.usernameTextField.text,
            let password = self.passwordTextField.text,
            let city = self.cityTextField.text,
            let phone = self.phoneTextField.text,
            !username.isEmpty && !password.isEmpty && !city.isEmpty && !phone.isEmpty
        {
            self.requestCreateAccount(username: username, password: password, city: city, phone: phone, genre: 21)
        } else {
            self.okAlert(title: "Erreur", message: "Veuillez saisir tous les champs")
        }
    }
    
    func setupDropDown() {
        self.dropDown.anchorView = self.dropDownView
        self.dropDown.dataSource = ["1", "2", "3"]
        self.dropDown.selectionAction = { [weak self] (index, item) in
            self?.genreButtonFirst.setTitle(item, for: .normal)
        }
        self.dropDown.dismissMode = .onTap
    }
    
    func requestCreateAccount(username: String, password: String, city: String, phone: String, genre: Int) {
        let url = self.baseUrl + "/users"
        let parameters = [
            "mail": username,
            "password": password,
            "city": city,
            "phone": phone,
            "genre": 21
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.header).responseObject(completionHandler: { (response: DataResponse<User>) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Succès", message: "Votre compte a été créé", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    
    @IBAction func genreFirstClicked(_ sender: Any) {
        self.dropDown.show()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
