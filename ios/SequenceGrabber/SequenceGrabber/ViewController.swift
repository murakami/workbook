//
//  ViewController.swift
//  SequenceGrabber
//
//  Created by 村上幸雄 on 2015/03/01.
//  Copyright (c) 2015年 MURAKAMI Yukio. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    @IBOutlet weak var previewView: UIView!
    let captureSession = AVCaptureSession();
    let videoAudioDataOutputQueue = dispatch_queue_create("com.example.SequenceGrabber.VideoAudioDataOutputQueue", DISPATCH_QUEUE_SERIAL)
    let writeQueue = dispatch_queue_create("com.example.SequenceGrabber.writeQueue", DISPATCH_QUEUE_SERIAL)
    var frontFacingCameraDeviceInput : AVCaptureDeviceInput? = nil
    var backFacingCameraDeviceInput : AVCaptureDeviceInput? = nil
    var audioDeviceInput : AVCaptureDeviceInput? = nil
    var videoDataOutput = AVCaptureVideoDataOutput()
    var audioDataOutput = AVCaptureAudioDataOutput()
    var assetWriter: AVAssetWriter? = nil
    var videoAssetWriterInput: AVAssetWriterInput? = nil
    var audioAssetWriterInput: AVAssetWriterInput? = nil
    let movieWriteQueue = dispatch_queue_create("MovieWriteQueue", DISPATCH_QUEUE_SERIAL)
    var height: Int = 0
    var width: Int = 0
    var outputFilePath: String? = nil
    var storeFlag = false
    var timeOffset = CMTimeMake(0, 0)
    var storeAudioPts = CMTimeMake(0, 0)
    
    override func viewDidLoad() {
        println(__FUNCTION__)
        super.viewDidLoad()
        
        /* Session/Deviceの準備 */
        var frontVideoDevice: AVCaptureDevice? = nil
        var backVideoDevice: AVCaptureDevice? = nil
        var audioDevice: AVCaptureDevice? = nil
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == AVCaptureDevicePosition.Back {
                    NSLog("Device position : back")
                    backVideoDevice = device as? AVCaptureDevice
                }
                else {
                    NSLog("Device position : front")
                    frontVideoDevice = device as? AVCaptureDevice
                }
            }
            else if device.hasMediaType(AVMediaTypeAudio) {
                NSLog("Device : audio")
                audioDevice = device as? AVCaptureDevice
            }
        }
        /*
        // デフォルトの例
        let videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        */
        
        var error: NSError? = nil;
        if let device = frontVideoDevice {
            frontFacingCameraDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        }
        if let device = backVideoDevice {
            backFacingCameraDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        }
        if let device = audioDevice {
            audioDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        }

        if let deviceInput = backFacingCameraDeviceInput {
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        else if let deviceInput = frontFacingCameraDeviceInput {
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        if let deviceInput = audioDeviceInput {
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        /*
        // フレームレートを設定する例
        if ([cameraDeviceInput lockForConfiguration:&error]) {
            cameraDeviceInput.activeVideoMaxFrameDuration = CMTimeMake(1, 30)
            cameraDeviceInput.activeVideoMinFrameDuration = CMTimeMake(1, 30)
            [frontVideoDevice unlockForConfiguration];
        }
        */

        /* 録画開始準備（画像も音声も同じデリゲートを設定） */
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey:kCVPixelFormatType_32BGRA]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: videoAudioDataOutputQueue)
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }

        audioDataOutput.setSampleBufferDelegate(self, queue: videoAudioDataOutputQueue)
        if captureSession.canAddOutput(audioDataOutput) {
            captureSession.addOutput(audioDataOutput)
        }
        
        width = videoDataOutput.videoSettings["Width"] as! Int
        height = videoDataOutput.videoSettings["Height"] as! Int
        print("\(__FUNCTION__) width:\(width) height:\(height)")
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as! String
        outputFilePath = "\(documentsDirectory)/junk.mp4"
    }
    
    override func viewDidAppear(animated: Bool) {
        println(__FUNCTION__)
        super.viewDidAppear(animated)
        
        /* 動画のプレビューの準備 */
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        captureVideoPreviewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(captureVideoPreviewLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doCapture(sender: AnyObject) {
        println(__FUNCTION__)
        if captureSession.running {
            println("captureSession.stopRunning()")
            captureSession.stopRunning()
            
            self.assetWriter?.finishWritingWithCompletionHandler({() -> Void in
                self.assetWriter = nil
                let assetsLib = ALAssetsLibrary()
                assetsLib.writeVideoAtPathToSavedPhotosAlbum(NSURL(fileURLWithPath: self.outputFilePath!), completionBlock: {(assetURL: NSURL!, error: NSError!) -> Void in
                })
            })
        }
        else {
            println("captureSession.startRunning()")
            captureSession.startRunning()
            timeOffset = CMTimeMake(0, 0)
            storeAudioPts = CMTimeMake(0, 0)
        }
    }
    
    @IBAction func doStore(sender: AnyObject) {
        println(__FUNCTION__)
        dispatch_sync(writeQueue) {
            if self.storeFlag == true {
                println("記録停止")
                self.storeFlag = false
            }
            else {
                println("記録開始")
                self.storeFlag = true
            }
        }
    }
    
    @IBAction func doSave(sender: AnyObject) {
        println(__FUNCTION__)
        if captureSession.running {
            println("captureSession.stopRunning()")
            captureSession.stopRunning()
        }
        dispatch_sync(writeQueue) {
            self.assetWriter?.finishWritingWithCompletionHandler({() -> Void in
                println(__FUNCTION__)
                self.assetWriter = nil
                let assetsLib = ALAssetsLibrary()
                assetsLib.writeVideoAtPathToSavedPhotosAlbum(NSURL(fileURLWithPath: self.outputFilePath!), completionBlock: {(assetURL: NSURL!, error: NSError!) -> Void in
                    println(__FUNCTION__)
                })
            })
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        if (self.captureSession.running != true) || (self.storeFlag != true) {
            println("記録停止中")
            return
        }
        dispatch_sync(writeQueue) {
            if self.assetWriter == nil {
                let fileManager = NSFileManager()
                if fileManager.fileExistsAtPath(self.outputFilePath!) {
                    fileManager.removeItemAtPath(self.outputFilePath!, error: nil)
                }
                
                if captureOutput == self.videoDataOutput {
                }
                else if captureOutput == self.audioDataOutput {
                    let fmt = CMSampleBufferGetFormatDescription(sampleBuffer)
                    let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt)
                    
                    var outError: NSError? = nil
                    let url = NSURL(fileURLWithPath: self.outputFilePath!)
                    self.assetWriter = AVAssetWriter(URL: url, fileType: AVFileTypeQuickTimeMovie, error: &outError)
                    
                    let videoOutputSettings: Dictionary<String, AnyObject> = [
                        AVVideoCodecKey : AVVideoCodecH264,
                        AVVideoWidthKey : self.width,
                        AVVideoHeightKey : self.height
                    ]
                    self.videoAssetWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoOutputSettings)
                    self.videoAssetWriterInput!.expectsMediaDataInRealTime = true
                    self.assetWriter!.addInput(self.videoAssetWriterInput)
                    
                    let audioOutputSettings: Dictionary<String, AnyObject> = [
                        AVFormatIDKey : kAudioFormatMPEG4AAC,
                        AVNumberOfChannelsKey : Int(asbd.memory.mChannelsPerFrame),
                        AVSampleRateKey : asbd.memory.mSampleRate,
                        AVEncoderBitRateKey : 128000
                    ]
                    self.audioAssetWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeAudio, outputSettings: audioOutputSettings)
                    self.audioAssetWriterInput!.expectsMediaDataInRealTime = true
                    self.assetWriter!.addInput(self.audioAssetWriterInput)
                }
            }
        }
        
        if CMSampleBufferDataIsReady(sampleBuffer) != 0 {
            if self.assetWriter != nil {
                if self.assetWriter!.status == AVAssetWriterStatus.Unknown {
                    let startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                    self.assetWriter!.startWriting()
                    self.assetWriter!.startSessionAtSourceTime(startTime)
                }
                
                if captureOutput == self.audioDataOutput {
                    println(__FUNCTION__ + "audio")
                    var pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                    CMTimeShow(pts)
                    if (self.storeAudioPts.flags & CMTimeFlags.Valid).rawValue != 0 {
                        println("isAudioPtsValid is valid")
                        if (self.timeOffset.flags & CMTimeFlags.Valid).rawValue != 0 {
                            println("isTimeOffsetPtsValid is valid")
                            pts = CMTimeSubtract(pts, self.timeOffset);
                        }
                        let offset = CMTimeSubtract(pts, self.storeAudioPts);
                        if self.timeOffset.value == 0 {
                            println("timeOffset is \(self.timeOffset.value)")
                            self.timeOffset = offset;
                        }
                        else {
                            println("timeOffset is \(self.timeOffset.value)")
                            self.timeOffset = CMTimeAdd(self.timeOffset, offset);
                        }
                    }
                    self.storeAudioPts.flags = CMTimeFlags.allZeros
                }
                else {
                    println(__FUNCTION__ + "video")
                    var pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                    CMTimeShow(pts)
                }
                
                var tempBuffer = sampleBuffer
                if 0 < self.timeOffset.value {
                    tempBuffer = self.ajustTimeStamp(sampleBuffer, offset: self.timeOffset)
                }
                
                if captureOutput == self.videoDataOutput {
                    println(__FUNCTION__ + "store video")
                    var pts = CMSampleBufferGetPresentationTimeStamp(tempBuffer)
                    CMTimeShow(pts)
                    self.videoAssetWriterInput!.appendSampleBuffer(tempBuffer)
                }
                else if captureOutput == self.audioDataOutput {
                    println(__FUNCTION__ + "store audio")
                    var pts = CMSampleBufferGetPresentationTimeStamp(tempBuffer)
                    CMTimeShow(pts)
                    let duration = CMSampleBufferGetDuration(tempBuffer)
                    if 0 < duration.value {
                        pts = CMTimeAdd(pts, duration)
                    }
                    self.storeAudioPts = pts
                    
                    self.audioAssetWriterInput!.appendSampleBuffer(tempBuffer)
                }
            }
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didDropSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let cmTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let value = cmTime.value
        let timescale = cmTime.timescale
        //let seconds = value / timescale
        let epoch = cmTime.epoch
        if captureOutput == videoDataOutput {
            println("\(__FUNCTION__) videoDataOutput value:\(value) timescale:\(timescale) epoch:\(epoch)")
        }
        else if captureOutput == audioDataOutput {
            println("\(__FUNCTION__) audioDataOutput value:\(value) timescale:\(timescale) epoch:\(epoch)")
        }
    }
    
    /*
    func captureOutput(captureOutput: AVCaptureOutput!,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
        fromConnection connection: AVCaptureConnection!) {
    }
    */
    
    func ajustTimeStamp(sampleBuffer: CMSampleBufferRef, offset: CMTime) -> CMSampleBufferRef {
        var count: CMItemCount = 0
        CMSampleBufferGetSampleTimingInfoArray(sampleBuffer, 0, nil, &count);
        var info = [CMSampleTimingInfo](count: count,
            repeatedValue: CMSampleTimingInfo(duration: CMTimeMake(0, 0),
                presentationTimeStamp: CMTimeMake(0, 0),
                decodeTimeStamp: CMTimeMake(0, 0)))
        CMSampleBufferGetSampleTimingInfoArray(sampleBuffer, count, &info, &count);
        
        for i in 0..<count {
            info[i].decodeTimeStamp = CMTimeSubtract(info[i].decodeTimeStamp, offset);
            info[i].presentationTimeStamp = CMTimeSubtract(info[i].presentationTimeStamp, offset);
        }
        
        var out: Unmanaged<CMSampleBuffer>?
        CMSampleBufferCreateCopyWithNewTiming(nil, sampleBuffer, count, &info, &out);
        return out!.takeRetainedValue()
    }

}

