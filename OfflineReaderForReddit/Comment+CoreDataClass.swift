//
//  Comment+CoreDataClass.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-07-07.
//  Copyright © 2020 Mike. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Comment)
public class Comment: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
