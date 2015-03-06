//
//  ViewController.swift
//  SequenceGrabber
//
//  Created by 村上幸雄 on 2015/03/01.
//  Copyright (c) 2015年 MURAKAMI Yukio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    @IBOutlet weak var previewView: UIView!
    let captureSession = AVCaptureSession();
    let videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)
    let audioDataOutputQueue = dispatch_queue_create("AudioDataOutputQueue", DISPATCH_QUEUE_SERIAL)
    var frontFacingCameraDeviceInput : AVCaptureDeviceInput? = nil
    var backFacingCameraDeviceInput : AVCaptureDeviceInput? = nil
    var audioDeviceInput : AVCaptureDeviceInput? = nil
    var videoDataOutput = AVCaptureVideoDataOutput()
    var audioDataOutput = AVCaptureAudioDataOutput()
    
    override func viewDidLoad() {
        println(__FUNCTION__)
        super.viewDidLoad()
        
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
        
        if let deviceInput = frontFacingCameraDeviceInput {
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        else if let deviceInput = backFacingCameraDeviceInput {
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        if let deviceInput = audioDeviceInput {
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey:kCVPixelFormatType_32BGRA]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }
        
        audioDataOutput.setSampleBufferDelegate(self, queue: audioDataOutputQueue)
        if captureSession.canAddOutput(audioDataOutput) {
            captureSession.addOutput(audioDataOutput)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        println(__FUNCTION__)
        super.viewDidAppear(animated)
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        captureVideoPreviewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(captureVideoPreviewLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func touch(sender: AnyObject) {
        println(__FUNCTION__)
        if captureSession.running {
            println("captureSession.stopRunning()")
            captureSession.stopRunning()
        }
        else {
            println("captureSession.startRunning()")
            captureSession.startRunning()
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
        fromConnection connection: AVCaptureConnection!) {
        if captureOutput == videoDataOutput {
            println("\(__FUNCTION__) videoDataOutput")
        }
        else if captureOutput == audioDataOutput {
            println("\(__FUNCTION__) audioDataOutput")
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!,
        didDropSampleBuffer sampleBuffer: CMSampleBuffer!,
        fromConnection connection: AVCaptureConnection!) {
        if captureOutput == videoDataOutput {
            println("\(__FUNCTION__) videoDataOutput")
        }
        else if captureOutput == audioDataOutput {
            println("\(__FUNCTION__) audioDataOutput")
        }
    }
    
    /*
    func captureOutput(captureOutput: AVCaptureOutput!,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
        fromConnection connection: AVCaptureConnection!) {
    }
    */

}

