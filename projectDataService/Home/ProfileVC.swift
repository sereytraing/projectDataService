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
    @IBOutlet weak var commentButtonView: UIView!
    
    var user: User?
    var isFromHome = true
    var comments = [Comment]()
    var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myGameCollectionView.delegate = self
        self.myGameCollectionView.dataSource = self
        self.myGameCollectionView.register(UINib(nibName: "GameCell", bundle:nil) , forCellWithReuseIdentifier: "gameCell")
        self.editProfileButtonView.layer.cornerRadius = 20.0
        
        self.editProfileButtonView.isHidden = !self.isFromHome
        self.commentButtonView.isHidden = !self.isFromHome
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFromHome {
            self.requestGetProfile()
        } else {
            if let user = self.user {
                self.requestAllComments(id: user.id ?? 0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupData() {
        self.emailLabel.text = self.user?.username
        self.telephoneLabel.text = self.user?.phone
        self.cityLabel.text = self.user?.city
        if self.comments.count > 0 {
            self.commentLabel.text = self.comments.first?.review
        }
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
                    self.requestAllComments(id: SessionManager.GetInstance().getId()!)
                }
                
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur Get Profile \(String(describing: response.response?.statusCode))")
            }
        })
    }

    func requestAllComments(id: Int) {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        
        let url = self.baseUrl + "/comments/\(id)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Comment]>) in
            switch response.result {
            case .success:
                if let comments = response.result.value {
                    self.comments = comments
                }
                
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur Get Comments \(String(describing: response.response?.statusCode))")
            }
            self.requestAllGamesFromUser()
            //self.setupData()
        })
    }
    
    func requestAllGamesFromUser() {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        var url = ""
        if self.isFromHome {
            //url = self.baseUrl + "/games/\(SessionManager.GetInstance().getId()!)"
            url = self.baseUrl + "/users/games/lendable"
        } else {
            if let id = self.user?.id {
                url = self.baseUrl + "/games/users/\(id)"
            }
        }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Game]>) in
            switch response.result {
            case .success:
                if let games = response.result.value {
                    self.games = games
                    self.myGameCollectionView.reloadData()
                }
                
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur Get Games from User \(String(describing: response.response?.statusCode))")
            }
            self.setupData()
        })
    }
    
    @IBAction func showAllComments(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "AllCommentsVC") as? AllCommentsVC {
            controller.comments = self.comments
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func showEditProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateProfile", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "UpdateProfileVC") as? UpdateProfileVC {
            controller.user = self.user
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func showWriteComment(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "WriteCommentVC") as? WriteCommentVC {
            controller.idUser = self.user?.id
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        if let gameCell = cell as? GameCell {
            if let picture = self.games[indexPath.row].urlCover {
                gameCell.bindData(name: self.games[indexPath.row].name!, imageUrl: picture)
            } else {
                if let name = self.games[indexPath.row].name {
                    gameCell.bindData(name: name)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailGame", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "DetailGameVC") as? DetailGameVC {
            controller.idGame = self.games[indexPath.item].idIGDB
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        let height = collectionView.bounds.height
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.minimumInteritemSpacing
        }
        return CGSize(width: width / 4, height: height)
    }
}
