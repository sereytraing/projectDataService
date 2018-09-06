//
//  SearchVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 04/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class SearchVC: DefaultVC {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var gamesRecommendation: [Game] = []
    var games: [Game] = []
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "GameCell", bundle:nil) , forCellWithReuseIdentifier: "gameCell")
        self.requestGetRecommendation()
        self.searchTextField.delegate = self
        //self.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestGetRecommendation() {
        //CHANGER LE GENRE AVEC CELUI DU USER
        let url = self.baseUrlIGDB + "/games/?fields=id,name,publishers,cover,summary,genres&filter[genres][eq]=4&limit=20&order=popularity:desc"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headerIGDB).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Game]>) in
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let games = response.result.value {
                        self.gamesRecommendation = games
                        self.collectionView.reloadData()
                    }
                    
                case .failure:
                    if response.response?.statusCode == 204 {
                        self.gamesRecommendation = []
                        self.collectionView.reloadData()
                    } else {
                        self.okAlert(title: "Erreur", message: "Erreur Get Recommendation \(String(describing: response.response?.statusCode))")
                    }
                }
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    func requestGetGames(text: String) {
        let url = self.baseUrlIGDB + "/games/?search=\(text)&fields=id,name,cover&limit=50&order=popularity:desc"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headerIGDB).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Game]>) in
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let games = response.result.value {
                        self.games = games
                        self.collectionView.reloadData()
                    }
                    
                case .failure:
                    if response.response?.statusCode == 204 {
                        self.games = []
                        self.collectionView.reloadData()
                    } else {
                        self.okAlert(title: "Erreur", message: "Erreur Get Recommendation \(String(describing: response.response?.statusCode))")
                    }
                }
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count > 2 {
            self.activityIndicator.startAnimating()
            let tmp = text.replacingOccurrences(of: " ", with: "+")
            self.requestGetGames(text: tmp)
        }
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let text = self.searchTextField.text, text.isEmpty {
            return self.gamesRecommendation.count
        }
        return self.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        if let gameCell = cell as? GameCell {
            if let text = self.searchTextField.text, text.isEmpty {
                if let picture = self.gamesRecommendation[indexPath.row].urlCover {
                    gameCell.bindData(name: self.gamesRecommendation[indexPath.row].name!, imageUrl: picture)
                } else {
                    gameCell.bindData(name: self.gamesRecommendation[indexPath.row].name!)
                }
            }
            else {
                if let picture = self.games[indexPath.row].urlCover {
                    gameCell.bindData(name: self.games[indexPath.row].name!, imageUrl: picture)
                } else {
                    gameCell.bindData(name: self.games[indexPath.row].name!)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailGame", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "DetailGameVC") as? DetailGameVC {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        let height = collectionView.bounds.height
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.minimumInteritemSpacing
        }
        return CGSize(width: width / 2, height: height / 2.5)
    }
}

extension SearchVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(getHints),
            userInfo: ["textField": textField],
            repeats: false)
        return true
    }
    
    @objc func getHints(timer: Timer) {
        if let text = self.searchTextField.text, text.count > 2 {
            self.activityIndicator.startAnimating()
            let tmp = text.replacingOccurrences(of: " ", with: "+")
            self.requestGetGames(text: tmp)
        }
        self.collectionView.reloadData()
    }
}

