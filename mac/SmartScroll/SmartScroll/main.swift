//
//  main.swift
//  SmartScroll
//
//  Created by 村上幸雄 on 2017/12/02.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Foundation
import CoreFoundation
import IOKit
import IOKit.usb.IOUSBLib

let kOurVendorID = 0x56a    /* Vendor ID of the USB device */
let kOurProductID = 0x50    /* Product ID of device */

private var gNotifyPort: IONotificationPortRef? = nil

private var gRawAddedIter: io_iterator_t = 0
private var gRawRemovedIter: io_iterator_t = 0
private var gBulkTestAddedIter: io_iterator_t = 0
private var gBulkTestRemovedIter: io_iterator_t = 0

var masterPort: mach_port_t = 0
let usbVendor: Int32 = Int32(kOurVendorID)
let usbProduct: Int32 = Int32(kOurProductID)

let kr: kern_return_t = IOMasterPort(mach_port_t(MACH_PORT_NULL), &masterPort)

//var matchingDict: CFMutableDictionary = IOServiceMatching(kIOUSBDeviceClassName)
var matchingDict = IOServiceMatching(kIOUSBDeviceClassName) as? [String: Any]
matchingDict![kUSBVendorID] = usbVendor
matchingDict![kUSBProductID] = usbProduct

gNotifyPort = IONotificationPortCreate(masterPort)
let runLoopSource = IONotificationPortGetRunLoopSource(gNotifyPort).takeUnretainedValue()

private var gRunLoop: CFRunLoop? = CFRunLoopGetCurrent()
CFRunLoopAddSource(gRunLoop, runLoopSource, CFRunLoopMode.defaultMode)

CFRunLoopRun()

exit(0)
