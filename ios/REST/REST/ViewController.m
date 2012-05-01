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
@synthesize inPersonElement = _inPersonElement;
@synthesize inNameElement = _inNameElement;
@synthesize inAgeElement = _inAgeElement;
@synthesize name = _name;
@synthesize age = _age;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    self.textView = nil;
    self.name = nil;
    self.age = nil;
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

        if (data) {
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            xmlParser.delegate = self;
            [xmlParser parse];
        }
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
        
        if (data) {
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            xmlParser.delegate = self;
            [xmlParser parse];
        }
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
        
        if (data) {
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            xmlParser.delegate = self;
            [xmlParser parse];
        }
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
        
        if (data) {
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            xmlParser.delegate = self;
            [xmlParser parse];
        }
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
        
        if (data) {
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            xmlParser.delegate = self;
            [xmlParser parse];
        }
    }
    else {
        NSString    *s = [[NSString alloc] initWithFormat:@"error: %@", error];
        self.textView.text = s;
        NSLog(@"%@", self.textView.text);
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"%s", __func__);
    self.inPersonElement = NO;
    self.inNameElement = NO;
    self.inAgeElement = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"%s", __func__);
}

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%s, %@", __func__, elementName);
    if ([elementName isEqualToString:@"person"]) {
        self.inPersonElement = YES;
    }
    else if ([elementName isEqualToString:@"name"]) {
        self.inNameElement = YES;
        self.name = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString:@"age"]) {
        self.inAgeElement = YES;
        self.age = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser
    didEndElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
{
    NSLog(@"%s, %@", __func__, elementName);
    if ([elementName isEqualToString:@"person"]) {
        self.inPersonElement = NO;
        NSLog(@"person(name[%@], age[%@])", self.name, self.age);
    }
    else if ([elementName isEqualToString:@"name"]) {
        self.inNameElement = NO;
    }
    else if ([elementName isEqualToString:@"age"]) {
        self.inAgeElement = NO;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"%s, person(%d), name(%d), age(%d), string(%@)",
          __func__, (int)self.inPersonElement, (int)self.inNameElement, (int)self.inAgeElement, string);
    
    if (self.inPersonElement) {
    }
    
    if (self.inNameElement) {
        [self.name appendString:string];
        NSLog(@"name(%@)", self.name);
    }
    else if (self.inAgeElement) {
        [self.age appendString:string];
        NSLog(@"age(%@)", self.age);
    }
}

@end
