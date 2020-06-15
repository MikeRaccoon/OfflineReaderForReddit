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
        
        let stackView1 = UIStackView()
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView1.spacing = 5
        stackView1.axis = .horizontal
        self.contentView.addSubview(stackView1)
        
        stackView1.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView1.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView1.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true

        subreddit = UILabel()
        stackView1.addArrangedSubview(subreddit)
        
        author = UILabel()
        stackView1.addArrangedSubview(author)
        
        let stackView2 = UIStackView()
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.spacing = 5
        stackView2.axis = .vertical
        self.contentView.addSubview(stackView2)
        
        stackView2.topAnchor.constraint(equalTo: stackView1.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView2.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView2.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    
        title = UILabel()
        stackView2.addArrangedSubview(title)
        
        thumbnail = UIImageView()
        thumbnail.frame = CGRect(x: .zero, y: .zero, width: 10, height: 10)
        thumbnail.contentMode = .scaleAspectFit
        stackView2.addArrangedSubview(thumbnail)
        
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
