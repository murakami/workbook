//
//  AppDelegate.h
//  TextToSpeech
//
//  Created by 村上 幸雄 on 12/02/25.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow    *window;
@property (assign) AUGraph              auGraph;

@end
