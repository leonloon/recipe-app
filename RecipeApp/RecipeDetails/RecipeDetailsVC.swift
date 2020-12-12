//
//  RecipeDetailsVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 11/12/2020.
//

import UIKit
import Kingfisher
import CoreData

class RecipeDetailsVC: BaseTableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditIngredientsDelegate, EditStepsDelegate {
    
    private let ingredientsCellId = "ingredientsCellId"
    private let stepsCellId = "stepsCellId"
    
    var imagePicker = UIImagePickerController()
    var recipe: Recipe?
    
    lazy var headerView: RecipeDetailsHeaderView = {
        let v = RecipeDetailsHeaderView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
        return v
    }()
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(tapEdit))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recipe"
        
        if let _ = recipe?.type {
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        view.addSubview(headerView)
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        if let imageUrl = recipe?.imageUrl {
            let url = URL(string: imageUrl)
            headerView.bannerIV.kf.setImage(with: url)
        } else if let imageData = recipe?.imageData {
            headerView.bannerIV.image = UIImage(data: imageData as Data)
        }
        
        if let name = recipe?.name {
            headerView.nameLabel.text = name
        }
        
        tableView.register(IngredientsCell.self, forCellReuseIdentifier: ingredientsCellId)
        tableView.register(StepsCell.self, forCellReuseIdentifier: stepsCellId)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func tapEdit() {
        let alert = UIAlertController(title: "Choose To Edit", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { _ in
            self.editImage()
        }))
        alert.addAction(UIAlertAction(title: "Name", style: .default, handler: { _ in
            self.editName()
        }))
        alert.addAction(UIAlertAction(title: "Ingredients", style: .default, handler: { _ in
            self.editIngredients()
        }))
        alert.addAction(UIAlertAction(title: "Steps", style: .default, handler: { _ in
            self.editSteps()
        }))
        alert.addAction(UIAlertAction(title: "Delete Recipe", style: .destructive, handler: { _ in
            self.delete(id: self.recipe?.id ?? "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editImage() {
        let alert = UIAlertController(title: "Choose An Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Open Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("Image not found!")
            return
        }
        headerView.bannerIV.image = selectedImage
        save(id: recipe?.id ?? "", name: nil, image: selectedImage, ingredients: nil, steps: nil)
    }

    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func editName() {
        let alert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.recipe?.name ?? ""
            textField.placeholder = "Recipe Name"
        }
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0].text {
                self.save(id: self.recipe?.id ?? "", name: textField, image: nil, ingredients: nil, steps: nil)
                self.headerView.nameLabel.text = textField
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editIngredients() {
        let vc = IngredientsVC()
        vc.delegate = self
        vc.ingredients = recipe?.ingredients
        show(vc, sender: nil)
    }
    
    func editSteps() {
        let vc = StepsVC()
        vc.delegate = self
        vc.steps = recipe?.steps
        show(vc, sender: nil)
    }
    
    func saveIngredients(ingredients: [String]) {
        recipe?.ingredients = ingredients
        save(id: self.recipe?.id ?? "", name: nil, image: nil, ingredients: ingredients, steps: nil)
    }
    
    func saveSteps(steps: [String]) {
        recipe?.steps = steps
        save(id: self.recipe?.id ?? "", name: nil, image: nil, ingredients: nil, steps: steps)
    }
}

// MARK: Table
extension RecipeDetailsVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return recipe?.ingredients?.count ?? 0
        case 1:
            return recipe?.steps?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Ingredients"
        case 1:
            return "Steps"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ingredientsCellId, for: indexPath) as! IngredientsCell
            cell.configure(ingredients: (recipe?.ingredients?[indexPath.row])!)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: stepsCellId, for: indexPath) as! StepsCell
        cell.configure(index: indexPath.row,steps: (recipe?.steps?[indexPath.row])!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: Core Data
extension RecipeDetailsVC {
    func delete(id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeData")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                context.delete(results![0])
                navigationController?.popViewController(animated: true)
            }
            try context.save()
        } catch _ {
            
        }
    }
    
    func save(id: String, name: String?, image: UIImage?, ingredients: [String]?, steps: [String]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeData")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {

                if let name = name {
                    results![0].setValue(name, forKey: "name")
                }
                
                if let image = image {
                    results![0].setValue(image.pngData(), forKey: "imageUrl")
                }
                
                if let ingredients = ingredients {
                    results![0].setValue(ingredients, forKey: "ingredients")
                }
                
                if let steps = steps {
                    results![0].setValue(steps, forKey: "steps")
                }
            }
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try context.save()
            tableView.reloadData()
           }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
}
