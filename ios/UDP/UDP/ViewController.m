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
@property (nonatomic, strong, readwrite) NSTimer *      sendTimer;
@property (nonatomic, assign, readwrite) NSUInteger     sendCount;

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
}

- (void)runServerOnPort:(NSUInteger)port
{
    assert(self.server == nil);
    
    self.server = [[UDP alloc] init];
    assert(self.server != nil);
    
    self.server.delegate = self;
    
    [self.server startServerOnPort:port];
    
    while (self.server != nil) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    // The loop above is supposed to run forever.  If it doesn't, something must
    // have failed and we want main to return EXIT_FAILURE.
    
    //return NO;
}

- (void)runClientWithHost:(NSString *)host port:(NSUInteger)port
{
    assert(host != nil);
    assert( (port > 0) && (port < 65536) );
    
    assert(self.client == nil);
    
    self.client = [[UDP alloc] init];
    assert(self.client != nil);
    
    self.client.delegate = self;
    
    [self.client startConnectedToHostName:host port:port];
    
    while (self.client != nil) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    // The loop above is supposed to run forever.  If it doesn't, something must
    // have failed and we want main to return EXIT_FAILURE.
    
    //return NO;
}

- (void)sendPacket
{
    NSData *    data;
    
    assert(self.client != nil);
    assert( ! self.client.isServer );
    
    data = [[NSString stringWithFormat:@"%zu bottles of beer on the wall", (99 - self.sendCount)] dataUsingEncoding:NSUTF8StringEncoding];
    assert(data != nil);
    
    [self.client sendData:data];
    
    self.sendCount += 1;
    if (self.sendCount > 99) {
        self.sendCount = 0;
    }
}

- (void)udp:(UDP *)udp didReceiveData:(NSData *)data fromAddress:(NSData *)addr
{
    assert(udp == self.server);
#pragma unused(udp)
    assert(data != nil);
    assert(addr != nil);
    NSLog(@"received %@ from %@", DisplayStringFromData(data), DisplayAddressForAddress(addr));
}

- (void)udp:(UDP *)udp didReceiveError:(NSError *)error
{
    assert(udp == self.server);
#pragma unused(echo)
    assert(error != nil);
    NSLog(@"received error: %@", DisplayErrorFromError(error));
}

- (void)udp:(UDP *)udp didSendData:(NSData *)data toAddress:(NSData *)addr
{
    assert(udp == self.client);
#pragma unused(udp)
    assert(data != nil);
    assert(addr != nil);
    NSLog(@"    sent %@ to   %@", DisplayStringFromData(data), DisplayAddressForAddress(addr));
}

- (void)udp:(UDP *)udp didFailToSendData:(NSData *)data toAddress:(NSData *)addr error:(NSError *)error
{
    assert(udp == self.client);
#pragma unused(udp)
    assert(data != nil);
    assert(addr != nil);
    assert(error != nil);
    NSLog(@" sending %@ to   %@, error: %@", DisplayStringFromData(data), DisplayAddressForAddress(addr), DisplayErrorFromError(error));
}

- (void)udp:(UDP *)udp didStartWithAddress:(NSData *)address
{
    assert(udp == self.client);
#pragma unused(udp)
    assert(address != nil);
    
    if (self.client.isServer) {
        NSLog(@"receiving on %@", DisplayAddressForAddress(address));
    } else {
        NSLog(@"sending to %@", DisplayAddressForAddress(address));
    }
    
    if ( ! self.client.isServer ) {
        [self sendPacket];
        
        assert(self.sendTimer == nil);
        self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPacket) userInfo:nil repeats:YES];
    }
}

- (void)udp:(UDP *)udp didStopWithError:(NSError *)error
{
    assert(udp == self.client);
#pragma unused(udp)
    assert(error != nil);
    NSLog(@"failed with error: %@", DisplayErrorFromError(error));
    self.echo = nil;
}

@end
