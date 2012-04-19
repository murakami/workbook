//
//  ViewController.m
//  Tweets
//
//  Created by 村上 幸雄 on 12/04/20.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)displayText:(NSString *)text;
- (void)canTweetStatus;
@end

@implementation ViewController

@synthesize tweetStatusLabel = _tweetStatusLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canTweetStatus) name:ACAccountStoreDidChangeNotification object:nil];
}

- (void)viewDidUnload
{
    self.tweetStatusLabel = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self canTweetStatus];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)tweet:(id)sender
{
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    [tweetViewController setInitialText:@"hello, world"];
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                output = @"Tweet done.";
                break;
            default:
                break;
        }
        
        [self performSelectorOnMainThread:@selector(displayText:)
                               withObject:output
                            waitUntilDone:NO];
        
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    [self presentModalViewController:tweetViewController animated:YES];
}

- (void)displayText:(NSString *)text
{
    self.tweetStatusLabel.text = text;
}

- (void)canTweetStatus {
    if ([TWTweetComposeViewController canSendTweet]) {
        self.tweetStatusLabel.text = @"can send tweet";
    }
    else {
        self.tweetStatusLabel.text = @"can't send tweet";
    }
}

@end
