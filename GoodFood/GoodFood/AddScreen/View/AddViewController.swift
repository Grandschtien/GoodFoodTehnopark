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

class AddViewController: UIViewController {
    
    private var navBar = UINavigationBar()
    private var tableView = UITableView()
    weak var delegate: AddViewControllerDelegate?
    private var back: (() -> Void)?
    
//    private let nameCellIdentifier = "NameCell"
//    private let photoCellIdentifier = "PhotoCell"
//    private let timeCellIdentifier = "TimeCell"
    private let ingredientCellIdentifier = "IngredientCell"
    private let stageCellIdentifier = "StageCell"
    
    let imagePicker = UIImagePickerController()
    
    private let sectionsArray = ["Название блюда", "Фото", "Время приготовления", "Ингредиенты", "Приготовление", ""]
    
    private var ingredientsArray = [""]
    private var stagesArray = [""]
    
//    private var tempName: String = ""
//    private var tempPhoto: UIImage
//    private var tempTime: Date
//    private var tempIngredients: [String] = []
//    private var tempStages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupViews()
        
    }
    

    

}

extension AddViewController {
    private func setupViews() {
        view.backgroundColor = .white
        title = "Новый рецепт"
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.tableView.sectionFooterHeight = 100
        tableView.register(UINib(nibName: NameCell.reuseId, bundle: nil), forCellReuseIdentifier: NameCell.reuseId)
        tableView.register(UINib(nibName: PhotoCell.reuseId, bundle: nil), forCellReuseIdentifier: PhotoCell.reuseId)
        tableView.register(UINib(nibName: TimeCell.reuseId, bundle: nil), forCellReuseIdentifier: TimeCell.reuseId)
        tableView.register(UINib(nibName: ConfirmCell.reuseId, bundle: nil), forCellReuseIdentifier: ConfirmCell.reuseId)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
//                                                constant: 0),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
//                                                    constant: 0),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
//                                                    constant: 0),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
//                                                   constant: 0)
//        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBarButton"), style: .plain, target: self, action: #selector(backAction))
    }
    
    @objc
    private func addIngredient() {
        
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: ingredientsCount-1, section: 3)], with: .bottom)
//        tableView.endUpdates()
        
        ingredientsArray.append("")
//        tableView.reloadSections(IndexSet(integer: 3), with: .none)
        self.tableView.reloadData()
    }
    
    @objc
    private func addStage() {
//        stagesCount += 1
        stagesArray.append("")
        self.tableView.reloadData()
    }
    
    @objc
    private func backAction() {
        back?()
    }
    

}

extension AddViewController: UITableViewDelegate {
    
}

extension AddViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return ingredientsArray.count
        case 4:
            return stagesArray.count
        case 5:
            return 1
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            return cell
        case 1:
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell else {
                return UITableViewCell()
            }
            photoCell.delegate = self
            delegate = photoCell
            return photoCell
        case 2:
            let timeCell = tableView.dequeueReusableCell(withIdentifier: TimeCell.reuseId, for: indexPath)
            return timeCell
        case 3:
            return cell
        case 5:
            let confirmCell = tableView.dequeueReusableCell(withIdentifier: ConfirmCell.reuseId, for: indexPath)
            return confirmCell
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionsArray.count == 0 {
            return nil
        }
        return sectionsArray[section]
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let addIngredientButton = UIButton()
        addIngredientButton.setTitle("+ Ингредиент", for: .normal)
        addIngredientButton.titleLabel?.font = .systemFont(ofSize: 20)
        addIngredientButton.setTitleColor(UIColor(named: "mainColor"), for: .normal)
        addIngredientButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
        
        let addStageButton = UIButton()
        addStageButton.setTitle("+ Этап", for: .normal)
        addStageButton.titleLabel?.font = .systemFont(ofSize: 20)
        addStageButton.setTitleColor(UIColor(named: "mainColor"), for: .normal)
        addStageButton.addTarget(self, action: #selector(addStage), for: .touchUpInside)
        
        switch section {
        case 3:
            return addIngredientButton
        case 4:
            return addStageButton
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 60
        case 4:
            return 60
        case 5:
            return 70
        default:
            break
        }
        return 0
    }
}

extension AddViewController: PhotoCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func presentAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            //            self.present(imagePicker, animated: true, completion: nil)
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
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
//        imagePicker.
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        delegate?.passImage(image: selectedImage)
        picker.dismiss(animated: true, completion: nil)
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 1:
//            return 100
//        case 2:
//            return 100
//        case 5:
//            return 70
//        default:
//            break
//        }
//        return 44
//    }
    
}
