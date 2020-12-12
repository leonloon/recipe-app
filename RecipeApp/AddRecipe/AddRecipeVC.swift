//
//  AddRecipeVC.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import UIKit
import Kingfisher
import CoreData

class AddRecipeVC: BaseTableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditIngredientsDelegate, EditStepsDelegate {
    
    private let ingredientsCellId = "ingredientsCellId"
    private let stepsCellId = "stepsCellId"
    
    var imagePicker = UIImagePickerController()
    var recipe: Recipe?
    var type: String?
    
    lazy var headerView: RecipeDetailsHeaderView = {
        let v = RecipeDetailsHeaderView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
        return v
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Recipe", for: .normal)
        button.backgroundColor = .gray
        button.isEnabled = false
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
        return button
    }()
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(tapCreate))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recipe"
        recipe = Recipe(XML: [:])
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(headerView)
        tableView.addSubview(saveButton)
        
        saveButton.snp.makeConstraints({ (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-20)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).offset(-20)
            }
        })
        
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
    
    @objc func tapCreate() {
        let alert = UIAlertController(title: "Choose To Create", message: nil, preferredStyle: .actionSheet)
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
        validateForm()
    }

    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
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
    
    @objc func tapSave() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RecipeData", in: context)!
        let saveRecipe = NSManagedObject(entity: entity, insertInto: context)
        
        if let image = headerView.bannerIV.image?.pngData() {
            saveRecipe.setValue(image, forKey: "imageUrl")
        }
        
        saveRecipe.setValue(randomId(digits: 10), forKey: "id")
        saveRecipe.setValue(recipe?.name, forKeyPath: "name")
        saveRecipe.setValue(recipe?.ingredients, forKey: "ingredients")
        saveRecipe.setValue(recipe?.steps, forKey: "steps")
        saveRecipe.setValue(type, forKey: "type")
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
    
    func editName() {
        let alert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.recipe?.name ?? ""
            textField.placeholder = "Recipe Name"
        }
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0].text {
                self.recipe?.name = textField
                self.headerView.nameLabel.text = textField
                self.validateForm()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func editIngredients() {
        validateForm()
        let vc = IngredientsVC()
        vc.delegate = self
        vc.ingredients = recipe?.ingredients
        show(vc, sender: nil)
    }
    
    func editSteps() {
        validateForm()
        let vc = StepsVC()
        vc.delegate = self
        vc.steps = recipe?.steps
        show(vc, sender: nil)
    }
    
    func saveIngredients(ingredients: [String]) {
        recipe?.ingredients = ingredients
        validateForm()
        tableView.reloadData()
    }
    
    func saveSteps(steps: [String]) {
        recipe?.steps = steps
        validateForm()
        tableView.reloadData()
    }
    
    func validateForm() {
        saveButton.isEnabled = false
        saveButton.backgroundColor = .gray
        if recipe?.name == nil || recipe?.name == "" {
            print("empty name")
            return
        }
        if headerView.bannerIV.image == nil {
            print("empty banner")
            return
        }
        if let ingredients = recipe?.ingredients {
            if ingredients.isEmpty {
                print("empty ingredients")
                return
            }
        } else {
            return
        }
        if let steps = recipe?.steps {
            if steps.isEmpty {
                print("empty steps")
                return
            }
        } else {
            return
        }
        saveButton.isEnabled = true
        saveButton.backgroundColor = .black
    }
}

// MARK: Table
extension AddRecipeVC {
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
