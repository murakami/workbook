//
//  ModalPaneViewController.h
//  Dialog
//
//  Created by 村上 幸雄 on 12/05/28.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalPaneViewController;

typedef enum ModalPaneViewControllerResult {
    ModalPaneViewControllerResultCancelled,
    ModalPaneViewControllerResultDone
} ModalPaneViewControllerResult;

typedef void (^ModalPaneViewControllerCompletionHandler)(ModalPaneViewControllerResult result);

@protocol ModalPaneViewControllerDelegate <NSObject>
- (void)modalPaneViewControllerDidDone:(ModalPaneViewController *)modalPaneViewController;
- (void)modalPaneViewControllerDidCancel:(ModalPaneViewController *)modalPaneViewController;
@end

@interface ModalPaneViewController : UIViewController

@property (nonatomic, weak) id<ModalPaneViewControllerDelegate>         delegate;
@property (nonatomic, copy) ModalPaneViewControllerCompletionHandler    completionHandler;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

/* End Of File */