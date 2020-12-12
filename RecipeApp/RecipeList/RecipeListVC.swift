//
//  RecipeListVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 11/12/2020.
//

import UIKit
import CoreData

class RecipeListVC: BaseTableViewController, XMLParserDelegate {
    
    private let recipeCellId = "recipeCellId"
    
    var recipeList: RecipeList?
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(tapAdd))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = recipeList?.name
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
     
        tableView.register(RecipeCell.self, forCellReuseIdentifier: recipeCellId)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupRecipeList()
    }
    
    func setupRecipeList() {
        let ori = recipeList?.recipes?.filter({ $0.imageUrl != nil })
        recipeList?.recipes = ori
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecipeData")

        do {
            let recipes = try context.fetch(fetchRequest)
            for data in recipes {
                var id: String?
                var name: String?
                var image: NSData?
                var ingredients: [String]?
                var steps: [String]?
                var type: String?
                
                if let data = data.value(forKey: "id") as? String {
                    id = data
                }
                if let data = data.value(forKey: "name") as? String {
                    name = data
                }
                if let data = data.value(forKey: "imageUrl") as? NSData {
                    image = data
                }
                if let data = data.value(forKey: "ingredients") as? [String] {
                    ingredients = data
                }
                if let data = data.value(forKey: "steps") as? [String] {
                    steps = data
                }
                if let data = data.value(forKey: "type") as? String {
                    type = data
                }
                if type == recipeList?.name {
                    if let newRecipe = Recipe(XML: ["id": id ?? "", "name": name ?? "", "imageData": image ?? Data(), "ingredients": ingredients ?? [], "steps": steps ?? [], "type": type ?? ""]) {
                        recipeList?.recipes?.append(newRecipe)
                    }
                }
            }
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @objc func tapAdd() {
        let vc = AddRecipeVC()
        vc.type = recipeList?.name
        show(vc, sender: nil)
    }
}

// MARK: Table
extension RecipeListVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList?.recipes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellId, for: indexPath) as! RecipeCell
        cell.configure(recipe: (recipeList?.recipes![indexPath.row])!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RecipeDetailsVC()
        vc.recipe = recipeList?.recipes![indexPath.row]
        show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
