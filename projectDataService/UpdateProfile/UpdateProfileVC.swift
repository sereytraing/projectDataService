//
//  UpdateProfileVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import DropDown
import AlamofireObjectMapper
import Alamofire

class UpdateProfileVC: DefaultVC {


    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var dropdownView: UIView!
    
    let dropDown = DropDown()
    var user: User?
    var genres = [Genre]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestAllGenre()
        self.hideKeyboardWhenTappedAround()
    }

    func setupData() {
        if let user = self.user {
            self.usernameTextField.text = user.username
            self.cityTextField.text = user.city
            self.phoneTextField.text = user.phone
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if let username = self.usernameTextField.text,
            let city = self.cityTextField.text,
            let phone = self.phoneTextField.text,
            !username.isEmpty && !city.isEmpty && !phone.isEmpty
        {
            if self.dropDown.selectedItem != "-" {
                let indexSelected = self.dropDown.indexForSelectedRow
                self.requestUpdateAccount(username: username, city: city, phone: phone, genre: self.genres[indexSelected ?? 0].idAPI ?? 4)
            }
        } else {
            self.okAlert(title: "Erreur", message: "Veuillez saisir tous les champs")
        }
    }
    
    @IBAction func dropdownClicked(_ sender: Any) {
          self.dropDown.show()
    }
    
    func setupDropDown(genresName: [String]) {
        self.dropDown.anchorView = self.dropdownView
        self.dropDown.dataSource = genresName
        self.dropDown.selectionAction = { [weak self] (index, item) in
            self?.dropdownButton.setTitle(item, for: .normal)
        }
        self.dropDown.dismissMode = .onTap
    }
    
    func requestAllGenre() {
        let url = self.baseUrl + "/genres/all"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: self.header).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Genre]>) in
            switch response.result {
            case .success:
                self.genres = response.result.value ?? []
                var genresName = [String]()
                for genre in self.genres {
                    genresName.append(genre.name ?? "-")
                }
                self.setupDropDown(genresName: genresName)
                self.setupData()
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur Get Genre \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    func requestUpdateAccount(username: String, city: String, phone: String, genre: Int) {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        let url = self.baseUrl + "/users"
        let parameters = [
            "mail": username,
            "city": city,
            "phone": phone,
            "genre": genre
            ] as [String : Any]
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).responseObject(completionHandler: { (response: DataResponse<User>) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Succès", message: "Votre compte a été modifié", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur \(String(describing: response.response?.statusCode))")
            }
        })
    }
}
