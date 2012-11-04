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
    DBGMSG(@"path:%@", path);
    NSURL   *fileURL = [[NSURL alloc] initFileURLWithPath:path];    /* URIにlocalhostが足されている */
    DBGMSG(@"fileURL:%@", fileURL);
    NSURLRequest    *req = [NSURLRequest requestWithURL:fileURL];
    DBGMSG(@"req:%@", req);
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
