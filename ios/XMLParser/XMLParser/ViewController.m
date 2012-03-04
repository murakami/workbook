//
//  ViewController.m
//  XMLParser
//
//  Created by 村上 幸雄 on 12/03/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)parseXMLFile:(NSURL *)url;
@end

@implementation ViewController

@synthesize elementName = _elementName;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString    *requestString = [NSString stringWithString:@"http://www.kyuden.co.jp/power_usages/xml/electric_power_usage20120304.xml"];
    NSURL   *url = [NSURL URLWithString:requestString];
    [self parseXMLFile:url];
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

- (void)parseXMLFile:(NSURL *)url
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if (elementName) {
        NSLog(@"element: %@", elementName);
        self.elementName = elementName;
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.elementName) {
        self.elementName = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ((self.elementName)
        && (![self.elementName isEqualToString:@""])
        && (string)) {
        NSLog(@"char: %@", string);
    }
}

@end
