//
//  ViewController.m
//  PerformanceMonitor
//
//  Created by 村上幸雄 on 2020/12/15.
//

#import "PerformanceMonitor.h"
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSTimer   *timer;
- (void)update:(NSTimer*)timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self
                                                selector:@selector(update:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self measurement:nil];
}

- (void)update:(NSTimer*)timer
{
    [self measurement:nil];
}

- (IBAction)measurement:(id)sender
{
    NSMutableString *text = [[NSMutableString alloc] initWithString:@""];
    
    [[PerformanceMonitor sharedInstance] updateCpuInfo];
    
    PerformanceMonitor *pm = [PerformanceMonitor sharedInstance];
    [text appendFormat:@"物理メモリサイズ[byte]:%ld\n", [pm hwMemSize]];
    [text appendFormat:@"ユーザメモリサイズ[byte]:%ld\n", [pm hwUserMem]];
    [text appendFormat:@"仮想記憶の空きメモリサイズ[byte]:%ld\n", [pm freeMemory]];
    [text appendFormat:@"Machタスクで領域確保したサイズ[byte]:%ld\n", [pm processMemory]];
    [text appendFormat:@"CPU usage: %.1lf%%%% user, %.1lf%%%% sys, %.1lf%%%% idle\n", pm.cpuUser, pm.cpuSys, pm.cpuIdle];
    [text appendFormat:@"端末のディスクの%%freesize[byte]:%ld\n", [pm diskFreeSize]];
    [text appendFormat:@"バッテリーのレベル:%1.1f\n", [pm batteryLevel]];
    [text appendFormat:@"バッテリーの状態:%@\n", [pm batteryState]];
    [text appendFormat:@"ラスタライズ 画面 幅:%.0lf\n", [pm currentModeWidth]];
    [text appendFormat:@"ラスタライズ 画面 高さ:%.0lf\n", [pm currentModeHeight]];
    [text appendFormat:@"ラスタライズ 画面 スケール値:%1.1lf\n", [pm screenScale]];
    [text appendFormat:@"デバイス 画面 スケール値:%1.1lf\n", [pm nativeScale]];

    self.textView.text = text;
    
    self.label.text = [NSString stringWithFormat:@"%2.2lf[fps]", pm.fps];
}

@end
