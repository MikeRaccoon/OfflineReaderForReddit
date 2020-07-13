//
//  Post+CoreDataProperties.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-06-20.
//  Copyright © 2020 Mike. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var author: String
    @NSManaged public var name: String
    @NSManaged public var created_utc: Date
    @NSManaged public var id: String
    @NSManaged public var thumbnail_data: Data?
    @NSManaged public var post_hint: String
    @NSManaged public var score: Int32
    @NSManaged public var upvote_ratio: Float
    @NSManaged public var selftext: String
    @NSManaged public var subreddit: String
    @NSManaged public var thumbnail: String
    @NSManaged public var title: String
    @NSManaged public var num_comments: Int32
    @NSManaged public var url: String
    @NSManaged public var url_data: Data?
    @NSManaged public var hls_url: String?
    @NSManaged public var permalink: String
    @NSManaged public var reddit_video_height: Int32
    @NSManaged public var reddit_video_width: Int32
}
