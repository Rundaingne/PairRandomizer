//
//  Entity.swift
//  PairRandomizer
//
//  Created by Brooke Kumpunen on 4/19/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation
import CloudKit

//What properties does an Entity need to have? Hmmmm...

class Entity {
    
    var name: String
    let bodyText: String?
    let timestamp: Date?
    var grouping: String
    let recordID: CKRecord.ID
    
    init(name: String, bodyText: String? = nil, timestamp: Date? = nil, grouping: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.grouping = grouping
        self.recordID = recordID
    }
    
    //Need an init to convert from record to entity. Which I need a struct of constants for this.
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Entity.EntityConstants.nameKey] as? String,
        let bodyText = ckRecord[Entity.EntityConstants.bodyTextKey] as? String?,
        let timestamp = ckRecord[Entity.EntityConstants.timestampKey] as? Date?,
            let grouping = ckRecord[Entity.EntityConstants.groupingKey] as? String else {return nil}
        self.init(name: name, bodyText: bodyText, timestamp: timestamp, grouping: grouping, recordID: ckRecord.recordID)
    }
    
    enum EntityConstants {
        static let recordType = "Entity"
        static let nameKey = "name"
        static let bodyTextKey = "bodyText"
        static let timestampKey = "timestamp"
        static let groupingKey = "grouping"
    }
}

//I'll need this for swipe to delete functionality.
extension Entity: Equatable {
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.name == rhs.name && lhs.bodyText == rhs.bodyText && lhs.timestamp == rhs.timestamp && lhs.grouping == rhs.grouping
    }
}


extension CKRecord {
    convenience init(entity: Entity) {
        self.init(recordType: Entity.EntityConstants.recordType, recordID: entity.recordID)
        self.setValue( entity.name, forKey: Entity.EntityConstants.nameKey)
        self.setValue( entity.bodyText, forKey: Entity.EntityConstants.bodyTextKey)
        self.setValue( entity.timestamp, forKey: Entity.EntityConstants.timestampKey)
        self.setValue( entity.grouping, forKey: Entity.EntityConstants.groupingKey)
    }
}
