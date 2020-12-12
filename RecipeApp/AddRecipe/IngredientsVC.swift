//
//  IngredientVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 11/12/2020.
//

import Eureka

protocol EditIngredientsDelegate: class {
    func saveIngredients(ingredients: [String])
}

class IngredientsVC: FormViewController {
    
    weak var delegate: EditIngredientsDelegate?
    var ingredients: [String]?
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSave))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        title = "Ingredients"
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "Ingredients",
                               footer: "") {
                                $0.tag = "textfields"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add New Ingredients"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Ingredients"
                                    }
                                }
                                if let ingredients = ingredients {
                                    for elem in ingredients {
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Tag Name"
                                            $0.value = elem
                                        }
                                    }
                                }
        }
    }
    
    @objc func tapSave() {
        
        var ingredients: [String] = []
        let dict = form.values()
        
        if let values = dict["textfields"] {
            ingredients = values as! [String]
        }
        
        delegate?.saveIngredients(ingredients: ingredients)
        navigationController?.popViewController(animated: true)
    }
}
