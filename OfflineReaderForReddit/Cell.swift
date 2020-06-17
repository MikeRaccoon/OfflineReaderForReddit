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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        subreddit = UILabel()
        
        author = UILabel()
        
        let stackView1 = UIStackView(arrangedSubviews: [subreddit, author])
        stackView1.translatesAutoresizingMaskIntoConstraints = false
       // stackView1.spacing = 5
        stackView1.axis = .horizontal
       // stackView1.distribution = .fillProportionally
        self.contentView.addSubview(stackView1)
        
        stackView1.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView1.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView1.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView1.isLayoutMarginsRelativeArrangement = true
        stackView1.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
    //    stackView1.centerYAnchor.constraint(equalTo: topAnchor).isActive = true
      //  stackView1.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        title = UILabel()
        
        thumbnail = UIImageView()
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.heightAnchor.constraint(equalToConstant: 60).isActive = true
        thumbnail.widthAnchor.constraint(equalToConstant: 60).isActive = true

        //     thumbnail.frame = CGRect(x: .zero, y: .zero, width: 100, height: 100)
        // thumbnail.frame.size.width = 3
        thumbnail.contentMode = .scaleAspectFit
        
        let stackView2 = UIStackView(arrangedSubviews: [title, thumbnail])
        stackView2.translatesAutoresizingMaskIntoConstraints = false
     //   stackView2.spacing = 20
        stackView2.axis = .horizontal
        self.contentView.addSubview(stackView2)
        
      //  stackView2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        stackView2.topAnchor.constraint(equalTo: stackView1.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView2.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView2.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView2.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView2.isLayoutMarginsRelativeArrangement = true
        stackView2.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        
       // post_hint selftext score thumbnail

      //  title.frame.origin.x = 0
        
        
        //                postInfo.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width - 50, height: self.bounds.size.height)
        //  postInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
          //postInfo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
          //        postInfo.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
          //         postInfo.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
           //postInfo.trailingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
