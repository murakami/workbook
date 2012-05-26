//
//  Base64.m
//  base64
//
//  Created by 村上 幸雄 on 12/05/23.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "Base64.h"

#define BASE64PAD @"="

enum Base64DecodePolicy { FailOnInvalidCharacter, IgnoreWhitespace, IgnoreInvalidCharacters };

static const char   base64Alphabet[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/'
};
static const char   base64Pad = '=';

static const char   alphabetBase64[128] = {
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x3E, 0x00, 0x00, 0x00, 0x3F,
    0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B,
    0x3C, 0x3D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
    0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E,
    0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,
    0x17, 0x18, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20,
    0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28,
    0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30,
    0x31, 0x32, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00
};

@implementation Base64

+ (NSString *)encodeBase64:(NSData *)data
{
    /*
    Not supported: CRLF
    */
    if (! data) return nil;

    NSUInteger      dataLen = data.length;
    unsigned char   *dataBytes = (unsigned char *)[data bytes];
    NSMutableString *str = [[NSMutableString alloc] init];
    
    NSUInteger  dataIndex = 0;
    while (dataIndex < dataLen) {
        char    d[3] = {0, 0, 0};
        d[0] = dataBytes[dataIndex];
        if ((dataIndex + 1) < dataLen)
            d[1] = dataBytes[dataIndex + 1];
        if ((dataIndex + 2) < dataLen)
            d[2] = dataBytes[dataIndex + 2];
        NSUInteger  bit6 = 0;
        char    s[5];
        
        bit6 = (d[0] >> 2) & 0x3F;
        s[0] = base64Alphabet[bit6];
        
        bit6 = ((d[1] >> 4) & 0x0F) | ((d[0] << 4) & 0x3F);
        s[1] = base64Alphabet[bit6];
        
        bit6 = ((d[2] >> 6) & 0x03) | ((d[1] << 2) & 0x3F);
        s[2] = base64Alphabet[bit6];
        
        bit6 = d[2] & 0x3F;
        s[3] = base64Alphabet[bit6];
        
        s[4] = '\0';
        
        [str appendString:[NSString stringWithCString:s encoding:NSASCIIStringEncoding]];

        dataIndex += 3;
    }
    if (dataIndex < dataLen) {
        NSRange aRange = NSMakeRange(dataLen + 2, (dataIndex - dataLen));
        [str replaceCharactersInRange:(NSRange)aRange withString:BASE64PAD];
    }
 
    NSUInteger  padNum = [str length] % 4;
    for (NSUInteger i = 0; i < padNum; i++) {
        [str appendString:BASE64PAD];
    }
    
    return str;
}

- (NSData *)decodeBase64:(NSString *)str
{
    if (! str)  return nil;
    return nil;
}

@end
