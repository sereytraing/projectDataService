//
//  ListUserVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 05/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ListUserVC: DefaultVC {

    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    var idGame: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCell")
        self.requestListUserForGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestListUserForGame() {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        if let id = self.idGame {
            let url = self.baseUrl + "/games/lenders/\(id)"
            
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[User]>) in
                if response.response?.statusCode == 401 {
                    self.logOut()
                } else {
                    if let users = response.result.value {
                        if users.isEmpty {
                            let alert = UIAlertController(title: "Oups", message: "Personne ne prête ce jeu actuellement", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            self.users = users
                            self.tableView.reloadData()
                        }
                    } else {
                        let alert = UIAlertController(title: "Oups", message: "Personne ne prête ce jeu actuellement", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
}

extension ListUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        cell.bindData(name: self.users[indexPath.row].username ?? "Name", city: self.users[indexPath.row].city ?? "City")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            controller.view.backgroundColor = UIColor.white
            controller.editProfileButtonView.isHidden = true
            controller.user = self.users[indexPath.row]
            controller.isFromHome = false
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
