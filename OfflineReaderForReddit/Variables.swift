//
//  Variables.swift
//  OfflineReaderForReddit
//
//  Created by Mike on 2020-07-19.
//  Copyright © 2020 Mike. All rights reserved.
//

import AVKit

enum layoutTypes {
    case large
    case compact
}

var layoutType = layoutTypes.large
var looper: AVPlayerLooper?
var playerLooper: NSObject?
var playerLayer: AVPlayerLayer!
var queuePlayer: AVQueuePlayer?
var cellWidth: CGFloat!
var userInterfaceStyle: String!
