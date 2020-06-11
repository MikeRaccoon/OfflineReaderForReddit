//
//  ViewController.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-06-11.
//  Copyright © 2020 Mike. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var container: NSPersistentContainer!
    var postPredicate: NSPredicate?
    var fetchedResultsController: NSFetchedResultsController<Post>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Offline Reader for Reddit"
        container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        performSelector(inBackground: #selector(fetchPosts), with: nil)
        loadSavedData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let sectionInfo = fetchedResultsController.sections![section]
        //return sectionInfo.numberOfObjects
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath)
        
        let post = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = post.title
        
        return cell
    }
    
    @objc func fetchPosts() {
        //let newestPostDate = getNewestPostDate()
        
        if let data = try? String(contentsOf: URL(string: "https://www.reddit.com/r/all.json")!) {
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
        post.title = json["title"].stringValue
        
        let formatter = ISO8601DateFormatter()
        post.created_utc = formatter.date(from: json["post"]["created_utc"].stringValue) ?? Date()
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = Post.createFetchRequest()
            let sort = NSSortDescriptor(key: "created_utc", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: "created_utc", cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = postPredicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
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

