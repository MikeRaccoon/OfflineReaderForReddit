//
//  Post+CoreDataProperties.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-06-14.
//  Copyright © 2020 Mike. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var created_utc: Date
    @NSManaged public var title: String
    @NSManaged public var id: String
    @NSManaged public var subreddit: String
    @NSManaged public var author: String

}
