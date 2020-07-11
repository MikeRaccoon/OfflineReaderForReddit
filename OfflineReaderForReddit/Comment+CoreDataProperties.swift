//
//  Comment+CoreDataProperties.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-07-10.
//  Copyright © 2020 Mike. All rights reserved.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var id: String?
    @NSManaged public var link_id: String? 
    @NSManaged public var score: Int32
    @NSManaged public var author: String?
    @NSManaged public var body: String?
    @NSManaged public var created_utc: Date?
    @NSManaged public var posts: Post?
}
