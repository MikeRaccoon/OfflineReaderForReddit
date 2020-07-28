//
//  Variables.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-07-19.
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
var userInterfaceStyle: String!
