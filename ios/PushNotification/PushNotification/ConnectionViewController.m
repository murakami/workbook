//
//  ConnectionViewController.m
//  PushNotification
//
//  Created by 村上 幸雄 on 12/05/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ConnectionViewController.h"

static NSString *kHTTPErrorDomain = @"HTTPErrorDomain";

@interface ConnectionViewController ()

@end

@implementation ConnectionViewController

@synthesize urlRequest = _urlRequest;
@synthesize urlConnection = _urlConnection;
@synthesize downloadedData = _downloadedData;
@synthesize urlResponse = _urlResponse;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DBGMSG(@"%s", __func__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.urlRequest = nil;
        self.urlConnection = nil;
        self.downloadedData = nil;
        self.urlResponse = nil;
    }
    return self;
}

- (void)dealloc
{
    self.urlRequest = nil;
    self.urlConnection = nil;
    self.downloadedData = nil;
    self.urlResponse = nil;
    /* [super dealloc]; */
}

- (void)viewDidLoad
{
    DBGMSG(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    DBGMSG(@"%s", __func__);
    self.urlRequest = nil;
    self.urlConnection = nil;
    self.downloadedData = nil;
    self.urlResponse = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidAppear:animated];
    
    NSURLRequest    *urlRequest = self.urlRequest;
    if (!urlRequest) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Connection Error"
                 message:@"Could't open the connection"
                 delegate:nil
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        [alert show];
        [self dismissModalViewControllerAnimated:NO];
        return;
    }
    self.downloadedData = nil;
    self.urlResponse = nil;
    self.urlConnection = [NSURLConnection connectionWithRequest:self.urlRequest delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DBGMSG(@"%s", __func__);
    [self dismissModalViewControllerAnimated:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DBGMSG(@"%s", __func__);
    UIAlertView *alert;
    NSString    *errorMessage = @"Error occurred.";
    
    if (error) {
        errorMessage = [errorMessage stringByAppendingString:[error localizedDescription]];
    }
    
    alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                       message:errorMessage
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
    [self dismissModalViewControllerAnimated:NO];
}

- (void)connection:(NSURLConnection *)connection dedReceiveResponse:(NSURLResponse *)response
{
    DBGMSG(@"%s", __func__);
    self.urlResponse = response;
    if ([self.urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger   statusCode = [(NSHTTPURLResponse *)self.urlResponse statusCode];
        if (400 <= statusCode) {
            [connection cancel];
            NSError         *error = nil;
            NSString        *errStr = nil;
            NSDictionary    *userInfo = nil;
            
            errStr = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            if (errStr) {
                userInfo = [NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey];
            }
            
            error = [NSError errorWithDomain:kHTTPErrorDomain code:statusCode userInfo:userInfo];
            
            [self connection:connection didFailWithError:error];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DBGMSG(@"%s", __func__);
    if (!self.downloadedData) {
        self.downloadedData = [NSMutableData dataWithCapacity:0];
    }
    [self.downloadedData appendData:data];
}

- (IBAction)cancel:(id)sender
{
    DBGMSG(@"%s", __func__);
    [self.urlConnection cancel];
    [self dismissModalViewControllerAnimated:NO];
}

@end
