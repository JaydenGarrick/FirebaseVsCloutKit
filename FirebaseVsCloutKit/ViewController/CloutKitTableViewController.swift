//
//  CloutKitTableViewController.swift
//  FirebaseVsCloutKit
//
//  Created by Jayden Garrick on 9/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CloutKitTableViewController: UITableViewController {
    // MARK: - Properties
    var people = CloutKitPersonController.shared.ckPeople
    let reuseIdentifier = "CellID"
    
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let barButtonItem = UIBarButtonItem(title: "New Person", style: .plain, target: self, action: #selector(toCreatePerson))
        navigationItem.rightBarButtonItem = barButtonItem
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PersonTableViewCell
        cell.person = people[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 775
    }
    
    // MARK: - Actions
    func fetch() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        CloutKitPersonController.shared.fetchPeople { [weak self] (success) in
            DispatchQueue.main.async {
                if success {
                    self?.people = CloutKitPersonController.shared.ckPeople
                    self?.tableView.reloadData()
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    @objc func toCreatePerson() {
//        navigationController?.pushViewController(CreatePersonViewController(), animated: true)
        let navigationController = UINavigationController(rootViewController: CreatePersonViewController())
        present(navigationController, animated: true)
    }
    
    
}
