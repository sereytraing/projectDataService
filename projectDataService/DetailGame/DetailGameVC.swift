//
//  DetailGameVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DetailGameVC: DefaultVC {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var askLoanButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    
    var game: Game?
    var idGame: Int?
    var genres = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestDetailGame()
    }

    func setupGame() {
        if let game = self.game {
            self.descriptionLabel.text = game.description
            self.editorLabel.text = "\(game.publishers?.first)"
            self.genreLabel.text = "\(self.genres.first)"
            
            let arr = game.urlCover?.components(separatedBy: "/")
            var tmp = ""
            if let value = arr?.last {
                tmp = "https://images.igdb.com/igdb/image/upload/t_cover_small_2x/" + value
            }
            
            if let url = URL(string: tmp) {
                let data = try? Data(contentsOf: url)
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestDetailGame() {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        if let id = self.idGame {
            let url = self.baseUrl + "/games/\(id)"
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Game]>) in
                if response.response?.statusCode == 401 {
                    self.logOut()
                } else {
                    switch response.result {
                    case .success:
                        if let game = response.result.value {
                            self.game = game.first
                            self.requestAllGenre()
                        }
                        
                    case .failure:
                        self.okAlert(title: "Erreur", message: "Erreur Get Detail Game \(String(describing: response.response?.statusCode))")
                    }
                }
            })
        }
    }
    
    func requestAddGameToList() {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        
        let url = self.baseUrl + "/games"
        let parameters = [
            "mail": "",
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).responseObject(completionHandler: { (response: DataResponse<Game>) in
            switch response.result {
            case .success:
                self.okAlert(title: "Succès", message: "Ce jeu a été ajouté à votre liste")
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    func requestAllGenre() {
        let url = self.baseUrl + "/genres/all"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: self.header).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Genre]>) in
            switch response.result {
            case .success:
                if let genres = response.result.value {
                    if let gameGenres = self.game?.genres {
                        for genre in genres {
                            for gameGenre in gameGenres {
                                if genre.idAPI == gameGenre {
                                    self.genres.append(genre.name ?? "")
                                }
                            }
                        }
                    }
                    self.setupGame()
                }
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur Get Genre \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    @IBAction func showListUser(_ sender: Any) {
        
    }
    
    @IBAction func addListClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Veux-tu mettre ce jeu dans la liste des jeux pouvant être prêter ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let yesAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.requestAddGameToList()
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
