//
//  ViewController.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-06-11.
//  Copyright © 2020 Mike. All rights reserved.
//

import CoreData
import UIKit
//import AVKit

var layoutType = "large"
var offlineMode = true

class ViewController: UITableViewController {
    var container: NSPersistentContainer!
    var posts = [Post]()
    let dispatchGroup = DispatchGroup()
    var cellHeight: CGFloat = 80

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Post")
        //tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        title = "Offline Reader for Reddit"
        
        let layoutBtn = UIBarButtonItem(title: "view", style: .plain, target: self, action: #selector(layoutSwitch))
        navigationItem.rightBarButtonItem = layoutBtn
        
        container = NSPersistentContainer(name: "Data")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        if !offlineMode {
            performSelector(inBackground: #selector(fetchPosts), with: nil)
            
        }
        
        loadSavedData()
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
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.subreddit.text = "r/\(post.subreddit)"
        cell.author.text = "Posted by u/\(post.author)"
        cell.title.text = post.title
        cell.score.text = "\(cell.score.text ?? "") \(post.score)"
        cell.comments.text = "\(cell.comments.text ?? "") \(post.num_comments)"
        cell.timeSince.text = "\(cell.timeSince.text ?? "") \(post.created_utc.timeSince())"

        // post thumbnails
        if post.thumbnail.contains("http") {
            DispatchQueue.main.async {
                let imageData = post.thumbnail_data!
                cell.thumbnail.image = UIImage(data: imageData)
            }
        }
        
        if post.thumbnail == "link" {
            DispatchQueue.main.async {
                cell.thumbnail.image = UIImage(named: "link")
            }
        }
        
        if post.thumbnail == "default" || post.thumbnail == "self" || post.thumbnail == "" {
            DispatchQueue.main.async {
                cell.thumbnail.image = UIImage(named: "text")
            }
        }
        
        // post image
        if post.post_hint == "image" {
            //  DispatchQueue.main.async {
            if let imageData = post.url_data {
                //   var image = cell.postImage.image
                cell.postImage.image = UIImage(data: imageData)
                
                let cellWidth = cell.bounds.width
                let imageWidth = cell.postImage.image!.size.width
                let imageHeight = cell.postImage.image!.size.height
                let aspect = cellWidth / (imageWidth / imageHeight)
                print(aspect)
                
                cell.postImage.heightAnchor.constraint(equalToConstant: aspect).isActive = true
                
                
                // self.view.setNeedsLayout()
                // print(cell.postImage.image?.size.height)
            }
            //   }
        }
        
//        if post.post_hint == "hosted:video" {
//            DispatchQueue.main.async {
//                let video = post.url_data!
               // let video = NSData(contentsOf: URL)
             //   cell.thumbnail.image = UIImage(data: imageData)
                
//                let player = AVPlayer(url: <#T##URL#>)
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.frame = videoView.bounds
//                videoView.layer.addSublayer(playerLayer)
//                player.play()
//            }
//        }
        
//        if post.title.contains("There") {
//            print("123 \(post.thumbnail)")
//        }
        
//        if post.over_18 {
//            DispatchQueue.main.async {
//                cell.thumbnail.image = UIImage(named: "nsfw")
//            }
//        }
    

        return cell
    }

//    func setImage(image: UIImage) {
//        let aspect = image.size.width / image.size.height
//
//        aspectConstraint = NSLayoutConstraint(item: postedImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: postedImageView, attribute: NSLayoutAttribute.Height, multiplier: aspect, constant: 0.0)
//
//        postedImageView.image = image
//    }
    
    // post_hint selftext url score
    
//        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
//            return cellHeight
//        }
    
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
        post.num_comments = json["data"]["num_comments"].int32Value
        post.thumbnail = json["data"]["thumbnail"].stringValue
        post.url = json["data"]["url"].stringValue
        
        if post.thumbnail.contains("http") {
            let url = URL(string: post.thumbnail)
                        
            if let imageData = try? Data(contentsOf: url!) {
                post.thumbnail_data = imageData
            }
        }
        
        if post.post_hint == "image" {
            let url = URL(string: post.url)

            if let imageData = try? Data(contentsOf: url!) {
                post.url_data = imageData
            }
        }
        
//        if post.post_hint == "hosted:video" {
//            let url = URL(string: post.url)
//
//            if let videoData = try? Data(contentsOf: url!) {
//                post.url_data = videoData
//            }
//        }
        
        if post.post_hint == "rich:video" {

        }
        
        if post.post_hint == "link" {

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
    
    @objc func layoutSwitch() {
        if layoutType == "compact" {
            layoutType = "large"
        } else {
            layoutType = "compact"
        }
        
        tableView.reloadData()
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

extension Date {

    func timeSince() -> String {
        let fromDate = self
        let toDate = Date()

        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0 {
            return "\(interval)" + "y"
        }

        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0 {
            return "\(interval)" + "mo"
        }

        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0 {
            return "\(interval)" + "d"
        }

        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return "\(interval)" + "h"
        }

        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
           return "\(interval)" + "m"
        }
        
        if let interval = Calendar.current.dateComponents([.second], from: fromDate, to: toDate).second, interval > 0 {
           return "\(interval)" + "sec"
        }

        return "now"
    }
}
