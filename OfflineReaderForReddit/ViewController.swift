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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath)
        
        let post = posts[indexPath.row]
        cell.textLabel!.text = post.title
        
        let postInfo = UIStackView()
        postInfo.translatesAutoresizingMaskIntoConstraints = false
        postInfo.spacing = 5

                postInfo.bounds = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.size.width - 50, height: cell.bounds.size.height)
        cell.contentView.addSubview(postInfo)
        
        postInfo.topAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        postInfo.leadingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        postInfo.trailingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        postInfo.axis = .horizontal
        
        let subreddit = UILabel()
        subreddit.text = post.subreddit
        postInfo.addArrangedSubview(subreddit)
        
        let author = UILabel()
        author.text = "Posted by u/\(post.author)"
        postInfo.addArrangedSubview(author)
        
        let title = UILabel()
        title.text = post.title
        cell.contentView.addSubview(title)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @objc func fetchPosts() {
        //let newestPostDate = getNewestPostDate()
        
        if let data = try? String(contentsOf: URL(string: "https://www.reddit.com/r/all.json?limit=100")!) {
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
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }
    
    func configure(post: Post, usingJSON json: JSON) {
        post.author = json["data"]["author"].stringValue
        post.title = json["data"]["title"].stringValue
        post.id = json["data"]["id"].stringValue
        post.created_utc = Date(timeIntervalSince1970: json["data"]["created_utc"].doubleValue)
        post.subreddit = json["data"]["subreddit"].stringValue
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

