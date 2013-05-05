//
//  DetailViewController.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/04/25.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) AVPlayer  *player;
@end

@implementation DetailViewController

@synthesize dict = _dict;
@synthesize player = _player;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    DBGMSG(@"%s, dict:%@", __func__, self.dict);
    [super viewWillAppear:animated];
    
    NSURL       *url = [self.dict objectForKey:@"URL"];
    AVPlayerItem    *playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    self.dict = nil;
    self.player = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)play:(id)sender
{
    //[self.player play];
    if (0.0 == self.player.rate)    self.player.rate = 1.0;
    else if (1.0 == self.player.rate)    self.player.rate = 0.75;
    else if (0.75 == self.player.rate)    self.player.rate = 0.5;
    else if (0.5 == self.player.rate)    self.player.rate = 0.0;
}

@end
