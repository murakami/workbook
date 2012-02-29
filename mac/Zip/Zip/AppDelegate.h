//
//  AppDelegate.h
//  Zip
//
//  Created by 村上 幸雄 on 12/02/29.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)openDocument:(id)sender;

@end
