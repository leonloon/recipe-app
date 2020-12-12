//
//  Helper.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 11/12/2020.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    func startLoading() {
        SVProgressHUD.show()
    }
    
    func endLoading() {
        SVProgressHUD.dismiss()
    }
}

extension UIImageView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}

func randomId(digits: Int) -> String {
    var number = String()
    for _ in 1...digits {
       number += "\(Int.random(in: 1...9))"
    }
    return number
}

func showAlertView(_ title: String, _ message: String, controller: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    controller.present(alert, animated: true, completion: nil)
    return
}

func restartApplication(pageIndex: Int = 0) {
    let vc = NavVC(rootViewController: HomeVC())

    guard
    let window = UIApplication.shared.keyWindow,
    let rootViewController = window.rootViewController
    else {
        return
    }

    vc.view.frame = rootViewController.view.frame
    vc.view.layoutIfNeeded()

    window.rootViewController = vc
}
