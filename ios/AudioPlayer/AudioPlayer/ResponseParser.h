//
//  ResponseParser.h
//  AudioPlayer
//
//  Created by 村上幸雄 on 2014/04/30.
//  Copyright (c) 2014年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResponseParser;

#define kResponseParserNoError       0
#define kResponseParserGenericError  1

typedef enum _ResponseParserState {
    kResponseParserStateNone = 0,
    kResponseParserStateInProgress,
    kResponseParserStateFinished,
    kResponseParserStateError,
    kResponseParserStateCanceled,
} ResponseParserState;

typedef enum _ResponseParserCode {
    kResponseParserCodeSuccess = 0,
    kResponseParserCodeCancel,
    kResponseParserCodeFailure
} ResponseParserCode;

typedef void (^ResponseParserParseHandler)(ResponseParser *parser);
typedef void (^ResponseParserCancelHandler)(ResponseParser *parser);
typedef void (^ResponseParserCompletionHandler)(ResponseParser *parser);

@protocol ResponseParserDelegate <NSObject>
- (void)parserParsing:(ResponseParser *)parser;
- (void)parserDidFinishLoading:(ResponseParser *)parser;
- (void)parser:(ResponseParser *)parser didFailWithError:(NSError*)error;
- (void)parserDidCancel:(ResponseParser *)parser;
@end

@interface ResponseParser : NSObject

@property (assign, readonly, nonatomic) ResponseParserState state;
@property (strong, nonatomic) NSError                       *error;
@property (weak, nonatomic) id<ResponseParserDelegate>      delegate;
@property (copy, nonatomic) ResponseParserParseHandler      parseHandler;
@property (copy, nonatomic) ResponseParserCancelHandler     cancelHandler;
@property (copy, nonatomic) ResponseParserCompletionHandler completionHandler;

- (void)parse;
- (void)cancel;

@end
