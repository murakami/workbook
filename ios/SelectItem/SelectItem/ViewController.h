//
//  ViewController.h
//  SelectItem
//
//  Created by 村上 幸雄 on 12/02/11.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"
#import "MyImageView.h"
#import "MyLabel.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet MyImageView  *itemImageView;
@property (strong, nonatomic) IBOutlet MyLabel      *itemLabel;
@property (strong, nonatomic) Document              *document;

- (IBAction)selectImage:(id)sender;
- (IBAction)selectLabel:(id)sender;

@end
