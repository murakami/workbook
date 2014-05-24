//
//  AppDelegate.h
//  Ruby
//
//  Created by 村上幸雄 on 2014/05/24.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak, nonatomic) IBOutlet NSTextField    *inputTextField;
@property (weak, nonatomic) IBOutlet NSTextField    *outputLabel;
@property (weak, nonatomic) IBOutlet NSButton       *rubyButton;

- (IBAction)doRuby:(id)sender;

@end
