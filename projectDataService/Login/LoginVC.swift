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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestLogin(username: String, password: String) {
        let url = self.baseUrl + "/auth/login"
        let parameters = [
            "username": username,
            "password": password
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { (response) in
            
            switch response.result {
            case .success:
                if let token = response.result.value {
                    SessionManager.GetInstance().setToken(token: token)
                    self.requestGetProfile(token: token, username: username)
                }
                
            case .failure:
                //self.activityIndicator.stopAnimating()
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
    
    func requestGetProfile(token: String, username: String) {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": token]
        
        let url = self.baseUrl + "/users/username/" + username
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<User>) in
            switch response.result {
            case .success:
                if let user = response.result.value {
                    if let id = user.id {
                        SessionManager.GetInstance().setId(id: id)
                    }
                    //self.activityIndicator.stopAnimating()
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
                //self.activityIndicator.stopAnimating()
                self.okAlert(title: "Erreur", message: "Erreur Get Profile \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    @IBAction func connectClicked(_ sender: Any) {
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
    
    @IBAction func createClicked(_ sender: Any) {
    }
}
