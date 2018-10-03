//
//  WriteCommentVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 02/10/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import DropDown

class WriteCommentVC: DefaultVC {

    var idUser: Int?
    let dropDown = DropDown()
    
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDropDown()
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if let text = commentTextField.text, !text.isEmpty {
            if let selectedItem = self.dropDown.selectedItem {
                if let mark = Int(selectedItem) {
                    self.requestCreateComment(mark: mark, review: text)
                }
            } else {
                self.okAlert(title: "Erreur", message: "Choisir une note et écrire un commentaire svp")
            }
        }
    }
    
    func setupDropDown() {
        self.dropDown.anchorView = self.dropDownView
        self.dropDown.dataSource = ["5", "4", "3", "2", "1"]
        self.dropDown.selectionAction = { [weak self] (index, item) in
            self?.dropDownButton.setTitle(item, for: .normal)
        }
        self.dropDown.dismissMode = .onTap
    }
    
    func requestCreateComment(mark: Int, review: String) {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": SessionManager.GetInstance().getToken()!]
        
        let url = self.baseUrl + "/comments/\(SessionManager.GetInstance().getId()!)"
        let parameters = [
            "mark": mark,
            "review": review,
            "iduser": self.idUser!
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).responseObject(completionHandler: { (response: DataResponse<Comment>) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Succès", message: "Votre commentaire a été envoyé", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    @IBAction func dropDownClicked(_ sender: Any) {
        self.dropDown.show()
    }
}
