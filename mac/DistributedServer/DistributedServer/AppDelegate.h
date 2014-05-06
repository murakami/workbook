//
//  AppDelegate.h
//  DistributedServer
//
//  Created by 村上幸雄 on 2014/05/05.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) IBOutlet NSTextField  *label;

@end
