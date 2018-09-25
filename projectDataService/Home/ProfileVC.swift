//
//  ProfileVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ProfileVC: DefaultVC {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var myGameCollectionView: UICollectionView!
    @IBOutlet weak var editProfileButtonView: UIView!
    
    var user: User?
    var isFromHome = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editProfileButtonView.layer.cornerRadius = 20.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromHome {
            self.requestGetProfile()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupData() {
        self.emailLabel.text = self.user?.username
        self.telephoneLabel.text = self.user?.phone
        self.cityLabel.text = self.user?.city
    }
    
    func requestGetProfile() {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        
        let url = self.baseUrl + "/users/"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<User>) in
            switch response.result {
            case .success:
                if let user = response.result.value {
                    self.user = user
                    self.setupData()
                }
                
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur Get Profile \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    @IBAction func showAllComments(_ sender: Any) {
        
    }
    
    @IBAction func showEditProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateProfile", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "UpdateProfileVC") as? UpdateProfileVC {
            controller.user = self.user
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
