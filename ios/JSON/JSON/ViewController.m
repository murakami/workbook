//
//  ViewController.m
//  JSON
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
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *person = [NSMutableDictionary dictionary];
    [person setValue:@"MURAKAMI Yukio" forKey:@"name"];
    [person setValue:@"18" forKey:@"age"];
    NSMutableDictionary *people = [NSMutableDictionary dictionary];
    [people setValue:person forKey:@"person"];
    NSError *error = nil;
    NSData  *content = [NSJSONSerialization dataWithJSONObject:person options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:content];
    NSHTTPURLResponse   *response = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], content];
        self.textView.text = s;
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
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people/1.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse   *response = nil;
    NSError *error = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    NSDictionary    *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], content];
        self.textView.text = s;
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
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse   *response = nil;
    NSError *error = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    NSDictionary    *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], content];
        self.textView.text = s;
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
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people/1.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    NSMutableDictionary *person = [NSMutableDictionary dictionary];
    [person setValue:@"MURAKAMI Yukio" forKey:@"name"];
    [person setValue:@"81" forKey:@"age"];
    NSMutableDictionary *people = [NSMutableDictionary dictionary];
    [people setValue:person forKey:@"person"];
    NSError *error = nil;
    NSData  *content = [NSJSONSerialization dataWithJSONObject:person options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:content];
    NSHTTPURLResponse   *response = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], content];
        self.textView.text = s;
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
    NSURL   *url = [NSURL URLWithString:@"http://localhost:3000/people/1.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"DELETE"];
    NSHTTPURLResponse   *response = nil;
    NSError *error = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    NSDictionary    *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        NSString    *s = [[NSString alloc] initWithFormat:@"status code: %d\ndata: %@", [response statusCode], content];
        self.textView.text = s;
        NSLog(@"%@", self.textView.text);
    }
    else {
        NSString    *s = [[NSString alloc] initWithFormat:@"error: %@", error];
        self.textView.text = s;
        NSLog(@"%@", self.textView.text);
    }
}

@end
