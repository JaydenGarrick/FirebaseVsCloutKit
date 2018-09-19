//
//  CloutKitPersonController.swift
//  FirebaseVsCloutKit
//
//  Created by Jayden Garrick on 9/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CloudKit

class CloutKitPersonController {
    // MARK: - Properties
    static let shared = CloutKitPersonController() ; private init() {} // Singleton
    var ckPeople = [CloutKitPerson]() // Source of Truth
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    func fetchPeople(completion: @escaping (Bool) -> Void) {
        let query = CKQuery(recordType: CloutKitPerson.Constants.cloutKitPerson, predicate: NSPredicate(value: true))
        publicDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            if let error = error {
                print("❌Error fetching CloutKitPeople \(error.localizedDescription)")
                completion(false)
            }
            guard let records = records else { completion(false) ; return }
            self?.ckPeople = records.compactMap{ CloutKitPerson(ckRecord: $0) }
            completion(true)
        }
    }
    
    func createPerson(name: String, age: Int, imageData: Data, completion: @escaping ((Bool) -> Void)) {
        let person = CloutKitPerson(imageData: imageData, name: name, age: age)
        save(person: person) { (success) in
            completion(success)
        }
    }
    
    private func save(person: CloutKitPerson, completion: @escaping (Bool) -> Void) {
        let ckRecordToSave = CKRecord(cloutKitPerson: person)
        publicDatabase.save(ckRecordToSave) { [weak self] (record, error) in
            if let error = error {
                print("❌Error saving \(person.name): \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let record = record,
                let person = CloutKitPerson(ckRecord: record) else { completion(false) ; return }
            self?.ckPeople.append(person)
            completion(true)
        }
    }
    
    func delete(person: CloutKitPerson, completion: @escaping (Bool)->Void) {
        publicDatabase.delete(withRecordID: person.ckRecordId) { [weak self] (recordId, error) in
            if let error = error {
                print("❌Error deleting \(person.name): \(error.localizedDescription)")
            }            
            guard let index = self?.ckPeople.index(of: person) else { return }
            self?.ckPeople.remove(at: index)
            completion(true)
        }
    }
}
