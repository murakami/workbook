//
//  ViewController.m
//  WebApp
//
//  Created by 村上 幸雄 on 12/02/26.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIWebView   *webView = (UIWebView *)self.view;
    webView.delegate = self;
    NSString    *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL   *fileURL = [[NSURL alloc] initFileURLWithPath:path];
    NSURLRequest    *req = [NSURLRequest requestWithURL:fileURL];
    [webView loadRequest:req];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString    *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	NSLog(@"%@", title);
    
    NSString    *date = [NSString stringWithFormat:@"document.getElementsByName('demo').item(0).value='%@'",
                         [NSDate date]];
	[webView stringByEvaluatingJavaScriptFromString:date];
}

@end
