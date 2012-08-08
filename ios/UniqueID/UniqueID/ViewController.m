//
//  ViewController.m
//  UniqueID
//
//  Created by 村上 幸雄 on 12/08/06.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import <Security/Security.h>
#import "ViewController.h"

@interface ViewController ()
- (NSString *)createUUID;
- (NSString *)loadKeychainServices;
- (void)removeKeychainService;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString    *uuidString = [self loadKeychainServices];
    NSLog(@"UUID:%@", uuidString);
    uuidString = [self loadKeychainServices];
    NSLog(@"UUID:%@", uuidString);
    [self removeKeychainService];
    uuidString = [self loadKeychainServices];
    NSLog(@"UUID:%@", uuidString);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSString *)createUUID
{
    CFUUIDRef   uuid = CFUUIDCreate(NULL);
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidString;
}

- (NSString *)loadKeychainServices
{
    NSString    *savedUUID = nil;
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setObject:(id)@"UUID" forKey:(__bridge id)kSecAttrGeneric];
    [query setObject:(id)@"UUID" forKey:(__bridge id)kSecAttrAccount];
    [query setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:(__bridge id)kSecAttrService];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    
    CFDictionaryRef attributesDictRef = nil;
    OSStatus    result = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&attributesDictRef);
    NSDictionary    *attributes = (__bridge_transfer NSDictionary *)attributesDictRef;
    if (result == noErr) {
        query = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
        CFDataRef   dataRef;
        result = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&dataRef);
        NSData  *data = (__bridge_transfer NSData *)dataRef;
        if (result == noErr) {
            savedUUID = [[NSString alloc] initWithBytes:[data bytes]
                                                 length:[data length]
                                               encoding:NSUTF8StringEncoding];
        }
    }
    if (! savedUUID) {
        savedUUID = [self createUUID];
        query = [[NSMutableDictionary alloc] init];
        [query setObject:(id)@"UUID" forKey:(__bridge id)kSecAttrGeneric];
        [query setObject:(id)@"UUID" forKey:(__bridge id)kSecAttrAccount];
        [query setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:(__bridge id)kSecAttrService];
        [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [query setObject:(id)@"UUID" forKey:(__bridge id)kSecAttrLabel];
        [query setObject:(id)@"UUID" forKey:(__bridge id)kSecAttrDescription];
        [query setObject:(id)[savedUUID dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        result = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        if (result != noErr) {
            savedUUID = nil;
        }
    }

    return savedUUID;
}

- (void)removeKeychainService
{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setObject:(id)@"UUID" forKey:(__bridge id)kSecAttrGeneric];
    [query setObject:(id)@"UUID" forKey:(__bridge id)kSecAttrAccount];
    [query setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:(__bridge id)kSecAttrService];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef)query);
    if (result != noErr) {
    }
}

@end
