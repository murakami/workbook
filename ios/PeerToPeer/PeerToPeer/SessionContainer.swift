//
//  SessionContainer.swift
//  PeerToPeer
//
//  Created by 村上幸雄 on 2015/01/31.
//  Copyright (c) 2015年 村上幸雄. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class SessionContainer: MCSessionDelegate {
    var session: MCSession
    var delegate: SessionContainerDelegate
    var advertiserAssistant: MCAdvertiserAssistant
    
    init(displayName: String, serviceType: String) {
        let peerID = MCPeerID(displayName: displayName)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .Required)
        self.session.delegate = self
        self.advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: self.session)
        self.advertiserAssistant.start()
    }
    
    deinit {
        advertiserAssistant.stop()
        session.disconnect()
    }
    
    func stringForPeerConnectionState(state: MCSessionState) -> String {
        switch state {
        case .Connected:
            return "Connected"
        case .Connecting:
            return "Connecting"
        case .NotConnected:
            return "Not Connected"
        }
    }
    
    func send(message: String) -> Transcript? {
        let messageData = message.dataUsingEncoding(NSUTF8StringEncoding)
        var error: NSError? = nil
        session.sendData(messageData, toPeers: session.connectedPeers, withMode: .Reliable, error: &error)
        if let e = error {
            NSLog("Error sending message to peers [%@]", e)
            return nil
        }
        else {
            return Transcript(peerID: session.myPeerID, message: message, direction: .Send)
        }
    }
    
    func send(imageUrl: NSURL) -> Transcript {
        var progress: NSProgress
        
        for peerID in session.connectedPeers as [MCPeerID]! {
            progress = session.sendResourceAtURL(imageUrl,
                withName: imageUrl.lastPathComponent,
                toPeer: peerID,
                withCompletionHandler: {(error: NSError!) -> Void in
                    if error != nil {
                        NSLog("end resource to peer [%@] completed with Error [%@]", peerID.displayName, error)
                    }
                    else {
                        let transcript = Transcript(peerID: self.session.myPeerID, imageUrl: imageUrl, direction: .Send)
                        self.delegate.update(transcript)
                    }
            })
        }
        let transcript = Transcript(peerID: session.myPeerID,
            imageName: imageUrl.lastPathComponent!,
            progress: progress,
            direction: .Send)
        return transcript
    }
    
    // Override this method to handle changes to peer session state
    - (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
    {
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
    
    NSString *adminMessage = [NSString stringWithFormat:@"'%@' is %@", peerID.displayName, [self stringForPeerConnectionState:state]];
    // Create an local transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID message:adminMessage direction:TRANSCRIPT_DIRECTION_LOCAL];
    
    // Notify the delegate that we have received a new chunk of data from a peer
    [self.delegate receivedTranscript:transcript];
    }
    
    // MCSession Delegate callback when receiving data from a peer in a given session
    - (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
    {
    // Decode the incoming data to a UTF8 encoded string
    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    // Create an received transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID message:receivedMessage direction:TRANSCRIPT_DIRECTION_RECEIVE];
    
    // Notify the delegate that we have received a new chunk of data from a peer
    [self.delegate receivedTranscript:transcript];
    }
    
    // MCSession delegate callback when we start to receive a resource from a peer in a given session
    - (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
    {
    NSLog(@"Start receiving resource [%@] from peer %@ with progress [%@]", resourceName, peerID.displayName, progress);
    // Create a resource progress transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID imageName:resourceName progress:progress direction:TRANSCRIPT_DIRECTION_RECEIVE];
    // Notify the UI delegate
    [self.delegate receivedTranscript:transcript];
    }
    
    // MCSession delegate callback when a incoming resource transfer ends (possibly with error)
    - (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
    {
    // If error is not nil something went wrong
    if (error)
    {
    NSLog(@"Error [%@] receiving resource from peer %@ ", [error localizedDescription], peerID.displayName);
    }
    else
    {
    // No error so this is a completed transfer.  The resources is located in a temporary location and should be copied to a permenant locatation immediately.
    // Write to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *copyPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], resourceName];
    if (![[NSFileManager defaultManager] copyItemAtPath:[localURL path] toPath:copyPath error:nil])
    {
    NSLog(@"Error copying resource to documents directory");
    }
    else {
    // Get a URL for the path we just copied the resource to
    NSURL *imageUrl = [NSURL fileURLWithPath:copyPath];
    // Create an image transcript for this received image resource
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID imageUrl:imageUrl direction:TRANSCRIPT_DIRECTION_RECEIVE];
    [self.delegate updateTranscript:transcript];
    }
    }
    }
    
    // Streaming API not utilized in this sample code
    - (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
    {
    NSLog(@"Received data over stream with name %@ from peer %@", streamName, peerID.displayName);
    }
}

protocol SessionContainerDelegate {
    func received(transcript: Transcript)
    func update(transcript: Transcript)
}

/* End Of File */