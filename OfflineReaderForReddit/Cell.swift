//
//  Cell.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-06-15.
//  Copyright © 2020 Mike. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    var subreddit: UILabel!
    var author: UILabel!
    var title: UILabel!
    var thumbnail: UIImageView!
    var score: UILabel!
    var comments: UILabel!
    var timeSince: UILabel!
    var stackView: UIStackView!
    var spacer: UIView!
    var viewController = ViewController()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title = UILabel()
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        title.frame.origin = CGPoint(x: 10, y: 10)
        contentView.addSubview(title)
        
        thumbnail = UIImageView()
        thumbnail.contentMode = .scaleAspectFit
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnail)
        
        score = UILabel()
        score.text = ""
        labelIcon(imageName: "score-black", label: score, width: 10, height: 15)
        
        comments = UILabel()
        comments.text = ""
        labelIcon(imageName: "comments-black", label: comments, width: 16, height: 16)
        
        timeSince = UILabel()
        timeSince.text = ""
        labelIcon(imageName: "time-black", label: timeSince, width: 18, height: 18)
        
        spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        stackView = UIStackView(arrangedSubviews: [score, comments, timeSince, spacer])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        contentView.addSubview(stackView)
        
        if layoutType == "compact" {
            NSLayoutConstraint.activate([
                title.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
                title.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
                title.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                title.trailingAnchor.constraint(equalTo: thumbnail.safeAreaLayoutGuide.leadingAnchor, constant: -10),
                
                thumbnail.heightAnchor.constraint(equalToConstant: 60),
                thumbnail.widthAnchor.constraint(equalToConstant: 60),
                thumbnail.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
                thumbnail.leadingAnchor.constraint(equalTo: title.safeAreaLayoutGuide.trailingAnchor, constant: 10),
                thumbnail.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                
                stackView.topAnchor.constraint(equalTo: title.safeAreaLayoutGuide.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else if layoutType == "large" {
            thumbnail.isHidden = true
            
            NSLayoutConstraint.activate([
                title.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
                title.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
                title.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                title.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                
                stackView.topAnchor.constraint(equalTo: title.safeAreaLayoutGuide.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
            ])
        }

//

        
        // thumbnail.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),

      //  stackView1.heightAnchor.constraint(greaterThanOrEqualToConstant: title.bounds.size.height).isActive = true
       // print("test \(title.bounds.size.height)")
        
      //  title.topAnchor.constraint(equalTo: stackView1.safeAreaLayoutGuide.topAnchor).isActive = true
      //  title.bottomAnchor.constraint(equalTo: stackView1.safeAreaLayoutGuide.bottomAnchor).isActive = true
            //  thumbnail.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)


        
      //  thumbnail.centerYAnchor.constraint(equalTo: stackView1.centerYAnchor).isActive = true
        
        subreddit = UILabel()
        subreddit.numberOfLines = 0
        
        author = UILabel()
        author.numberOfLines = 0
        
//        let stackView2 = UIStackView(arrangedSubviews: [subreddit, author])
//        // stackView2.spacing = 5
//        stackView2.axis = .horizontal
//        // stackView2.distribution = .fillProportionally
//        self.contentView.addSubview(stackView2)
//
//        stackView2.translatesAutoresizingMaskIntoConstraints = false
//        stackView2.topAnchor.constraint(equalTo: stackView1.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        stackView2.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        stackView2.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        stackView2.isLayoutMarginsRelativeArrangement = true
//        stackView2.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func labelIcon(imageName: String, label: UILabel, width: Int, height: Int) {
        let scoreIcon = NSTextAttachment()
        scoreIcon.image = UIImage(named: imageName)
        scoreIcon.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let attachmentString = NSAttributedString(attachment: scoreIcon)
        let mutatedString = NSMutableAttributedString(string: label.text!)
        mutatedString.append(attachmentString)
        label.attributedText = mutatedString
    }
}
