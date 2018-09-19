//
//  PersonTableViewCell.swift
//  FirebaseVsCloutKit
//
//  Created by Jayden Garrick on 9/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var person: Person? { // Dependency
        didSet {
            updateViews()
        }
    }
    
    let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.text = "(Name Label)"
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()

    let ageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "(Age Label)"
        return label
    }()

    // MARK: - Initialization
    override func draw(_ rect: CGRect) {
        setupViews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup
    func updateViews() {
        if let person = person {
            if person.image == nil {
                FirebasePersonController.shared.fetchImage(urlString: person.imageStringUrl) { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.personImageView.image = image
                    }
                }
            }
            personImageView.image = person.image
            nameLabel.text = person.name
            ageLabel.text = "\(person.age)"
        }
    }
    
    func setupViews() {
        // Add Subviews
        self.backgroundView?.backgroundColor = .clear
        backgroundColor = .clear

        addSubview(personImageView)
        addSubview(ageLabel)
        addSubview(nameLabel)
        
        personImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Image View
            personImageView.heightAnchor.constraint(equalToConstant: frame.width - 16),
            personImageView.widthAnchor.constraint(equalToConstant: frame.width - 16),
            personImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            personImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            personImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
            ])
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
            ])
    }

}
