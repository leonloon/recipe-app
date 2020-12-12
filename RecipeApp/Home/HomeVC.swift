//
//  HomeVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 10/12/2020.
//

import UIKit
import XMLMapper
import SwiftKeychainWrapper

class HomeVC: BaseViewController, XMLParserDelegate {

    var user = UserSingleton.shared
    
    var picker = UIPickerView()
    var recipeTypes: [RecipeList] = []
    
    lazy var topRecipeButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 8
        btn.setTitle("Top Recipes From Internet", for: .normal)
        btn.addTarget(self, action: #selector(tapTopRecipe), for: .touchUpInside)
        return btn
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Let's Go!", for: .normal)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(tapLetsGo), for: .touchUpInside)
        return btn
    }()
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: isUserSessionExist() ? user.name : "Login", style: .plain, target: self, action: #selector(tapUser))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        loadRecipeTypes()
        
        view.addSubview(topRecipeButton)
        topRecipeButton.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        })
        
        view.addSubview(picker)
        picker.snp.makeConstraints({ (make) in
            make.top.equalTo(topRecipeButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalToSuperview()
        })
        
        view.addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-20)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).offset(-20)
            }
        })
        
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    @objc func tapUser() {
        if isUserSessionExist() {
            let vc = UserVC()
            show(vc, sender: nil)
            return
        }
        let vc = LoginVC()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func tapTopRecipe() {
        let vc = TopRecipeVC()
        show(vc, sender: nil)
    }
    
    @objc func tapLetsGo() {
        let vc = RecipeListVC()
        vc.recipeList = recipeTypes[picker.selectedRow(inComponent: 0)]
        show(vc, sender: nil)
    }
    
    func isUserSessionExist() -> Bool {
        let username = KeychainWrapper.standard.string(forKey: "username")
        let password = KeychainWrapper.standard.string(forKey: "password")
        if username == appUsername && password == appPassword {
            user.name = username ?? ""
            return true
        }
        return false
    }
}

// MARK: Picker
extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeTypes[row].name
    }
    
    func loadRecipeTypes() {
        if let path = Bundle.main.url(forResource: "recipetypes", withExtension: "xml") {
            let task = URLSession.shared.dataTask(with: path) { (data, response, error) in
                do{
                    let xmlDictionary = try XMLSerialization.xmlObject(with: data!) as? [String: Any]
                    let xmlResponse = XMLMapper<RecipeType>().map(XMLObject: xmlDictionary)
                    if let recipeTypes = xmlResponse?.data {
                        self.recipeTypes = recipeTypes
                        DispatchQueue.main.async {
                            self.picker.reloadAllComponents()
                        }
                    }
                } catch {
                    print("Serialization error occurred: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
    }
}
