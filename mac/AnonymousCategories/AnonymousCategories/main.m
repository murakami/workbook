//
//  main.m
//  AnonymousCategories
//
//  Created by 村上 幸雄 on 12/01/25.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject {
}
- (void)publicMethod;
@end

@interface MyClass ()
- (void)privateMethod;
@end

@implementation MyClass

- (void)publicMethod
{
    NSLog(@"%s", __func__);
    [self privateMethod];
}

- (void)privateMethod
{
    NSLog(@"%s", __func__);
}

@end

int main (int argc, const char * argv[])
{

    @autoreleasepool {
        
        MyClass *instance = [[MyClass alloc] init];
        [instance publicMethod];

    }
    return 0;
}

