//
//  ViewController.m
//  REST
//
//  Created by 村上 幸雄 on 12/04/29.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize textView = _textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    self.textView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)sendPost:(id)sender
{
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people.xml"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString    *content = @"<person><name>Yukio MURAKAMI</name><age>17</age></person>";
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse   *response = nil;
    NSError *error = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString    *t = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], s];
        self.textView.text = t;
        NSLog(@"%@", self.textView.text);
    }
    else {
        NSString    *s = [[NSString alloc] initWithFormat:@"error: %@", error];
        self.textView.text = s;
        NSLog(@"%@", self.textView.text);
    }
}

- (IBAction)sendGet:(id)sender
{
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people/1.xml"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse   *response = nil;
    NSError *error = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString    *t = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], s];
        self.textView.text = t;
        NSLog(@"%@", self.textView.text);
    }
    else {
        NSString    *s = [[NSString alloc] initWithFormat:@"error: %@", error];
        self.textView.text = s;
        NSLog(@"%@", self.textView.text);
    }
}

- (IBAction)sendGetList:(id)sender
{
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people.xml"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse   *response = nil;
    NSError *error = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString    *t = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], s];
        self.textView.text = t;
        NSLog(@"%@", self.textView.text);
    }
    else {
        NSString    *s = [[NSString alloc] initWithFormat:@"error: %@", error];
        self.textView.text = s;
        NSLog(@"%@", self.textView.text);
    }
}

- (IBAction)sendPut:(id)sender
{
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people/1.xml"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    NSString    *content = @"<person><name>Yukio MURAKAMI</name><age>96</age></person>";
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse   *response = nil;
    NSError *error = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString    *t = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], s];
        self.textView.text = t;
        NSLog(@"%@", self.textView.text);
    }
    else {
        NSString    *s = [[NSString alloc] initWithFormat:@"error: %@", error];
        self.textView.text = s;
        NSLog(@"%@", self.textView.text);
    }
}

- (IBAction)sendDelete:(id)sender
{
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people/1.xml"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"DELETE"];
    NSHTTPURLResponse   *response = nil;
    NSError *error = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString    *t = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], s];
        self.textView.text = t;
        NSLog(@"%@", self.textView.text);
    }
    else {
        NSString    *s = [[NSString alloc] initWithFormat:@"error: %@", error];
        self.textView.text = s;
        NSLog(@"%@", self.textView.text);
    }
}

@end
