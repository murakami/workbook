//
//  main.m
//  anonymous_categories
//
//  Created by 村上 幸雄 on 12/01/25.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject
@property (nonatomic, strong, readonly) NSMutableString   *string;
- (void)publicMethod;
@end

@interface MyClass ()
@property (nonatomic, strong, readwrite) NSMutableString   *string;
- (void)privateMethod;
@end

@implementation MyClass

@synthesize string = _string;

- (void)publicMethod
{
    NSLog(@"%s", __func__);
    _string = [[NSMutableString alloc] initWithString:@"hello, world!"];
    [self privateMethod];
}

- (void)privateMethod
{
    NSLog(@"%s", __func__);
    NSLog(@"self.string: %@", self.string);
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

/* End Of File */
