//
//  ViewController.m
//  PushNotification
//
//  Created by 村上 幸雄 on 12/05/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ConnectionViewController.h"
#import "ViewController.h"

static NSString *kReceiveNotification = @"receiveNotification";
static NSString *kURL = @"http://bitz.local/PushNotification/register.php";

@interface ViewController ()

@end

@implementation ViewController

@synthesize receiveNotificationSwitch = _receiveNotificationSwitch;
@synthesize connectionViewController = _connectionViewController;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.connectionViewController = nil;
    }
    return self;
}

- (void)dealloc
{
    self.connectionViewController = nil;
    self.receiveNotificationSwitch = nil;
    /* [super dealloc]; */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults  *userDefault = nil;
    userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:kReceiveNotification]) {
        int types = (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert);
        UIApplication   *appl = [UIApplication sharedApplication];
        [appl registerForRemoteNotificationTypes:types];
        self.receiveNotificationSwitch.on = YES;
    }
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

- (IBAction)toggleReceiveNotification:(id)sender
{
    if (self.receiveNotificationSwitch.on) {
        int types = (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert);
        UIApplication   *appl = [UIApplication sharedApplication];
        [appl registerForRemoteNotificationTypes:types];
    }
    else {
        UIApplication   *appl = [UIApplication sharedApplication];
        [appl unregisterForRemoteNotifications];
    }
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString    *str = [self hexDumpString:deviceToken];
    if (!str)
        return;
    
    NSDictionary    *dict = [NSDictionary dictionaryWithObject:str forKey:@"token"];
    NSData  *data = [self formEncodedDataFromDictionary:dict];
    
    NSURL   *url = [NSURL URLWithString:kURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    ConnectionViewController    *viewController = [self.storyboard
                                                   instantiateViewControllerWithIdentifier:@"ConnectionViewController"];
    viewController.urlRequest = request;
    [self presentModalViewController:viewController animated:NO];
    
    if (viewController.view.window) {
        self.connectionViewController = viewController;
        NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:kReceiveNotification];
    }
}

- (NSString *)hexDumpString:(NSData *)data
{
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    const unsigned char *p = (const unsigned char *)[data bytes];
    const unsigned char *pend = p + [data length];
    for (; p != pend; p++) {
        [str appendFormat:@"%02X", *p];
    }
    return str;
}

- (NSData *)formEncodedDataFromDictionary:(NSDictionary *)dict
{
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (NSString *key in [dict allKeys]) {
        @autoreleasepool {
            NSString    *name = key;
            NSString    *value = [dict objectForKey:key];
            name = [name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            value = [value stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([str length] > 0) {
                [str appendString:@"&"];
            }
            [str appendFormat:@"%@=%@", name, value];
        }
    }
    NSData  *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    self.receiveNotificationSwitch.on = NO;
    
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kReceiveNotification];
    
    NSString    *str = [error localizedDescription];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
