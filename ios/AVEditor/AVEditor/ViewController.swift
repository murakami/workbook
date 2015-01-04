//
//  ViewController.swift
//  AVEditor
//
//  Created by 村上幸雄 on 2014/12/21.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var rotateButton: UIButton!
    
    @IBAction func rotate(sender:AnyObject) {
        println(__FUNCTION__)
        
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) == false {
            return
        }
        
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        if let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.SavedPhotosAlbum) {
            mediaUI.mediaTypes = mediaTypes
            NSLog("%s mediaTypes:%@", __FUNCTION__, mediaTypes)
        }
        
        // mediaUI.mediaTypes = [kUTTypeMovie]
        mediaUI.mediaTypes = ["public.movie"]
        
        mediaUI.allowsEditing = false
        
        mediaUI.delegate = self
        
        self.presentViewController(mediaUI, animated: true, completion: nil)
    }
    
    var mutableComposition: AVMutableComposition?
    
    var mutableVideoComposition: AVMutableVideoComposition?
    
    var exportSession: AVAssetExportSession?
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]) {
        println(__FUNCTION__)
        if info[UIImagePickerControllerMediaURL] != nil {
            /* アセットオブジェクトの作成 */
            let url: NSURL = info[UIImagePickerControllerMediaURL] as NSURL
            var options = [String: Bool]()
            options[AVURLAssetPreferPreciseDurationAndTimingKey] = true
            var asset = AVURLAsset(URL: url, options: options)
            NSLog("%s url:%@", __FUNCTION__, url)
            
            /* アセットから動画/音声トラックを取り出す */
            let assetVideoTrack: AVAssetTrack = asset.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
            let assetAudioTrack: AVAssetTrack = asset.tracksWithMediaType(AVMediaTypeAudio)[0] as AVAssetTrack
            
            let insertionPoint: CMTime = kCMTimeZero
            var error: NSError? = nil
            
            /* コンポジションを作成 */
            if mutableComposition == nil {
                mutableComposition = AVMutableComposition()
                
                /* 動画コンポジショントラックの作成 */
                let compositionVideoTrack: AVMutableCompositionTrack = mutableComposition!.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
                
                /* 動画データをコンポジションに追加 */
                error = nil
                compositionVideoTrack.insertTimeRange(CMTimeRangeMake(insertionPoint, assetVideoTrack.timeRange.duration), ofTrack: assetVideoTrack, atTime: kCMTimeZero, error: &error)
                if error != nil {
                    NSLog("%s insertVideoTack error:%@", __FUNCTION__, error!)
                }
                
                /* 音声コンポジショントラックの作成 */
                let compositionAudioTrack: AVMutableCompositionTrack = mutableComposition!.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
                
                /* 音声データをコンポジションに追加 */
                error = nil
                compositionAudioTrack.insertTimeRange(CMTimeRangeMake(insertionPoint, assetAudioTrack.timeRange.duration), ofTrack: assetAudioTrack, atTime: kCMTimeZero, error: &error)
                if error != nil {
                    NSLog("%s insertAudioTrach error:%@", __FUNCTION__, error!)
                }
            }
            var compositionVideoTrack: AVMutableCompositionTrack? = nil
            var compositionAudioTrack: AVMutableCompositionTrack? = nil
            for track in mutableComposition!.tracks {
                if track.isKindOfClass(AVMutableCompositionTrack) {
                    var mutableCompositionTrack = track as AVMutableCompositionTrack
                    if track.mediaType == AVMediaTypeVideo {
                        compositionVideoTrack = mutableCompositionTrack
                    }
                    else if track.mediaType == AVMediaTypeAudio {
                        compositionAudioTrack = mutableCompositionTrack
                    }
                }
            }
            
            var instruction: AVMutableVideoCompositionInstruction
            var layerInstruction: AVMutableVideoCompositionLayerInstruction
            
            /* 移動して回転 */
            let t1: CGAffineTransform = CGAffineTransformMakeTranslation(assetVideoTrack.naturalSize.height, 0.0)
            let t2: CGAffineTransform = CGAffineTransformRotate(t1, ((90.0 / 180.0) * 3.14159265358979323846264338327950288))
            
            if mutableVideoComposition == nil {
                /* 動画コンポジションの作成 */
                mutableVideoComposition = AVMutableVideoComposition()
                mutableVideoComposition!.renderSize = CGSizeMake(assetVideoTrack.naturalSize.height, assetVideoTrack.naturalSize.width)
                mutableVideoComposition!.frameDuration = CMTimeMake(1, 30);
                
                /* 動画コンポジション命令 */
                instruction = AVMutableVideoCompositionInstruction()
                instruction.timeRange = CMTimeRangeMake(kCMTimeZero, mutableComposition!.duration);
                layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: /* assetVideoTrack */compositionVideoTrack);
                layerInstruction.setTransform(t2, atTime: kCMTimeZero)
                NSLog("%s instruction:%@", __FUNCTION__, instruction)
                NSLog("%s layerInstruction:%@", __FUNCTION__, layerInstruction)
            }
            else {
                mutableVideoComposition!.renderSize = CGSizeMake(mutableVideoComposition!.renderSize.height, mutableVideoComposition!.renderSize.width);
                
                /* 動画コンポジション命令の抽出 */
                instruction = mutableVideoComposition!.instructions[0] as AVMutableVideoCompositionInstruction
                layerInstruction = instruction.layerInstructions[0] as AVMutableVideoCompositionLayerInstruction
                
                /* 内容の確認 */
                var existingTransform = CGAffineTransform(a: 0.0, b: 0.0, c: 0.0, d: 0.0, tx: 0.0, ty: 0.0)
                if layerInstruction.getTransformRampForTime(mutableComposition!.duration, startTransform: &existingTransform, endTransform: nil, timeRange: nil) == false {
                    layerInstruction.setTransform(t2, atTime: kCMTimeZero)
                }
                else {
                    /* 原点補償 */
                    let t3: CGAffineTransform = CGAffineTransformMakeTranslation(-1.0 * assetVideoTrack.naturalSize.height / 2.0, 0.0)
                    let newTransform: CGAffineTransform = CGAffineTransformConcat(existingTransform, CGAffineTransformConcat(t2, t3))
                    layerInstruction.setTransform(newTransform, atTime: kCMTimeZero)
                }
            }
            
            /* コンポジションに命令を追加 */
            instruction.layerInstructions = [layerInstruction]
            mutableVideoComposition!.instructions = [instruction]
            
            /* 出力URL */
            var documentsPath: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            error = nil
            NSFileManager.defaultManager().createDirectoryAtPath(documentsPath, withIntermediateDirectories: true, attributes: nil, error: &error)
            if error != nil {
                NSLog("%s createDir error:%@", __FUNCTION__, error!)
            }
            let now = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let filename = String(format: "%@.mp4", arguments: [dateFormatter.stringFromDate(now)])
            var exportPath: NSString = documentsPath.stringByAppendingPathComponent(filename)
            error = nil
            //NSFileManager.defaultManager().removeItemAtPath(exportPath, error: &error)
            if error != nil {
                NSLog("%s removeFile error:%@", __FUNCTION__, error!)
            }
            var exportUrl: NSURL = NSURL.fileURLWithPath(exportPath)!
            
            /* セッションを作成し、フォトライブラリに書き出す */
            exportSession = AVAssetExportSession(asset: mutableComposition!.copy() as AVAsset, presetName: AVAssetExportPresetHighestQuality)
            exportSession!.videoComposition = mutableVideoComposition
            exportSession!.outputURL = exportUrl
            exportSession!.outputFileType = AVFileTypeQuickTimeMovie
            
            exportSession!.exportAsynchronouslyWithCompletionHandler({
                () -> Void in
                NSLog("%@", __FUNCTION__)
                switch self.exportSession!.status {
                case AVAssetExportSessionStatus.Completed:
                    NSLog("%@ AVAssetExportSessionStatus.Completed", __FUNCTION__)
                    let assetsLib = ALAssetsLibrary()
                    assetsLib.writeVideoAtPathToSavedPhotosAlbum(exportUrl, completionBlock: {
                        (nsurl, error) -> Void in
                        if error != nil {
                            NSLog("%@ error:%@", __FUNCTION__, error)
                        }
                    })
                case AVAssetExportSessionStatus.Failed:
                    NSLog("%@ AVAssetExportSessionStatus.Failed exporter:%@ error:%@", __FUNCTION__, self.exportSession!, self.exportSession!.error)
                case AVAssetExportSessionStatus.Cancelled:
                    NSLog("%@ AVAssetExportSessionStatus.Cancelled exporter:%@ error:%@", __FUNCTION__, self.exportSession!, self.exportSession!.error)
                default:
                    NSLog("%@ none exporter:%@", __FUNCTION__, self.exportSession!)
                }
            })
        }
        picker.dismissViewControllerAnimated(true, completion: nil);
    }

}

