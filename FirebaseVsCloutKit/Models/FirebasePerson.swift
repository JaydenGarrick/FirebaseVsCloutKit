//
//  FirebasePerson.swift
//  FirebaseVsCloutKit
//
//  Created by Jayden Garrick on 9/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import Firebase


struct FirebasePerson: Person {
    
    enum Constants {
        static let name = "name"
        static let age = "age"
        static let imageStringUrl = "imageStringUrl"
    }
    
    var name: String
    var age: Int
    var image: UIImage?
    var imageStringUrl: String
    var dictionaryRepresentation: [String: Any] {
        return [
            Constants.name : self.name,
            Constants.age : self.age,
            Constants.imageStringUrl : self.imageStringUrl
        ]
    }
    
    init(name: String, age: Int, imageStringUrl: String)  {
        self.name = name
        self.age = age
        self.imageStringUrl = imageStringUrl
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dictionary = snapshot.value as? [String: Any] else { return nil}
        guard let name = dictionary["name"] as? String,
            let age = dictionary[Constants.age] as? Int,
            let imageStringUrl = dictionary[Constants.imageStringUrl] as? String else { return nil }
        
        self.init(name: name, age: age, imageStringUrl: imageStringUrl)
    }
}
