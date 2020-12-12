//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 10/12/2020.
//

import UIKit
import SnapKit
import Kingfisher

class RecipeCell: BaseTableViewCell {
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        v.layer.cornerRadius = 8
        return v
    }()
    
    lazy var imageIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.roundCorners(corners: [.topLeft, .bottomLeft], radius: 8)
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 4
        label.font = UIFont(name: semibold, size: 18)
        return label
    }()
    
    lazy var calorieLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(180)
        })
        
        containerView.addSubview(imageIV)
        imageIV.snp.makeConstraints ({ (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo((screenWidth-40)/2)
            make.height.equalTo(180)
        })
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(20)
            make.left.equalTo(imageIV.snp.right).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        })
        
        containerView.addSubview(calorieLabel)
        calorieLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(nameLabel)
        })
    }
    
    func configure(recipe: Recipe) {
        clearCache()
        if let image = recipe.imageUrl {
            imageIV.kf.setImage(with: URL(string: image))
        } else if let image = recipe.imageData {
            imageIV.image = UIImage(data: image as Data)
        }
        
        nameLabel.text = recipe.name
    }
    
    func clearCache() {
        imageIV.image = nil
        nameLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
