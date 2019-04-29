//
//  ViewController.swift
//  AutoLayout
//
//  Created by 村上幸雄 on 2019/04/29.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class RedView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        let  context = NSGraphicsContext.current?.cgContext
        context?.setFillColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context?.fill(dirtyRect)
    }
}

class GreenView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        let  context = NSGraphicsContext.current?.cgContext
        context?.setFillColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        context?.fill(dirtyRect)
    }
}

class BlueView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        let  context = NSGraphicsContext.current?.cgContext
        context?.setFillColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        context?.fill(dirtyRect)
    }
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let redView = RedView()
        self.view.addSubview(redView)
        redView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: redView, attribute: .Top, relatedBy: .Equal,
                               toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: redView, attribute: .Left, relatedBy: .Equal,
                               toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: redView, attribute: .Right, relatedBy: .Equal,
                               toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: redView, attribute: .Height, relatedBy: .Equal,
                               toItem: self.view, attribute: .Height, multiplier: 0.0, constant: 100),
            ]
        )
        
        let greenView = GreenView()
        self.view.addSubview(greenView)
        greenView.translatesAutoresizingMaskIntoConstraints = false
        
        let blueView = BlueView()
        self.view.addSubview(blueView)
        blueView.translatesAutoresizingMaskIntoConstraints = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

