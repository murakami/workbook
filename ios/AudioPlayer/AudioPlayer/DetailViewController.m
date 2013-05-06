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
@property (strong, nonatomic) AVPlayerItem  *playerItem;
@property (strong, nonatomic) AVPlayer      *player;
@property (assign, nonatomic) id            playerTimeObserver;
- (void)_updateCurrentTimeSlider;
- (void)_updateRateSlider;
- (void)_playerDidPlayToEndTime:(NSNotification *)notification;
- (void)_playerTimeJumped:(NSNotification *)notification;
@end

@implementation DetailViewController

@synthesize currentTimeSlider = _currentTimeSlider;
@synthesize rateSlider = _rateSlider;
@synthesize dict = _dict;
@synthesize playerItem = _playerItem;
@synthesize player = _player;
@synthesize playerTimeObserver = _playerTimeObserver;

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
    
    /* 選択された曲 */
    NSURL       *url = [self.dict objectForKey:@"URL"];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    /* 再生位置（先頭） */
    self.currentTimeSlider.minimumValue = 0.0;
    self.currentTimeSlider.maximumValue = CMTimeGetSeconds(self.playerItem.duration);
    self.currentTimeSlider.value = 0.0;
    
    /* 生成速度（停止） */
    self.rateSlider.minimumValue = 0.0;
    self.rateSlider.maximumValue = 2.0;
    self.rateSlider.value = 0.0;
    
    /* 再生位置の更新 */
    const double interval = (0.5f * self.currentTimeSlider.maximumValue)
                            / self.currentTimeSlider.bounds.size.width;
    const CMTime time     = CMTimeMakeWithSeconds(interval, NSEC_PER_SEC);
    __block DetailViewController * __weak blockWeakSelf = self;
    self.playerTimeObserver = [self.player addPeriodicTimeObserverForInterval:time
                                                                        queue:NULL
                                                                   usingBlock:^( CMTime time ) {
                                                                       DetailViewController *tempSelf = blockWeakSelf;
                                                                       if (! tempSelf) return;
                                                                       [tempSelf _updateCurrentTimeSlider];
                                                                   }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_playerDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_playerTimeJumped:)
                                                 name:AVPlayerItemTimeJumpedNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.playerTimeObserver) {
        [self.player removeTimeObserver:self.playerTimeObserver];
        self.playerTimeObserver = nil;
    }
    
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
    self.playerItem = nil;
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
    if (0.0 == self.rateSlider.value) {
        self.player.rate = 1.0;
        [self _updateRateSlider];
    }
}

- (IBAction)stop:(id)sender
{
    //[self.player pause];
    self.player.rate = 0.0;
    [self _updateRateSlider];
}

- (IBAction)currentTimeSliderDidChanged:(id)sender
{
    [self.player seekToTime:CMTimeMakeWithSeconds(self.currentTimeSlider.value, NSEC_PER_SEC)];
}

- (IBAction)rateSliderDidChanged:(id)sender
{
    self.player.rate = self.rateSlider.value;
}

- (void)_updateCurrentTimeSlider
{
    const double duration = CMTimeGetSeconds( [self.player.currentItem duration] );
    const double time     = CMTimeGetSeconds([self.player currentTime]);
    const float  value    = (self.currentTimeSlider.maximumValue - self.currentTimeSlider.minimumValue )
                            * time / duration + self.currentTimeSlider.minimumValue;
    
    [self.currentTimeSlider setValue:value];
}

- (void)_updateRateSlider
{
    self.rateSlider.value = self.player.rate;
}

- (void)_playerDidPlayToEndTime:(NSNotification *)notification
{
    DBGMSG(@"%s", __func__);
    [self.player seekToTime:CMTimeMakeWithSeconds(0.0, NSEC_PER_SEC)];
    self.player.rate = 0.0;
    [self currentTimeSliderDidChanged:nil];
}

- (void)_playerTimeJumped:(NSNotification *)notification
{
    DBGMSG(@"%s", __func__);
}

@end
