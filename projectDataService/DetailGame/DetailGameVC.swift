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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var editorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var askLoanButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    
    var game: Game?
    var idGame: Int?
    var genres = [String]()
    var publishers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestDetailGame()
        self.askLoanButton.layer.cornerRadius = 20.0
        self.addListButton.layer.cornerRadius = 20.0
    }

    func setupGame() {
        if let game = self.game {
            self.descriptionLabel.text = game.description
            self.editorLabel.text = self.publishers.first
            self.genreLabel.text = self.genres.first
            
            let arr = game.urlCover?.components(separatedBy: "/")
            var tmp = ""
            if let value = arr?.last {
                tmp = "https://images.igdb.com/igdb/image/upload/t_cover_small_2x/" + value
            }
            
            if let url = URL(string: tmp) {
                let data = try? Data(contentsOf: url)
                self.imageView.image = UIImage(data: data!)
                self.backgroundImageView.image = UIImage(data: data!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestDetailGame() {
        self.activityIndicator.startAnimating()
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
                            self.title = game.first?.name
                            self.requestAllGenre()
                        }
                        
                    case .failure:
                        self.activityIndicator.stopAnimating()
                        self.okAlert(title: "Erreur", message: "Erreur Get Detail Game \(String(describing: response.response?.statusCode))")
                    }
                }
            })
        }
    }
    
    func requestAddGameToList() {
        if let game = self.game {
            let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                            "Authorization": SessionManager.GetInstance().getToken()!]
            
            let url = self.baseUrl + "/games/"
            let parameters = [
                "name": game.name,
                "description": game.description,
                "idapi": game.idIGDB,
                "urlcover": game.urlCover,
                "publisher": game.publishers?.first,
                "lended": false
                ] as [String : Any]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).responseObject(completionHandler: { (response: DataResponse<Game>) in
                
                if response.response?.statusCode == 200 {
                    self.okAlert(title: "Succès", message: "Ce jeu a été ajouté à votre liste")
                } else {
                    self.okAlert(title: "Erreur", message: "Erreur \(String(describing: response.response?.statusCode))")
                }
            })
        }
    }
    
    func requestAllGenre() {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        let url = self.baseUrl + "/genres/all"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Genre]>) in
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
                    self.requestAllPublishers()
                }
            case .failure:
                self.setupGame()
                self.activityIndicator.stopAnimating()
                self.okAlert(title: "Erreur", message: "Erreur Get Genre \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    func requestAllPublishers() {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        if let publi = self.game?.publishers?.first {
            let url = self.baseUrl + "/games/publisher/\(publi!)"
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Genre]>) in
                switch response.result {
                case .success:
                    if let publishers = response.result.value {
                        self.publishers.append(publishers.first?.name ?? "")
                        self.activityIndicator.stopAnimating()
                        self.setupGame()
                    }
                case .failure:
                    self.setupGame()
                    self.activityIndicator.stopAnimating()
                    self.okAlert(title: "Erreur", message: "Erreur Get Publishers \(String(describing: response.response?.statusCode))")
                }
            })
        }
        
    }
    
    @IBAction func showListUser(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DetailGame", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "ListUserVC") as? ListUserVC {
            controller.idGame = self.idGame
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
