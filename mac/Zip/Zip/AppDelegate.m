//
//  AppDelegate.m
//  Zip
//
//  Created by 村上 幸雄 on 12/02/29.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "unzip.h"
#import "AppDelegate.h"

@interface AppDelegate ()
- (void)unzip:(NSString *)path;
@end

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)openDocument:(id)sender
{
    DBGMSG(@"%s", __func__);
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel beginSheetModalForWindow:self.window
                  completionHandler:^(NSInteger returnCode){
        NSURL       *pathToFile = nil;
        NSString    *path = nil;
        
        if (returnCode == NSOKButton) {
            pathToFile = [[panel URLs] objectAtIndex:0];
            path = [pathToFile path];
            DBGMSG(@"%@", pathToFile);
            DBGMSG(@"%@", path);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self unzip:path];
            });
        }
    }];
}

- (void)unzip:(NSString *)path
{
    DBGMSG(@"%s, %@", __func__, path);
    int error = UNZ_OK;
    unzFile file = NULL;
    file = unzOpen([path UTF8String]);
    unzGoToFirstFile(file);
    while (error == UNZ_OK) {
        unz_file_info   fileInfo;
        char            filename[PATH_MAX];
        unzGetCurrentFileInfo(file, &fileInfo, filename, PATH_MAX, NULL, 0, NULL, 0);
        DBGMSG(@"%s", filename);
        error = unzGoToNextFile(file);
    }
    unzClose(file);
}

@end
