//
//  ResponseParser.m
//  AudioPlayer
//
//  Created by 村上幸雄 on 2014/04/30.
//  Copyright (c) 2014年 Bitz Co., Ltd. All rights reserved.
//

#import "ResponseParser.h"

@interface ResponseParser ()
@property (assign, readwrite, nonatomic) ResponseParserState    state;
- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription;
@end

@implementation ResponseParser

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        _state = kResponseParserStateNone;
        _error = nil;
        _delegate = nil;
        _parseHandler = NULL;
        _cancelHandler = NULL;
        _completionHandler = NULL;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    self.state = kResponseParserStateNone;
    self.error = nil;
    self.delegate = nil;
    self.parseHandler = NULL;
    self.cancelHandler = NULL;
    self.completionHandler = NULL;
}

- (void)parse
{
    DBGMSG(@"%s", __func__);
    
    if (self.parseHandler) {
        self.parseHandler(self);
    }
    
    /* 通信中インジケータの更新 */
    [self willChangeValueForKey:@"networkState"];
    self.state = kResponseParserStateInProgress;
    [self didChangeValueForKey:@"networkState"];

    if ([self.delegate respondsToSelector:@selector(parserParsing:)]) {
        [self.delegate parserParsing:self];
    }
}

- (void)cancel
{
    DBGMSG(@"%s", __func__);
    
    if (self.cancelHandler) {
        self.cancelHandler(self);
    }
    
    /* 通信中インジケータの更新 */
    [self willChangeValueForKey:@"networkState"];
    self.state = kResponseParserStateInProgress;
    [self didChangeValueForKey:@"networkState"];
    
    if ([self.delegate respondsToSelector:@selector(parserDidCancel:)]) {
        [self.delegate parserDidCancel:self];
    }
}

- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription
{
    NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    NSError         *error = [NSError errorWithDomain:@"ResponseParser" code:code userInfo:userInfo];
    return error;
}

@end
