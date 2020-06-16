//
//  ViewController.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-06-11.
//  Copyright © 2020 Mike. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UITableViewController {
    var container: NSPersistentContainer!
    var posts = [Post]()
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Post")
        
        title = "Offline Reader for Reddit"
        container = NSPersistentContainer(name: "Data")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        performSelector(inBackground: #selector(fetchPosts), with: nil)
        loadSavedData()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cell.init(style: .default, reuseIdentifier: "Post")
        let post = posts[indexPath.row]
        
        cell.subreddit.text = post.subreddit
        cell.author.text = "Posted by u/\(post.author)"
        cell.title.text = post.title
        
        let thumbnailType = post.thumbnail

        switch thumbnailType {
        case "link": break
        case "nsfw": break
        case "default": break
        case "self": break

        default:
            DispatchQueue.main.async {
                let imageData = post.image_data!
                cell.thumbnail.image = UIImage(data: imageData)
            }
        }
            
        return cell
    }
    
    // post_hint selftext score thumbnail
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @objc func fetchPosts() {
        //let newestPostDate = getNewestPostDate()
        
        if let data = try? String(contentsOf: URL(string: "https://www.reddit.com/r/all.json?limit=30")!) {
            // SwiftyJSON
            let jsonPosts = JSON(parseJSON: data)
            let jsonPostArray = jsonPosts["data"]["children"].arrayValue
            
            print("Received \(jsonPostArray.count) new posts.")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonPost in jsonPostArray {
                    let post = Post(context: self.container.viewContext)
                    self.configure(post: post, usingJSON: jsonPost)
                }
                
                self.saveContext()
                self.loadSavedData()
            }
        } else {
            print("error")
        }
    }
    
    func configure(post: Post, usingJSON json: JSON) {
        post.author = json["data"]["author"].stringValue
        post.title = json["data"]["title"].stringValue
        post.id = json["data"]["id"].stringValue
        post.created_utc = Date(timeIntervalSince1970: json["data"]["created_utc"].doubleValue)
        post.subreddit = json["data"]["subreddit"].stringValue
        post.post_hint = json["data"]["post_hint"].stringValue
        post.selftext = json["data"]["selftext"].stringValue
        post.score = json["data"]["score"].int32Value
        post.thumbnail = json["data"]["thumbnail"].stringValue
        
        // thumbnail links for image_data
        switch post.thumbnail {
        case "link": break
        case "nsfw": break
        case "default": break
        case "self": break
            
        default:
            guard let url = URL(string: post.thumbnail) else { break }
                        
            if let imageData = try? Data(contentsOf: url) {
                post.image_data = imageData
            }
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request = Post.createFetchRequest()
//        let sort = NSSortDescriptor(key: "created_utc", ascending: false)
//        request.sortDescriptors = [sort]
                
        do {
            posts = try container.viewContext.fetch(request)
            print("Got \(posts.count) posts")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
//
//    func getNewestPostDate() -> String {
//        let formatter = ISO8601DateFormatter()
//
//        let newest = Post.createFetchRequest()
//        let sort = NSSortDescriptor(key: "created_utc", ascending: false)
//        newest.sortDescriptors = [sort]
//        newest.fetchLimit = 1
//
//        if let posts = try? container.viewContext.fetch(newest) {
//            if posts.count > 0 {
//                return formatter.string(from: posts[0].created_utc.addingTimeInterval(1))
//            }
//        }
//
//        return formatter.string(from: Date(timeIntervalSince1970: 0))
//    }
}

