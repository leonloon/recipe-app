//
//  TopRecipeVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import UIKit

class TopRecipeVC: BaseTableViewController {
    
    private let topRecipeCellId = "topRecipeCellId"
    
    var recipes: [TopRecipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        title = "Top Recipes from Internet"
        
        tableView.register(TopRecipeCell.self, forCellReuseIdentifier: topRecipeCellId)
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getTopRecipe()
    }
}

// MARK: Table
extension TopRecipeVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: topRecipeCellId, for: indexPath) as! TopRecipeCell
        cell.configure(recipe: recipes[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: Networking
extension TopRecipeVC {
    
    func getTopRecipe() {
        Networking().getTopRecipe(params: [:], controller: self) { topRecipe in
            self.recipes = topRecipe
            self.tableView.reloadData()
        }
    }
}
