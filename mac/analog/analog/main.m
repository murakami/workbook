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
        NSFileHandle    *fhi = [NSFileHandle fileHandleWithStandardInput];
        NSFileHandle    *fho = [NSFileHandle fileHandleWithStandardOutput];

        NSData  *datainput = [fhi readDataToEndOfFile];
        NSString    *str = [[NSString alloc] initWithData:datainput encoding:NSUTF8StringEncoding];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.+)\n|(.+)"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray    *array = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        NSTextCheckingResult    *matches;
        for (matches in array) {
            NSString    *s = [str substringWithRange:[matches rangeAtIndex:0]];
            NSData  *dataout = [[NSData alloc] initWithBytes:[s UTF8String] length:[s lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
            [fho writeData:dataout];
        }
    }
    return 0;
}

