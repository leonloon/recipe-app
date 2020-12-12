//
//  UserVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import UIKit
import SwiftKeychainWrapper

class UserVC: BaseViewController {
    
    var user = UserSingleton.shared
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(tapLogout))
        return item
    }()
    
    lazy var loggedInLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: bold, size: 28)
        label.text = "Logged In!"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.name
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(loggedInLabel)
        loggedInLabel.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
    }
    
    @objc func tapLogout() {
        
        let removeUsername: Bool = KeychainWrapper.standard.removeObject(forKey: "username")
        let removePassword: Bool = KeychainWrapper.standard.removeObject(forKey: "password")
        
        if removeUsername && removePassword {
            user.logout()
            restartApplication()
        }
    }
}
