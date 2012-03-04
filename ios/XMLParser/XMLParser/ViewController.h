//
//  ViewController.h
//  XMLParser
//
//  Created by 村上 幸雄 on 12/03/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate>
@property (strong, nonatomic) NSString  *elementName;
@end
