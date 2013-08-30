//
//  Document.m
//  StateRestoration
//
//  Created by 村上 幸雄 on 13/08/18.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "Document.h"

@interface Document ()
- (void)_init;
- (void)_clearDefaults;
- (void)_updateDefaults;
- (void)_loadDefaults;
- (NSString*)_modelDir;
- (NSString*)_modelPath;
@end

@implementation Document

@synthesize version = _version;
@synthesize objects = _objects;

+ (Document *)sharedDocument;
{
    static Document *_sharedInstance = nil;
    if (!_sharedInstance) {
		_sharedInstance = [[Document alloc] init];
	}
	return _sharedInstance;
}

- (id)init
{
    DBGMSG(@"%s", __func__);
	if ((self = [super init]) != nil) {
        [self _init];
	}
	return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    self.version = nil;
}

- (void)load
{
    DBGMSG(@"%s", __func__);
    [self _loadDefaults];
    
    NSString    *modelPath = [self _modelPath];
    if ((! modelPath) || (! [[NSFileManager defaultManager] fileExistsAtPath:modelPath])) {
        return;
    }
    
    NSMutableArray  *objects;
    objects = [NSKeyedUnarchiver unarchiveObjectWithFile:modelPath];
    if (!objects) {
        return;
    }
    
    [self.objects setArray:objects];
}

- (void)save
{
    DBGMSG(@"%s", __func__);
    [self _updateDefaults];
    
    NSFileManager   *fileManager = [NSFileManager defaultManager];
    
    NSString    *modelDir = [self _modelDir];
    if (![fileManager fileExistsAtPath:modelDir]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:modelDir
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }
    
    NSString    *modelPath = [self _modelPath];
    [NSKeyedArchiver archiveRootObject:self.objects toFile:modelPath];
}

- (void)_init
{
    DBGMSG(@"%s", __func__);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.objects = [[NSMutableArray alloc] init];
}

- (void)_clearDefaults
{
    DBGMSG(@"%s", __func__);
}

- (void)_updateDefaults
{
    DBGMSG(@"%s", __func__);
    BOOL    fUpdate = NO;
    
    NSString    *aVersion = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
        aVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        DBGMSG(@"current aVersion:%@", aVersion);
    }
    if (self.version) {
        if ([aVersion compare:self.version] != NSOrderedSame) {
            [[NSUserDefaults standardUserDefaults] setObject:self.version forKey:@"version"];
            fUpdate = YES;
            DBGMSG(@"save version:%@", self.version);
        }
    }
    
    if (fUpdate) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)_loadDefaults
{
    DBGMSG(@"%s", __func__);
    NSString    *aVersion = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
        aVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    }
    if ([aVersion compare:self.version] != NSOrderedSame) {
        [self _clearDefaults];
    }
    else {
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
