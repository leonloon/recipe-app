//
//  RecipeDetailsHeaderView.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 11/12/2020.
//

import UIKit

class RecipeDetailsHeaderView: BaseView {
    
    lazy var bannerIV: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Create A New Recipe"
        label.textColor = .white
        label.numberOfLines = 4
        label.font = UIFont(name: bold, size: 28)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 1
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
    }()
    
    override func setupViews() {

        addSubview(bannerIV)
        bannerIV.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview()
        })
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(bannerIV.snp.bottom).offset(-20)
        })

    }
}

