//
//  TopRecipeCell.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import UIKit
import SnapKit
import Kingfisher

class TopRecipeCell: BaseTableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.font = UIFont(name: semibold, size: 18)
        return label
    }()
    
    lazy var ingredientLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: regular, size: 14)
        label.numberOfLines = 3
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        })
        
        addSubview(ingredientLabel)
        ingredientLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameLabel)
        })
    }
    
    func configure(recipe: TopRecipe) {
        nameLabel.text = recipe.title
        ingredientLabel.text = recipe.ingredients
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

