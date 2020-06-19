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
    var stackView1: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title = UILabel()
        title.numberOfLines = 0
        title.setContentHuggingPriority(.required, for: .vertical)
        title.translatesAutoresizingMaskIntoConstraints = false
      //  contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        title.frame.origin = CGPoint(x: 10, y: 10)
        contentView.addSubview(title)
        
        thumbnail = UIImageView()
        thumbnail.contentMode = .scaleAspectFit
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
    //    thumbnail.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    //    thumbnail.frame.size = CGSize(width: 60, height: 60)
      //  thumbnail.clipsToBounds = true
   //     print(thumbnail.intrinsicContentSize)
      
        contentView.addSubview(thumbnail)
        
    

        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            title.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: thumbnail.safeAreaLayoutGuide.leadingAnchor, constant: -10),
            title.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            thumbnail.heightAnchor.constraint(equalToConstant: 60),
            thumbnail.widthAnchor.constraint(equalToConstant: 60),
            thumbnail.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            thumbnail.leadingAnchor.constraint(equalTo: title.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            thumbnail.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])

        //        stackView1 = UIStackView(arrangedSubviews: [title, thumbnail])
        //        stackView1.spacing = 10
//        stackView1.axis = .horizontal
//        contentView.addSubview(stackView1)
//
//        stackView1.translatesAutoresizingMaskIntoConstraints = false
//        stackView1.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
//        stackView1.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        stackView1.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        stackView1.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        stackView1.isLayoutMarginsRelativeArrangement = true
//        stackView1.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
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
}
