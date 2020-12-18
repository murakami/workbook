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
- (void)load:(NSTimer*)timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(update:)
                                                userInfo:nil
                                                 repeats:YES];
    /*
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                  target:self
                                                selector:@selector(load:)
                                                userInfo:nil
                                                 repeats:YES];
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self measurement:nil];
    
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 100000; i++) {
            NSLog(@"%s %d", __func__, i);
            //sleep(1);
        }
    });
     */
}

- (void)update:(NSTimer*)timer
{
    [self measurement:nil];
}

- (void)load:(NSTimer*)timer
{
    for (int i = 0; i < 10; i++) {
        sleep(1);
    }
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
