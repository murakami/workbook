//
//  ViewController.h
//  SendLINE
//
//  Created by 村上幸雄 on 2014/05/14.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)sendLINE:(id)sender;

@end
