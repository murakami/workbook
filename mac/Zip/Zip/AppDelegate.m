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
- (void)zip:(NSString *)path;
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
                  completionHandler:^(NSInteger result){
        NSURL       *pathToFile = nil;
        NSString    *path = nil;
        
        if (result == NSOKButton) {
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

- (IBAction)saveDocument:(id)sender
{
    DBGMSG(@"%s", __func__);
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel beginSheetModalForWindow:self.window
                  completionHandler:^(NSInteger result) {
        NSURL       *pathToFile = nil;
        NSString    *path = nil;

        if (result == NSOKButton) {
            pathToFile = [panel URL];
            path = [pathToFile path];
            DBGMSG(@"%@", pathToFile);
            DBGMSG(@"%@", path);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self zip:path];
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
        unzLocateFile(file, filename, 0);
        unzOpenCurrentFile(file);
        NSMutableData   *data = [NSMutableData data];
        void            *buffer = (void *)malloc(BUFSIZ);
        int             len;
        while ((len = unzReadCurrentFile(file, buffer, BUFSIZ)) != 0) {
            [data appendBytes:buffer length:len];
        }
        free(buffer);
        printf("----------\n");
        for (NSUInteger i = 0U; i < [data length]; i++) {
            printf("%c", ((char *)[data bytes])[i]);
        }
        printf("\n----------\n");
        unzCloseCurrentFile(file);
        error = unzGoToNextFile(file);
    }
    unzClose(file);
}

#define OUTBUFSIZ   1024

- (void)zip:(NSString *)path
{
    DBGMSG(@"%s, %@", __func__, path);
    NSMutableData   *data = [[NSMutableData alloc] init];
    z_stream   strm;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    deflateInit(&strm, Z_DEFAULT_COMPRESSION);
    char    str[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    strm.next_in = (Bytef *)str;
    strm.avail_in = strlen(str);
    char    buffer[OUTBUFSIZ];
    strm.next_out = (Bytef *)buffer;
    strm.avail_out = OUTBUFSIZ;

    int status;
    for (;;) {
        if (strm.avail_in == 0) {
            status = deflate(&strm, Z_FINISH);
        }
        else {
            status = deflate(&strm, Z_NO_FLUSH);
        }
        if (status == Z_STREAM_END) {
            break;
        }
        if (status != Z_OK) {
            DBGMSG(@"deflate: %s", (strm.msg) ? strm.msg : "error");
            break;
        }
        if (strm.avail_out == 0) {
            DBGMSG(@"append length:OUTBUFSIZ");
            [data appendBytes:buffer length:OUTBUFSIZ];
            strm.next_out = (Bytef *)buffer;
            strm.avail_out = OUTBUFSIZ;
        }
    }
    if (strm.avail_out != OUTBUFSIZ) {
        DBGMSG(@"append length:%d", (OUTBUFSIZ - strm.avail_out));
        [data appendBytes:buffer length:(OUTBUFSIZ - strm.avail_out)];
    }
    deflateEnd(&strm);
    //[data writeToFile:path atomically:YES];
}

@end
