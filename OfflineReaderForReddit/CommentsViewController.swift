//
//  CommentsViewController.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-07-01.
//  Copyright © 2020 Mike. All rights reserved.
//

import UIKit
import AVKit

class CommentsViewController: UITableViewController {
    var post = Post()
//
//    required init?(coder aDecoder: NSCoder) {
//        self.post = Post()
//        super.init(coder: aDecoder)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellWidth = tableView.bounds.width
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Post")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = Cell.init(style: .default, reuseIdentifier: "Post")
            
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
            
  
            return cell
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
