//
//  main.m
//  base64
//
//  Created by 村上 幸雄 on 12/05/23.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base64.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        DBGMSG(@"GIF89");
        NSData  *data = [[NSData alloc] initWithBytes:"GIF89" length:5];
        NSString    *str = [Base64 encodeBase64:data];
        DBGMSG(@"%@", str);
    }
    return 0;
}

