//
//  StepsCell.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 11/12/2020.
//

import UIKit
import SnapKit

class StepsCell: BaseTableViewCell {
    
    lazy var stepsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(stepsLabel)
        stepsLabel.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(20)
        })
        
        addSubview(instructionsLabel)
        instructionsLabel.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(stepsLabel.snp.right).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        })
    }
    
    func configure(index: Int, steps: String) {
        stepsLabel.text = "\(index+1)"
        instructionsLabel.text = steps
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


