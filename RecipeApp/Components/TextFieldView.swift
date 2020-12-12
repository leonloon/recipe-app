//
//  TextFieldView.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 10/12/2020.
//

import UIKit
import SkyFloatingLabelTextField

class TextFieldView: BaseView {
    
    lazy var textField: FloatingTextField = {
        let tf = FloatingTextField()
        tf.titleFormatter = { $0.capitalized }
        tf.lineHeight = 0
        tf.selectedTitleColor = .black
        tf.selectedLineHeight = 0
        tf.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        tf.textColor = .black
        tf.layer.cornerRadius = 10
        tf.autocorrectionType = .no
        return tf
    }()

    override func setupViews() {
        
        self.addSubview(textField)
        
        textField.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        })
    }
}

class FloatingTextField: SkyFloatingLabelTextField {
    
    private let leftPadding = CGFloat(15)
    private let rightPadding = CGFloat(15)

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight()-7,
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight()-7,
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {

        let rect = CGRect(
            x: leftPadding,
            y: titleHeight()-7,
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )

        return rect

    }

    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {

        if editing {
            return CGRect(x: leftPadding, y: -7, width: bounds.size.width, height: titleHeight())
        }

        return CGRect(x: leftPadding, y: titleHeight(), width: bounds.size.width, height: titleHeight())
    }
}
