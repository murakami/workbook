//
//  DetailViewController.m
//  StateRestoration
//
//  Created by 村上 幸雄 on 13/08/18.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "Document.h"
#import "DetailViewController.h"

static NSString *kUnsavedDetailItemIndexKey = @"unsavedDetailItemIndexKey";

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItemIndex = _detailItemIndex;

#pragma mark - Managing the detail item

- (void)setDetailItemIndex:(NSInteger)newDetailItemIndex
{
    if (self.detailItemIndex != newDetailItemIndex) {
        self.detailItemIndex = newDetailItemIndex;
        
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItemIndex) {
        NSDate  *object = [Document sharedDocument].objects[self.detailItemIndex];
        self.detailDescriptionLabel.text = [object description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"MasterViewController: encodeRestorableStateWithCoder");
    [super encodeRestorableStateWithCoder:coder];
    [[Document sharedDocument] save];
    [coder encodeInteger:self.detailItemIndex forKey:kUnsavedDetailItemIndexKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"MasterViewController: decodeRestorableStateWithCoder");
    [super decodeRestorableStateWithCoder:coder];
    self.detailItemIndex = [coder decodeBoolForKey:kUnsavedDetailItemIndexKey];
    [self configureView];
}

@end
