//
//  PreferencesWindow.swift
//  Temperature
//
//  Created by 村上幸雄 on 2019/07/22.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindow {
    override func cancelOperation(_ sender: Any?) {
        self.close()
    }
}
