//
//  main.m
//  analog
//
//  Created by 村上 幸雄 on 12/06/28.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool {        
#ifndef DEBUG
        NSFileHandle    *fhi = [NSFileHandle fileHandleWithStandardInput];
#endif
        NSFileHandle    *fho = [NSFileHandle fileHandleWithStandardOutput];

#ifndef DEBUG
        NSData  *datainput = [fhi readDataToEndOfFile];
        NSString    *str = [[NSString alloc] initWithData:datainput encoding:NSUTF8StringEncoding];
#else
        NSString    *str = @"12:23:45 start\n1,10\n2,13";
#endif
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.+)\n|(.+)"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray    *array = [regex matchesInString:str
                                           options:0
                                             range:NSMakeRange(0, str.length)];
        NSTextCheckingResult    *matches;
        for (matches in array) {
            NSString    *line = [str substringWithRange:[matches rangeAtIndex:0]];

#ifdef DEBUG
            NSData  *dataout = [[NSData alloc] initWithBytes:[line UTF8String]
                                                      length:[line lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
            [fho writeData:dataout];
#endif
            
            NSCharacterSet  *charSet = [NSCharacterSet newlineCharacterSet];
            line = [line stringByTrimmingCharactersInSet:charSet];

            regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d\\d:\\d\\d:\\d\\d)"
                                                              options:NSRegularExpressionCaseInsensitive
                                                                error:&error];
            NSTextCheckingResult    *match = [regex firstMatchInString:line
                                                               options:0
                                                                 range:NSMakeRange(0, line.length)];
            if (0 < [match numberOfRanges]) {
                NSString    *tm = [line substringWithRange:[match rangeAtIndex:0]];
                NSLog(@"time: %@", tm);
            }
        }
    }
    return 0;
}

