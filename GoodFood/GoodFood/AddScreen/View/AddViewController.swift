//
//  AddViewController.swift
//  GoodFood
//
//  Created by Иван on 15.11.2021.
//

import UIKit

protocol AddViewControllerDelegate: AnyObject {
    func passImage(image: UIImage?)
}

protocol SaveNameDelegate: AnyObject {
    func saveName(recipe: RecipeCD)
}

protocol SaveImageDelegate: AnyObject {
    func saveImage(recipe: RecipeCD)
}

protocol SaveTimeDelegate: AnyObject {
    func saveTime(recipe: RecipeCD)
}

//protocol SaveIngredientDelegate: AnyObject {
//    func saveIngredient(recipe: RecipeCD)
//}

class AddViewController: UIViewController {
    
    private var navBar = UINavigationBar()
    private var tableView = UITableView()
    private let imagePicker = UIImagePickerController()
    
    private let dataBaseManager: DataManager = DataManager.shared
    
    weak var delegate: AddViewControllerDelegate?
    weak var saveNameDelegate: SaveNameDelegate?
    weak var saveImageDelegate: SaveImageDelegate?
    weak var saveTimeDelegate: SaveTimeDelegate?
//    weak var saveIngredientDelegate: [SaveIngredientDelegate]?
    
    private var isEditingTableView: Bool = false
    var back: (() -> Void)?
    
    private let sectionsArray = ["Название блюда",
                                 "Фото",
                                 "Время приготовления",
                                 "Ингредиенты",
                                 "Приготовление",
                                 ""]
    private var ingredientsArray = [""]
    private var stagesArray = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupUI()
        
    }
}

extension AddViewController {
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: 0)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Новый рецепт"
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NameCell.reuseId, bundle: nil), forCellReuseIdentifier: NameCell.reuseId)
        tableView.register(UINib(nibName: PhotoCell.reuseId, bundle: nil), forCellReuseIdentifier: PhotoCell.reuseId)
        tableView.register(UINib(nibName: TimeCell.reuseId, bundle: nil), forCellReuseIdentifier: TimeCell.reuseId)
        tableView.register(UINib(nibName: ConfirmCell.reuseId, bundle: nil), forCellReuseIdentifier: ConfirmCell.reuseId)
        tableView.register(UINib(nibName: IngredientCell.reuseId, bundle: nil), forCellReuseIdentifier: IngredientCell.reuseId)
        tableView.register(UINib(nibName: StageCell.reuseId, bundle: nil), forCellReuseIdentifier: StageCell.reuseId)
        tableView.register(UINib(nibName: AddIngredientCell.reuseId, bundle: nil), forCellReuseIdentifier: AddIngredientCell.reuseId)
        tableView.register(UINib(nibName: AddStageCell.reuseId, bundle: nil), forCellReuseIdentifier: AddStageCell.reuseId)
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBarButton"), style: .plain, target: self, action: #selector(backAction))
        let editButton = UIButton(type: .custom);
        editButton.setImage(UIImage(named: "pen"), for: .normal);
        editButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20);
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(startEditing), for: .touchUpInside);
        let editBarButtonItem = UIBarButtonItem(customView: editButton)
        editBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true;
        editBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true;
        navigationItem.setRightBarButtonItems([editBarButtonItem], animated: true)
    }
    
    @objc
    private func backAction() {
        back?()
    }
    @objc
    private func startEditing() {
        if isEditingTableView {
            tableView.isEditing = false
            isEditingTableView = !isEditingTableView
        } else {
            tableView.isEditing = true
            isEditingTableView = !isEditingTableView
        }
    }
}

extension AddViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return ingredientsArray.count + 1
        case 4:
            return stagesArray.count + 1
        default:
            if section <= 5 {
                return 1
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as? NameCell else {return UITableViewCell()}
            saveNameDelegate = cell
            return cell
        case 1:
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell else {
                return UITableViewCell()
            }
            saveImageDelegate = photoCell
            photoCell.delegate = self
            return photoCell
        case 2:
            guard let timeCell = tableView.dequeueReusableCell(withIdentifier: TimeCell.reuseId, for: indexPath) as? TimeCell else {return UITableViewCell()}
            saveTimeDelegate = timeCell
            return timeCell
        case 3:
            if indexPath.row < ingredientsArray.count {
                guard let ingredientCell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseId, for: indexPath) as? IngredientCell else {return UITableViewCell()}
                ingredientCell.ingredientTextField.text = ""
                return ingredientCell
            } else {
                guard let addIngredientCell = tableView.dequeueReusableCell(withIdentifier: AddIngredientCell.reuseId, for: indexPath) as? AddIngredientCell else {return UITableViewCell()}
                addIngredientCell.delegate = self
                return addIngredientCell
            }
        case 4:
            if indexPath.row < stagesArray.count {
                guard let stageCell = tableView.dequeueReusableCell(withIdentifier: StageCell.reuseId, for: indexPath) as? StageCell else {return UITableViewCell()}
                stageCell.delegate = self
                stageCell.stageTextView.text = ""
//                stageCell.photoImageView.image = UIImage(named: "PhotoPlaceholder")
                return stageCell
            } else {
                guard let addStageCell = tableView.dequeueReusableCell(withIdentifier: AddStageCell.reuseId, for: indexPath) as? AddStageCell else {return UITableViewCell()}
                addStageCell.delegate = self
                return addStageCell
            }
        case 5:
            guard let confirmCell = tableView.dequeueReusableCell(withIdentifier: ConfirmCell.reuseId, for: indexPath) as? ConfirmCell else {return UITableViewCell()}
            confirmCell.delegate = self
            return confirmCell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionsArray.count == 0 {
            return nil
        }
        return sectionsArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 241
        case 2:
            return 50
        case 3:
            return 44
        case 4:
            if indexPath.row < stagesArray.count {
                return 44
            } else {
                return 44
            }
        case 5:
            return 44 //было 70 для фото
        default:
            return 44
        }
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        switch indexPath.section {
        case 3:
            if indexPath.row < ingredientsArray.count {
                return true
            } else {
                return false
            }
        case 4:
            if indexPath.row < stagesArray.count {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 3:
            if indexPath.row < ingredientsArray.count {
                let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
                    
                    self.ingredientsArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .fade)
                }
                let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
                return swipeActions
            } else {
                return nil
            }
        case 4:
            if indexPath.row < stagesArray.count {
                let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
                    
                    self.stagesArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .fade)
                }
                let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
                return swipeActions
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 3:
            return indexPath.row < ingredientsArray.count ? true: false
        case 4:
            return indexPath.row < stagesArray.count ? true: false
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        switch sourceIndexPath.section {
        case 3:
            if sourceIndexPath.row < ingredientsArray.count {
                let item = ingredientsArray[sourceIndexPath.row]
                ingredientsArray.remove(at: sourceIndexPath.row)
                ingredientsArray.insert(item, at: destinationIndexPath.row)
            } else {
                break
            }
        case 4:
            if sourceIndexPath.row < stagesArray.count {
                let item = stagesArray[sourceIndexPath.row]
                stagesArray.remove(at: sourceIndexPath.row)
                stagesArray.insert(item, at: destinationIndexPath.row)
            } else {
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if ((proposedDestinationIndexPath.section != sourceIndexPath.section) ||
            ((proposedDestinationIndexPath.section == 3) && (proposedDestinationIndexPath.row == ingredientsArray.count)) ||
            ((proposedDestinationIndexPath.section == 4) && (proposedDestinationIndexPath.row == stagesArray.count))) {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch indexPath.section {
        case 3:
            if indexPath.row < ingredientsArray.count {
                return .delete
            }
            return .none
        case 4:
            if indexPath.row < stagesArray.count {
                return .delete
            }
            return .none
        default:
            return .none
        }
    }
}

extension AddViewController: PhotoCellDelegate, StageCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func presentAlert(cell: UITableViewCell?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        delegate = cell as? AddViewControllerDelegate
        alert.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Выбрать фото", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController
            .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Предупреждение", message: "У вас нет камеры",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        delegate?.passImage(image: selectedImage)
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension AddViewController: AddIngredientCellDelegate {
    func addIngredient() {
        ingredientsArray.append("")
        tableView.insertRows(at: [IndexPath(row: ingredientsArray.count - 1, section: 3)], with: .bottom)
    }
}

extension AddViewController: AddStageCellDelegate {
    func addStage() {
        stagesArray.append("")
        tableView.insertRows(at: [IndexPath(row: stagesArray.count - 1, section: 4)], with: .bottom)
    }
}

extension AddViewController: ConfirmCellDelegate {
    func confirmRecipe() {
        dataBaseManager.createRecipe { recipe in
            if let saveNameDelegate = saveNameDelegate {
                saveNameDelegate.saveName(recipe: recipe)
            }
            if let saveImageDelegate = saveImageDelegate {
                saveImageDelegate.saveImage(recipe: recipe)
            }
            if let saveTimeDelegate = saveTimeDelegate {
                saveTimeDelegate.saveTime(recipe: recipe)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConfirmRecipe"), object: nil, userInfo: ["recipe": recipe])
        }
        
        back?()
    }
}
