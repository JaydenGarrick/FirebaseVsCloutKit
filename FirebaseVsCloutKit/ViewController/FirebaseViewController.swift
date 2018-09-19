//
//  FirebaseTableViewController.swift
//  FirebaseVsCloutKit
//
//  Created by Jayden Garrick on 9/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class FirebaseViewController: UITableViewController {
    // MARK: - Properties
    let reuseIdentifier = "CellID"
    
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    // MARK: - Setup
    
    // MARK: - Actions
    func reload() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FirebasePersonController.shared.fetchPeople { (success) in
            if success {
                self.tableView.reloadData()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}

// MARK: - TableViewDelegate and DataSource
extension FirebaseViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebasePersonController.shared.firebasePeople.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PersonTableViewCell
        cell.person = FirebasePersonController.shared.firebasePeople[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 775
    }
    
}
