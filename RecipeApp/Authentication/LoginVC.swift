//
//  LoginVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import UIKit
import SwiftKeychainWrapper

class LoginVC: BaseViewController {
    
    var user = UserSingleton.shared
    
    lazy var usernameTF: TextFieldView = {
        let tf = TextFieldView()
        tf.textField.title = "Username"
        tf.textField.placeholder = "Username"
        tf.textField.autocapitalizationType = .none
        return tf
    }()
    
    lazy var passwordTF: TextFieldView = {
        let tf = TextFieldView()
        tf.textField.isSecureTextEntry = true
        tf.textField.title = "Password"
        tf.textField.placeholder = "Password"
        return tf
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 8
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(tapLogin), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        view.addSubview(usernameTF)
        usernameTF.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        })
        
        view.addSubview(passwordTF)
        passwordTF.snp.makeConstraints({ (make) in
            make.top.equalTo(usernameTF.snp.bottom).offset(20)
            make.leading.trailing.equalTo(usernameTF)
            make.height.equalTo(usernameTF)
        })
        
        view.addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.top.equalTo(passwordTF.snp.bottom).offset(20)
            make.leading.trailing.equalTo(usernameTF)
            make.height.equalTo(50)
        })
    }
    
    @objc func tapLogin() {
        let username = usernameTF.textField.text
        let password = passwordTF.textField.text
        
        guard username == appUsername && password == appPassword else {
            showAlertView("Opps!", "Wrong username and password", controller: self)
            return
        }
        
        if let username = username, let password = password {
            let saveUsername: Bool = KeychainWrapper.standard.set(username, forKey: "username")
            let savePassword: Bool = KeychainWrapper.standard.set(password, forKey: "password")
            
            if saveUsername && savePassword {
                user.name = appUsername
                restartApplication()
            }
        }
    }
}
