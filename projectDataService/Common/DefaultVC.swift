//
//  DefaultVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire

class DefaultVC: UIViewController {

    let apiKey = "141ff21ff49305350dfc0017c9255329"
    let baseUrlIGDB = "https://api-endpoint.igdb.com"
    let baseUrl = "https://pacific-woodland-26831.herokuapp.com"
    
    let headerIGDB: HTTPHeaders = ["Accept": "application/json",
                                   "user-key": "141ff21ff49305350dfc0017c9255329"]
    let header: HTTPHeaders = ["Content-Type": "application/json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func okAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logOut() {
        SessionManager.GetInstance().flush()
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = loginVC
        }, completion: { _ in })
    }
    
}