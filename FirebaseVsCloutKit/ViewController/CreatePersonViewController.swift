//
//  CreatePersonViewController.swift
//  FirebaseVsCloutKit
//
//  Created by Jayden Garrick on 9/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CreatePersonViewController: UIViewController {
    // MARK: - Properties
    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Add Image", for: .normal)
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), for: .normal)
        button.setTitle("Save Person to ☁️CloutKit☁️ and 🔥Firebase🔥", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "Enter Name..."
        textField.borderStyle = UITextField.BorderStyle.line
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8988928298)
        return textField
    }()
    
    let ageTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "Enter Age..."
        textField.borderStyle = UITextField.BorderStyle.line
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8988928298)
        return textField
    }()
    
    var selectedImage: UIImage?
    let pickerController = UIImagePickerController()
    
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = dismissButton
        setupViews()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Setup
    func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        // Add Subviews
        view.addSubview(addImageButton)
        view.addSubview(ageTextField)
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
        
        // Constraints
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 225),
            addImageButton.heightAnchor.constraint(equalToConstant: 250),
            addImageButton.widthAnchor.constraint(equalToConstant: 250)
            ])
        
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 50),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            
            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            ageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ageTextField.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
            
            ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 50)
            ])
    }
    
    // MARK: - Actions
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let name = nameTextField.text, let age = Int(ageTextField.text ?? ""), let image = selectedImage else { self.presentAlertWithOkayAction(presenter: self, "Missing Fields", nil) ; return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { fatalError("Couldn't get image Data") }
        
        let cloudKitCurrentTime = CFAbsoluteTimeGetCurrent()
        CloutKitPersonController.shared.createPerson(name: name, age: age, imageData: imageData) { (success) in
            DispatchQueue.main.async {
                if success {
                    print("☁️CloudKit took \((CFAbsoluteTimeGetCurrent() - cloudKitCurrentTime)) seconds to create a person")
                    let firebaseCurrentTime = CFAbsoluteTimeGetCurrent()
                    FirebasePersonController.shared.createPerson(name: name, age: age, image: image, completion: { (success) in
                        if success {
                            print("🔥Firebase took \((CFAbsoluteTimeGetCurrent() - firebaseCurrentTime)) seconds to create a person")
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.dismiss(animated: true)
                        }
                    })
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
}

extension CreatePersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func addImageButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        addImageButton.setBackgroundImage(image, for: .normal)
        selectedImage = image
        pickerController.dismiss(animated: true)
    }
    
}
