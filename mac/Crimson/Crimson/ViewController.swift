//
//  ViewController.swift
//  Crimson
//
//  Created by 村上幸雄 on 2018/01/02.
//  Copyright © 2018年 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* 細かな背邸を行うため、コードで生成。 */
        let viewFrame = self.view.frame
        let glView = MyGLView(frame: viewFrame)
        
        /* ウィンドウの大きさに追従して合わせる */
        glView.translatesAutoresizingMaskIntoConstraints = true
        glView.autoresizingMask = NSView.AutoresizingMask(rawValue:
            NSView.AutoresizingMask.RawValue(
                UInt8(NSView.AutoresizingMask.width.rawValue)
                    | UInt8(NSView.AutoresizingMask.height.rawValue)))
        self.view.addSubview(glView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

