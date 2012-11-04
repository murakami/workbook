//
//  MapCurlStoryboardSegue.m
//  VirtualEarth
//
//  Created by 村上 幸雄 on 12/10/23.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MapCurlStoryboardSegue.h"

@interface MapCurlStoryboardSegue ()
@end

@implementation MapCurlStoryboardSegue

- (void)perform
{
    /*
    UIViewController *sourceViewController = (UIViewController *)self.sourceViewController;
    [UIView transitionWithView:sourceViewController.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        //[[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
                    }
                    completion:^(BOOL finished){
                        [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
                    }];
    */
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:YES];
}

@end
