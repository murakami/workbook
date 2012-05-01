//
//  ViewController.h
//  REST
//
//  Created by 村上 幸雄 on 12/04/29.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITextView   *textView;
@property (assign, nonatomic) BOOL                  inPersonElement;
@property (assign, nonatomic) BOOL                  inNameElement;
@property (assign, nonatomic) BOOL                  inAgeElement;
@property (strong, nonatomic) NSMutableString       *name;
@property (strong, nonatomic) NSMutableString       *age;

- (IBAction)sendPost:(id)sender;
- (IBAction)sendGet:(id)sender;
- (IBAction)sendGetList:(id)sender;
- (IBAction)sendPut:(id)sender;
- (IBAction)sendDelete:(id)sender;

@end
