//
//  CommentsViewController.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-07-01.
//  Copyright © 2020 Mike. All rights reserved.
//

import CoreData
import UIKit
import AVKit

class CommentsViewController: UITableViewController {
    var container: NSPersistentContainer!
    var post = Post()
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellWidth = tableView.bounds.width
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostComment")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
                
        if !offlineMode {
            performSelector(inBackground: #selector(fetchComments), with: nil)
        } else {
            loadSavedData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cell.init(style: .default, reuseIdentifier: "PostComment")
        let comment = comments[indexPath.row]
        
        if indexPath.row == 0 {
            cell.subreddit.text = "r/\(post.subreddit)"
            cell.author.text = "u/\(post.author)"
            cell.title.text = post.title
            cell.score.text = "\(cell.score.text ?? "") \(post.score)"
            cell.comments.text = "\(cell.comments.text ?? "") \(post.num_comments)"
            cell.timeSince.text = "\(cell.timeSince.text ?? "") \(post.created_utc.timeSince())"
            cell.selfText.text = post.selftext
            cell.postHint = post.post_hint
            
            // post thumbnails
            if post.thumbnail.contains("http") {
                DispatchQueue.main.async {
                    let imageData = self.post.thumbnail_data!
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
                if let imageData = post.url_data {
                    cell.postImage.image = UIImage(data: imageData)
                    
                    let aspect = aspectRatio(width: cell.postImage.image!.size.width, height: cell.postImage.image!.size.height)
                    
                    cell.postImage.heightAnchor.constraint(equalToConstant: aspect).isActive = true
                    cell.stackView.topAnchor.constraint(equalTo: cell.postImage.safeAreaLayoutGuide.bottomAnchor).isActive = true
                }
            }
            
            // post video
            if post.post_hint == "hosted:video" {
                
                if let videoUrl = URL(string: post.hls_url!) {
                    cell.player = AVPlayer(url: videoUrl)
                    cell.player.automaticallyWaitsToMinimizeStalling = true
                    
                    let playerLayer = AVPlayerLayer(player: cell.player)
                    let aspect = aspectRatio(width: CGFloat(post.reddit_video_width), height: CGFloat(post.reddit_video_height))
                    
                    playerLayer.frame.size.width = cellWidth
                    playerLayer.frame.size.height = aspect
                    cell.videoView.layer.addSublayer(playerLayer)
                    
                    cell.videoView.heightAnchor.constraint(equalToConstant: aspect).isActive = true
                    cell.stackView.topAnchor.constraint(equalTo: cell.videoView.safeAreaLayoutGuide.bottomAnchor).isActive = true
                    
                }
            }
        } else {
            cell.subreddit.isHidden = true
            cell.comments.isHidden = true
            cell.timeSince.isHidden = true
            //cell.selfText.text = comment.body
            cell.selfText.text = "(name: \(comment.name) parent_id: \(comment.parent_id) body: \(comment.body)"

            cell.score.text = "\(cell.score.text ?? "") \(comment.score)"
            cell.author.text = "u/\(comment.author ?? "")"
        }
        
        return cell
    }
    
    @objc func fetchComments() {
        if let data = try? String(contentsOf: URL(string: "https://www.reddit.com\(post.permalink).json")!) {
            // SwiftyJSON
            let jsonComments = JSON(parseJSON: data)
            let jsonCommentArray = jsonComments[1]["data"]["children"].arrayValue
            
            print("Received \(jsonCommentArray.count) new comments.")
            
            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                self.fetchAllComments(jsonArray: jsonCommentArray)
                
                DispatchQueue.main.async {
                     //self.spinner.view.isHidden = false
                     self.saveContext()
                     self.loadSavedData()
                }
            }
        } else {
            print("error")
        }
    }
    
    func fetchAllComments(jsonArray: [JSON]) {
        for jsonComment in jsonArray {
            let comment = Comment(context: self.container.viewContext)
            configure(comment: comment, usingJSON: jsonComment)
            
            let nextLevel = jsonComment["data"]["replies"]["data"]["children"].arrayValue

            if nextLevel.count > 0 {
                fetchAllComments(jsonArray: nextLevel)
            }
        }
    }
    
    func configure(comment: Comment, usingJSON json: JSON) {
        comment.id = json["data"]["id"].stringValue
        comment.link_id = json["data"]["link_id"].stringValue
        comment.score = json["data"]["score"].int32Value
        comment.author = json["data"]["author"].stringValue
        comment.body = json["data"]["body"].stringValue
        comment.created_utc = Date(timeIntervalSince1970: json["data"]["created_utc"].doubleValue)
        comment.name = json["data"]["name"].stringValue
        comment.parent_id = json["data"]["parent_id"].stringValue
                

        //var newComment: Comment!

        // see if this comment exists already
  //      let commentRequest = Comment.createFetchRequest()
    //    commentRequest.predicate = NSPredicate(format: "id == %@", comment.id)

      //  if let comments = try? container.viewContext.fetch(commentRequest) {
        //    if comments.count > 0 {
                // we have this comment already
               // print(comments.count)
              //  newComment = comments[0]
                // mainManagedObjectContext.deleteObject(x)
          //  }
        //}
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
        let request = Comment.createFetchRequest()
      //  request.predicate = NSPredicate(format: "link_id == %@", post.name)
        //request.returnsDistinctResults = true
    
        //request.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let predicateLinkId = NSPredicate(format: "link_id == %@", post.name) // filters comments for particular post
        let predicateParentId = NSPredicate(format: "parent_id == link_id") // filters 1st level
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateLinkId])

        
        //let sort = NSSortDescriptor(key: "score", ascending: false)
        let name = NSSortDescriptor(key: "name", ascending: false)
        let parent_id = NSSortDescriptor(key: "parent_id", ascending: false)

        request.sortDescriptors = [name, parent_id]
        
        do {
            comments = try container.viewContext.fetch(request)
            print("Got \(comments.count) comments")
            tableView.reloadData()
         //   spinner.view.isHidden = true
        } catch {
            print("Fetch failed")
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
