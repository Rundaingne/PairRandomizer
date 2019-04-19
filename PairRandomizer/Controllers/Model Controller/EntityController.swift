//
//  EntityController.swift
//  PairRandomizer
//
//  Created by Brooke Kumpunen on 4/19/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation
import CloudKit

class EntityController {
    
    static let shared = EntityController()
    private init() {}
    
    //SoT and properties, if necessary.
    var entities: [Entity] = []
    //It is from this array that we will pull our data. We'll use the shuffle method here.
    
    //create and delete functions, with respect to CloudKit.
    func createEntity(name: String, grouping: String, completion: @escaping (Entity?) -> Void) {
        //All we gotta do is call our save function in here. Nifty.
        saveEntity(name: name, grouping: grouping, completion: completion)
    }
    
    func deleteEntity(entity: Entity, completion: @escaping (Entity?) -> Void) {
        guard let index = entities.firstIndex(of: entity) else {completion(nil); return}
        entities.remove(at: index)
        CKContainer.default().publicCloudDatabase.delete(withRecordID: entity.recordID) { (ckRecord, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
        }
    }
    
    func saveEntity(name: String, grouping: String, completion: @escaping (Entity?) -> Void) {
        let entity = Entity(name: name, grouping: grouping)
        self.entities.append(entity)
        let record = CKRecord(entity: entity)
        CKContainer.default().publicCloudDatabase.save(record) { (ckRecord, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let ckRecord = ckRecord,
            let entity = Entity(ckRecord: ckRecord) else {completion(nil); return}
            completion(entity)
        }
    }
    
    func fetchEntities(completion: @escaping ([Entity]?) -> Void) {
        //Needs a predicate, query, and then the .perform function.
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Entity.EntityConstants.recordType, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                guard let records = records else {completion(nil); return}
                let entities = records.compactMap{Entity(ckRecord: $0)}
                self.entities = entities
                completion(entities)
            }
        }
    }
    
}
