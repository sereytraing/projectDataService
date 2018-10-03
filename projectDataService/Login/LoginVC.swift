//
//  LoginVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class LoginVC: DefaultVC {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.containerView.layer.cornerRadius = 10.0
        self.connectButton.layer.cornerRadius = 20.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestLogin(username: String, password: String) {
        self.activityIndicator.startAnimating()
        self.connectButton.isEnabled = false
        
        let url = self.baseUrl + "/auth/login"
        let parameters = [
            "mail": username,
            "password": password
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { (response) in
            
            switch response.result {
            case .success:
                if let token = response.result.value {
                    SessionManager.GetInstance().setToken(token: token)
                    self.requestGetProfile(token: token)
                }
                
            case .failure:
                self.activityIndicator.stopAnimating()
                self.connectButton.isEnabled = true
                if response.response?.statusCode == 404 {
                    self.okAlert(title: "Erreur", message: "Utilisateur non trouvé")
                } else if response.response?.statusCode == 403 {
                    self.okAlert(title: "Erreur", message: "Identifiants incorrects")
                } else if response.response == nil {
                    self.okAlert(title: "Erreur", message: "Aucune réponse du serveur")
                } else {
                    self.okAlert(title: "Erreur", message: "Erreur Auth \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    func requestGetProfile(token: String) {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": token]
        
        let url = self.baseUrl + "/users/"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<User>) in
            switch response.result {
            case .success:
                if let user = response.result.value {
                    if let id = user.id, let genre = user.genre {
                        SessionManager.GetInstance().setId(id: id)
                        SessionManager.GetInstance().setRecommendationGenre(genre: genre)
                    }
                    self.activityIndicator.stopAnimating()
                    self.connectButton.isEnabled = true
                    let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = homeVC
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        window.rootViewController = homeVC
                    }, completion: { _ in })
                }
                
            case .failure:
                self.activityIndicator.stopAnimating()
                self.connectButton.isEnabled = true
                self.okAlert(title: "Erreur", message: "Erreur Get Profile \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    @IBAction func connectClicked(_ sender: Any) {
        if let username = self.usernameTextField.text, !username.isEmpty {
            if let password = self.passwordTextField.text, !password.isEmpty {
                self.requestLogin(username: username, password: password)
            } else {
                self.okAlert(title: "Erreur", message: "Entrez un nom d'utilisateur et un mot de passe")
            }
        } else {
            self.okAlert(title: "Erreur", message: "Entrez un nom d'utilisateur et un mot de passe")
        }
    }
    
    @IBAction func createClicked(_ sender: Any) {
    }
}
