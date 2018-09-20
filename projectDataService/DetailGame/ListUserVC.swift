//
//  ListUserVC.swift
//  projectDataService
//
//  Created by TRAING Serey on 05/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class ListUserVC: DefaultVC {

    @IBOutlet weak var tableView: UITableView!
    
    //var users: [User] = []
    var users = ["", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ListUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        cell.bindData(name: "Test", city: "Paris")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            controller.view.backgroundColor = UIColor.white
            controller.editProfileButtonView.isHidden = true
            //controller.user = self.users[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
