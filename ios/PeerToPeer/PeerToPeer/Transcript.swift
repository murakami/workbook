//
//  Transcript.swift
//  PeerToPeer
//
//  Created by 村上幸雄 on 2015/01/31.
//  Copyright (c) 2015年 村上幸雄. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum TranscriptDirection {
    case Send
    case Receive
    case Local
}

class Transcript {
    var direction: TranscriptDirection
    var peerID: MCPeerID
    var message: String?
    var imageName: String?
    var imageUrl: NSURL?
    var progress: NSProgress?
    
    init(peerID: MCPeerID, message: String?, imageName: String?, imageUrl: NSURL?, progress: NSProgress?, direction: TranscriptDirection) {
        self.peerID = peerID
        self.message = message
        self.direction = direction
        self.imageUrl = imageUrl
        self.progress = progress
        self.imageName = imageName
    }
    
    convenience init(peerID: MCPeerID, message: String, direction: TranscriptDirection) {
        self.init(peerID: peerID, message: message, imageName: nil, imageUrl: nil, progress: nil, direction: direction)
    }
    
    convenience init(peerID: MCPeerID, imageUrl: NSURL, direction: TranscriptDirection) {
        self.init(peerID: peerID, message: nil, imageName: imageUrl.lastPathComponent, imageUrl: imageUrl, progress: nil, direction: direction)
    }
    
    convenience init(peerID: MCPeerID, imageName: String, progress: NSProgress, direction: TranscriptDirection) {
        self.init(peerID: peerID, message: nil, imageName: imageName, imageUrl: nil, progress: progress, direction: direction)
    }
}

/* End Of File */