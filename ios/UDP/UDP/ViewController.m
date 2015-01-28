//
//  ViewController.m
//  UDP
//
//  Created by 村上幸雄 on 2015/01/18.
//  Copyright (c) 2015年 村上幸雄. All rights reserved.
//

#import "ViewController.h"
#import "UDP.h"

@interface ViewController () <UDPDelegate>
@property UDP *server;
@property UDP *client;

- (void)runServerOnPort:(NSUInteger)port;
- (void)runClientWithHost:(NSString *)host port:(NSUInteger)port;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self runServerOnPort:3054];
    [self runClientWithHost:@"localhost" port:3054];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)send:(id)sender
{
    NSLog(@"%s", __func__);
    NSData *data = [[NSString stringWithString:self.inputTextField.text] dataUsingEncoding:NSUTF8StringEncoding];
    [self.client sendData:data];
}

- (void)runServerOnPort:(NSUInteger)port
{
    NSLog(@"%s", __func__);
    self.server = [[UDP alloc] init];
    self.server.delegate = self;
    [self.server startServerOnPort:port];
}

- (void)runClientWithHost:(NSString *)host port:(NSUInteger)port
{
    NSLog(@"%s", __func__);
    self.client = [[UDP alloc] init];
    self.client.delegate = self;
    [self.client startConnectedToHostName:host port:port];
}

- (void)udp:(UDP *)udp didReceiveData:(NSData *)data fromAddress:(NSData *)addr
{
    NSLog(@"%s data(%@)", __func__, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.outputLabel.text = msg;
}

- (void)udp:(UDP *)udp didReceiveError:(NSError *)error
{
    NSLog(@"%s", __func__);
    self.outputLabel.text = [error description];
}

- (void)udp:(UDP *)udp didSendData:(NSData *)data toAddress:(NSData *)addr
{
    NSLog(@"%s data(%@)", __func__, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)udp:(UDP *)udp didFailToSendData:(NSData *)data toAddress:(NSData *)addr error:(NSError *)error
{
    NSLog(@"%s", __func__);
    NSLog(@"failed with error: %@", [error description]);
}

- (void)udp:(UDP *)udp didStartWithAddress:(NSData *)address
{
    NSLog(@"%s", __func__);
}

- (void)udp:(UDP *)udp didStopWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    NSLog(@"failed with error: %@", [error description]);
}

@end
