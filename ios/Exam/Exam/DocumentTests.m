//
//  DocumentTests.m
//  Exam
//
//  Created by 村上 幸雄 on 12/06/05.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "AppDelegate.h"
#import "DocumentTests.h"

@implementation DocumentTests

@synthesize document = _document;

- (void)setUp
{
    DBGMSG(@"%s", __func__);
    [super setUp];
    
    // Set-up code here.
    AppDelegate	*appl = nil;
	appl = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.document = appl.document;
}

- (void)testInit
{
    DBGMSG(@"%s", __func__);
    STAssertNotNil(_document, @"初期化失敗");
    STAssertFalse(self.document.version == nil, @"メンバーversion初期化不正");
    STAssertFalse(self.document.message == nil, @"メンバーmessage初期化不正");
}

- (void)tearDown
{
    DBGMSG(@"%s", __func__);
    // Tear-down code here.
    self.document = nil;
    
    [super tearDown];
}

- (void)testClearDefaults
{
    DBGMSG(@"%s", __func__);
    [self.document clearDefaults];
    STAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"message"], @"初期化失敗");
}

- (void)testUpdateDefaults
{
    DBGMSG(@"%s", __func__);
    NSString    *msg = [[NSDate date] description];
    self.document.message = msg;
    [self.document updateDefaults];
    STAssertNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"message"], @"初期化失敗");
    STAssertTrue([msg compare:[[NSUserDefaults standardUserDefaults] objectForKey:@"message"]] == NSOrderedSame,
                 @"メンバーmessage保存失敗");
}

- (void)testLoadDefaults
{
    DBGMSG(@"%s", __func__);
    [self.document loadDefaults];
    STAssertFalse(self.document.version == nil, @"メンバーversion読み出し不正");
    STAssertFalse(self.document.message == nil, @"メンバーmessage読み出し不正");
}

@end
