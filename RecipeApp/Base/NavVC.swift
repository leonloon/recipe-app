//
//  NavVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 10/12/2020.
//

import UIKit

class NavVC: UINavigationController {

    var hideBackButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationBar.tintColor = .black
        self.navigationBar.isTranslucent = false
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if hideBackButton == false {
                viewController.addNavLeftItem()
            }
        }
        super.pushViewController(viewController, animated: true)
    }

    @objc override func navigationBack() {
        popViewController(animated: true)
    }

}

extension UIViewController {
    @objc func addNavLeftItem(_ color: UIColor = .black) {
        
        let leftBarButtonItem: UIBarButtonItem = {
            let item = UIBarButtonItem.init(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(navigationBack))
            item.tintColor = color
            return item
        }()
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func navigationBack() {
        if self.navigationController?.viewControllers.count == 1, self.navigationController?.viewControllers.last == self {
            self.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension UINavigationController {

   func backToViewController(viewController: Swift.AnyClass) {

           for element in viewControllers as Array {
               if element.isKind(of: viewController) {
                   self.popToViewController(element, animated: true)
               break
           }
       }
   }
}
