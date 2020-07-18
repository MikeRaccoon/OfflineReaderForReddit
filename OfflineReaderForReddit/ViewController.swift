//
//  ViewController.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-06-11.
//  Copyright © 2020 Mike. All rights reserved.
//

import CoreData
import UIKit
import AVKit
import AVFoundation

enum layoutTypes {
    case large
    case compact
}

var layoutType = layoutTypes.large

//var layoutType = "large"
var offlineMode = false
let testSub = "explainlikeimfive"
let postsLimit = 10
var looper: AVPlayerLooper?
var playerLooper: NSObject?
var playerLayer:AVPlayerLayer!
var queuePlayer: AVQueuePlayer?
var cellWidth: CGFloat!

class ViewController: UITableViewController {
    var container: NSPersistentContainer!
    var posts = [Post]()
    let dispatchGroup = DispatchGroup()
    var isPlayingVideo = false
    let spinner = SpinnerViewController()
    
    enum sortTypes: String {
        case best = "/best"
        case hot = "/hot"
        case new = "/new"
        case top = "/top"
        case controversial = "/controversial"
        case rising = "/rising"
    }
    
    var sortType = sortTypes.hot
    
    enum sortDates: String {
        case hour = "/?t=hour"
        case day = "/?t=day"
        case week = "/?t=week"
        case month = "/?t=month"
        case year = "/?t=year"
        case all = "/?t=all"
    }
    var sortByDate = ""
    var shareLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Post")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        cellWidth = tableView.bounds.width
        
        title = "Offline Reader for Reddit"
        
        let layoutBtn = UIBarButtonItem(title: "view", style: .plain, target: self, action: #selector(layoutTypeSwitch))
        let sortBtn = UIBarButtonItem(title: "sort", style: .plain, target: self, action: #selector(sortPosts))

        navigationItem.rightBarButtonItems = [sortBtn, layoutBtn]
        
        container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
            //createSpinnerView()
        
        if !offlineMode {
            performSelector(inBackground: #selector(fetchPosts), with: nil)
        }
        
        //spinner.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        //self.spinner.frame = CGRect(x:0, y:0, width:30, height:30)
      //  self.spinner.startAnimating()
    }
    
    func sortProcessing(ascending: Bool) {
        spinner.view.isHidden = false
        
        if !offlineMode {
            performSelector(inBackground: #selector(fetchPosts), with: nil)
        } else {
            self.loadSavedData(ascending: ascending)
        }
    }
    
    @objc func sortPosts() {
        let ac = UIAlertController(title: "Sorting by", message: nil, preferredStyle: .alert)
        
        let sortBest = UIAlertAction(title: "Best", style: .default) { _ in
            self.sortType = sortTypes.best
            self.sortProcessing(ascending: false)
        }
        ac.addAction(sortBest)
        
        let sortHot = UIAlertAction(title: "Hot", style: .default) { _ in
            self.sortType = sortTypes.hot
            self.sortProcessing(ascending: false)
        }
        ac.addAction(sortHot)
        
        let sortNew = UIAlertAction(title: "New", style: .default) { _ in
            self.sortType = sortTypes.new
            self.sortProcessing(ascending: false)
        }
        ac.addAction(sortNew)
        
        let sortTop = UIAlertAction(title: "Top", style: .default) { _ in
            self.sortType = sortTypes.top
            self.setSortDate(ascending: false)
        }
        ac.addAction(sortTop)
        
        let sortControversial = UIAlertAction(title: "Controversial", style: .default) { _ in
            self.sortType = sortTypes.controversial
            self.setSortDate(ascending: true)
        }
        ac.addAction(sortControversial)
   
        let sortRising = UIAlertAction(title: "Rising", style: .default) { _ in
            self.sortType = sortTypes.rising
            self.sortProcessing(ascending: false)
        }
        ac.addAction(sortRising)
        
        switch sortType {
        case .best: sortBest.setValue(UIColor.red, forKey: "titleTextColor")
        case .hot: sortHot.setValue(UIColor.red, forKey: "titleTextColor")
        case .new: sortNew.setValue(UIColor.red, forKey: "titleTextColor")
        case .top: sortTop.setValue(UIColor.red, forKey: "titleTextColor")
        case .controversial: sortControversial.setValue(UIColor.red, forKey: "titleTextColor")
        case .rising: sortRising.setValue(UIColor.red, forKey: "titleTextColor")
        }
        
        present(ac, animated: true)
    }
    
    func setSortDate(ascending: Bool) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
      
        let hour = UIAlertAction(title: "This hour", style: .default) { _ in
            self.sortByDate = sortDates.hour.rawValue
            self.sortProcessing(ascending: ascending)
        }
        ac.addAction(hour)
        
        let day = UIAlertAction(title: "Today", style: .default) { _ in
            self.sortByDate = sortDates.day.rawValue
            self.sortProcessing(ascending: ascending)
        }
        ac.addAction(day)
        
        let week = UIAlertAction(title: "This week", style: .default) { _ in
            self.sortByDate = sortDates.week.rawValue
            self.sortProcessing(ascending: ascending)
        }
        ac.addAction(week)
        
        let month = UIAlertAction(title: "This month", style: .default) { _ in
            self.sortByDate = sortDates.month.rawValue
            self.sortProcessing(ascending: ascending)
        }
        ac.addAction(month)
        
        let year = UIAlertAction(title: "This year", style: .default) { _ in
            self.sortByDate = sortDates.year.rawValue
            self.sortProcessing(ascending: ascending)
        }
        ac.addAction(year)
        
        let all = UIAlertAction(title: "All time", style: .default) { _ in
            self.sortByDate = sortDates.all.rawValue
            self.sortProcessing(ascending: ascending)
        }
        ac.addAction(all)
        
        present(ac, animated: true)
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

//        DispatchQueue.main.async {
//            child.willMove(toParent: nil)
//            child.view.removeFromSuperview()
//            child.removeFromParent()
//        }
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
        
        // Share button
       // cell.share.text = post.url
        let tap = UITapGestureRecognizer(target: self, action: #selector(share))
        cell.share.addGestureRecognizer(tap)
        
//        if let indexes = tableView.indexPathsForVisibleRows {
//            for index in indexes {
//                if index.row == 0 {
//                    print(tableView.visibleCells)
//                }
//            }
//        }


        
//        if post.over_18 {
//            DispatchQueue.main.async {
//                cell.thumbnail.image = UIImage(named: "nsfw")
//            }
//        }
        return cell
    }
    
    @objc func share(sender: UILabel) {
        
        print(sender.description)
//        var url = [URL(string: shareLink)!]
//
//        let ac = UIActivityViewController(activityItems: url, applicationActivities: nil)
//        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let activeCell = cell as? Cell else { return }
        
        if activeCell.postHint == "hosted:video" && !isPlayingVideo {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                activeCell.player.play()
                self.isPlayingVideo = true
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let inactiveCell = cell as? Cell else { return }
        
        if inactiveCell.postHint == "hosted:video" && isPlayingVideo {
            DispatchQueue.main.async() {
                inactiveCell.player.pause()
                self.isPlayingVideo = false
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Comments") as? CommentsViewController {
            vc.post = posts[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func fetchPosts() {
        //let newestPostDate = getNewestPostDate()
        let url = "https://www.reddit.com/r/\(testSub + sortType.rawValue + sortByDate).json?limit=\(postsLimit)"
        
        if let data = try? String(contentsOf: URL(string: url)!) {
            // SwiftyJSON
            let jsonPosts = JSON(parseJSON: data)
            let jsonPostArray = jsonPosts["data"]["children"].arrayValue
            
            print("Received \(jsonPostArray.count) new posts.")
            
            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                for jsonPost in jsonPostArray {
                    let post = Post(context: self.container.viewContext)
                    self.configure(post: post, usingJSON: jsonPost)
                }
                
                DispatchQueue.main.async {
                    self.spinner.view.isHidden = false
                    self.saveContext()
                    self.loadSavedData(ascending: false)
                }
            }
        } else {
            print("error")
        }
    }
    
    func configure(post: Post, usingJSON json: JSON) {
        post.author = json["data"]["author"].stringValue
        post.title = json["data"]["title"].stringValue
        post.id = json["data"]["id"].stringValue
        post.name = json["data"]["name"].stringValue
        post.created_utc = Date(timeIntervalSince1970: json["data"]["created_utc"].doubleValue)
        post.subreddit = json["data"]["subreddit"].stringValue
        post.post_hint = json["data"]["post_hint"].stringValue
        post.selftext = json["data"]["selftext"].stringValue
        post.score = json["data"]["score"].int32Value
        post.upvote_ratio = json["data"]["upvote_ratio"].floatValue
        post.num_comments = json["data"]["num_comments"].int32Value
        post.thumbnail = json["data"]["thumbnail"].stringValue
        post.url = json["data"]["url"].stringValue
        post.hls_url = json["data"]["media"]["reddit_video"]["hls_url"].stringValue
        post.permalink = json["data"]["permalink"].stringValue
        post.reddit_video_height = json["data"]["media"]["reddit_video"]["height"].int32Value
        post.reddit_video_width = json["data"]["media"]["reddit_video"]["width"].int32Value
        
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
    
    func loadSavedData(ascending: Bool) {
        let request = Post.createFetchRequest()

        var sortValue: String
        
        switch sortType {
        case .best: sortValue = "upvote_ratio"
        case .hot: sortValue = "score"
        case .new: sortValue = "created_utc"
        case .top: sortValue = "score"
        case .controversial: sortValue = "upvote_ratio"
        case .rising: sortValue = "score"
        }
        
        if sortType == .hot {
            let sort1 = NSSortDescriptor(key: sortValue, ascending: ascending)
            let sort2 = NSSortDescriptor(key: "created_utc", ascending: ascending)
            request.sortDescriptors = [sort1, sort2]
        } else {
            let sort = NSSortDescriptor(key: sortValue, ascending: ascending)
            request.sortDescriptors = [sort]
        }
        
        do {
            posts = try container.viewContext.fetch(request)
            print("Got \(posts.count) posts")
            tableView.reloadData()
            spinner.view.isHidden = true
        } catch {
            print("Fetch failed")
        }
    }
    
    @objc func layoutTypeSwitch() {
        if layoutType == layoutTypes.compact {
            layoutType = layoutTypes.large
        } else {
            layoutType = layoutTypes.compact
        }
        
        tableView.reloadData()
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

func aspectRatio(width: CGFloat, height: CGFloat) -> CGFloat {
    let aspect = cellWidth / (width / height)
    
    return aspect
}
