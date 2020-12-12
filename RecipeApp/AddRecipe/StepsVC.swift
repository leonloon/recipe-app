//
//  StepsVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 11/12/2020.
//

import Eureka

protocol EditStepsDelegate: class {
    func saveSteps(steps: [String])
}

class StepsVC: FormViewController {
    
    weak var delegate: EditStepsDelegate?
    var steps: [String]?
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSave))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        title = "Steps"
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "Steps",
                               footer: "") {
                                $0.tag = "textfields"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Next Step"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Step"
                                    }
                                }
                                if let steps = steps {
                                    for elem in steps {
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Step"
                                            $0.value = elem
                                        }
                                    }
                                }

        }
    }
    
    @objc func tapSave() {
        
        var steps: [String] = []
        let dict = form.values()
        
        if let values = dict["textfields"] {
            steps = values as! [String]
        }
        
        delegate?.saveSteps(steps: steps)
        navigationController?.popViewController(animated: true)
    }
}

