//
//  main.m
//  uuid
//
//  Created by 村上幸雄 on 2014/02/10.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSUUID  *uuid = [NSUUID UUID];
        NSString    *uuidString = [uuid UUIDString];
        NSString    *str32 = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        DBGMSG(@"%s UUID(%@)", __func__, uuidString);
        printf("%s\n", str32.UTF8String);
        
    }
    return 0;
}

