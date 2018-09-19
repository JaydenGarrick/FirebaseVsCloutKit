//
//  CloudKitPerson.swift
//  FirebaseVsCloutKit
//
//  Created by Jayden Garrick on 9/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

protocol Person {
    var name: String { get set }
    var age: Int { get set }
    var image: UIImage? { get set }
    var imageStringUrl: String { get set }
}

struct CloutKitPerson: Equatable, Person {
    var imageStringUrl: String = ""
    
    // MARK: - Constants for dictionary
    enum Constants {
        static let imageData = "imageData"
        static let name = "name"
        static let age = "age"
        static let ckRecordId = "ckRecordId"
        static let cloutKitPerson = "CloutKitPerson"
    }
    
    // MARK: - Properties
    var imageData: Data
    var name: String
    var age: Int
    var ckRecordId: CKRecord.ID
    var image: UIImage?
    
    // Temp URL For image asset
    fileprivate var temporaryPhotoURL: URL {
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        try? imageData.write(to: fileURL, options: [.atomic])
        return fileURL
    }

    // MARK: - Initialization
    init(imageData: Data, name: String, age: Int, ckRecordId: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.imageData = imageData
        self.name = name
        self.age = age
        self.ckRecordId = ckRecordId
        self.image = UIImage(data: imageData)
    }
    
    init?(ckRecord: CKRecord) {
        guard let imageAsset = ckRecord[Constants.imageData] as? CKAsset,
            let name = ckRecord[Constants.name] as? String,
            let age = ckRecord[Constants.age] as? Int else { return nil }

        let imageData = try! Data(contentsOf: imageAsset.fileURL)
        
        self.imageData = imageData
        self.name = name
        self.age = age
        self.ckRecordId = ckRecord.recordID
        self.image = UIImage(data: imageData)
    }
    
}


extension CKRecord {
    // MARK: - Convenince Initializer for CKRecord
    convenience init(cloutKitPerson: CloutKitPerson) {
        let imageAsset = CKAsset(fileURL: cloutKitPerson.temporaryPhotoURL)
        self.init(recordType: CloutKitPerson.Constants.cloutKitPerson, recordID: cloutKitPerson.ckRecordId)
        self.setValue(imageAsset, forKey: CloutKitPerson.Constants.imageData)
        self.setValue(cloutKitPerson.name, forKey: CloutKitPerson.Constants.name)
        self.setValue(cloutKitPerson.age, forKey: CloutKitPerson.Constants.age)
    }
}
