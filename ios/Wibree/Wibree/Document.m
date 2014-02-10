//
//  Document.m
//  Wibree
//
//  Created by 村上幸雄 on 2014/02/10.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "Document.h"

@interface Document ()
@property (strong, readwrite, nonatomic) NSString   *uniqueIdentifier;
- (void)_clearDefaults;
- (void)_updateDefaults;
- (void)_loadDefaults;
- (NSString*)_modelDir;
- (NSString*)_modelPath;
@end

@implementation Document

+ (Document *)sharedDocument;
{
    static Document *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Document alloc] init];
    });
	return _sharedInstance;
}

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        _version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _uniqueIdentifier = nil;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    self.version = nil;
    self.uniqueIdentifier = nil;
}

- (void)load
{
    DBGMSG(@"%s", __func__);
    [self _loadDefaults];
}

- (void)save
{
    DBGMSG(@"%s", __func__);
    [self _updateDefaults];
}

- (void)_clearDefaults
{
    DBGMSG(@"%s", __func__);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"version"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueIdentifier"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueIdentifier"];
    }
}

- (void)_updateDefaults
{
    DBGMSG(@"%s", __func__);
    NSString    *versionString = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
        versionString = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    }
    if ((versionString == nil) || ([versionString compare:self.version] != NSOrderedSame)) {
        [[NSUserDefaults standardUserDefaults] setObject:self.version forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString    *uniqueIdentifier = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueIdentifier"]) {
        uniqueIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueIdentifier"];
    }
    if ((uniqueIdentifier == nil) || ([uniqueIdentifier compare:self.uniqueIdentifier] != NSOrderedSame)) {
        [[NSUserDefaults standardUserDefaults] setObject:self.uniqueIdentifier forKey:@"uniqueIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)_loadDefaults
{
    DBGMSG(@"%s", __func__);
    
    NSString    *versionString = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
        versionString = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    }
    if ((versionString == nil) || ([versionString compare:self.version] != NSOrderedSame)) {
        /* バージョン不一致対応 */
        [self _clearDefaults];
        self.uniqueIdentifier = [[NSUUID UUID] UUIDString];
    }
    else {
        /* 読み出し */
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueIdentifier"]) {
            self.uniqueIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueIdentifier"];
        }
    }
}

- (NSString*)_modelDir
{
    NSArray*    paths;
    NSString*   path;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] < 1) {
        return nil;
    }
    path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:@".model"];
    return path;
}

- (NSString*)_modelPath
{
    NSString*   path;
    path = [[self _modelDir] stringByAppendingPathComponent:@"model.dat"];
    return path;
}

@end
