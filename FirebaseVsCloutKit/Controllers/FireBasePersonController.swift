//
//  FireBasePersonController.swift
//  FirebaseVsCloutKit
//
//  Created by Jayden Garrick on 9/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase

class FirebasePersonController {
    // MARK: - Properties
    static let shared = FirebasePersonController() ; private init(){}
    var firebasePeople = [FirebasePerson]()
    
    // Firebase reference
    private let databaseReference = Database.database().reference()
    private let storageReference = Storage.storage().reference()
    
    // MARK: - CRUD
    func createPerson(name: String, age: Int, image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { completion(false) ; return }
        
        let storageRef = storageReference.child(name+"Garrick")
        storageRef.putData(imageData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("🔥Error saving image to firebase storage: \(error.localizedDescription)")
                completion(false)
                return
            }
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("🔥Error getting image url from firebase storage: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let imageUrl = url?.absoluteString else { completion(false) ; return }
                print("📸Image Url from firebase: \(imageUrl)")
                let person = FirebasePerson(name: name, age: age, imageStringUrl: imageUrl)
                self.databaseReference.childByAutoId().updateChildValues(person.dictionaryRepresentation)
                completion(true)
            }
        }
    }
    
    func fetchPeople(completion: @escaping (Bool)->Void) {
        let query = databaseReference.queryOrderedByKey()
        query.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            for announcement in snapshot.children.allObjects as! [DataSnapshot] {
                guard let person = FirebasePerson(snapshot: announcement) else { continue }
                self?.firebasePeople.append(person)
            }
            completion(true)
        }
    }
    
    func fetchImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { completion(nil) ; return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("❌Error fetching image for FB User: \(error.localizedDescription)")
            }
            guard let data = data,
                let image = UIImage(data: data) else { completion(nil) ; return }
            completion(image)
            }.resume()
    }
}

