//
//  PerformanceMonitor.m
//  PerformanceMonitor
//
//  Created by 村上幸雄 on 2020/12/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach/mach.h>
#import <mach/mach_time.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import "PerformanceMonitor.h"

#ifdef    DEBUG
#define    DBGMSG(...)    NSLog(__VA_ARGS__)
#else    /* DEBUG */
#define    DBGMSG(...)
#endif    /* DEBUG */

#define TVAL2MSEC(tval) ((tval.seconds * 1000) + (tval.microseconds / 1000))
#define BYTE2MBYTE(size) (size / 1024 / 1024)

static NSString *const kBatteryStateUnknown = @"Unknown";
static NSString *const kBatteryStateUnplugged = @"Unplugged";
static NSString *const kBatteryStateCharging = @"Charging";
static NSString *const kBatteryStateFull = @"Full";

@interface BatStat : NSObject
@property (assign, nonatomic) float batteryLevel;
@property (assign, nonatomic) UIDeviceBatteryState batteryState;
+ (BatStat *)sharedInstance;
- (NSString *)batteryStateString;
- (void)batteryLevelChanged:(NSNotification *)notification;
- (void)batteryStateChanged:(NSNotification *)notification;
- (void)updateBatteryLevel;
- (void)updateBatteryState;
@end

@interface DeviceResolution : NSObject
+ (CGFloat)currentModeHeight;
+ (CGFloat)currentModeWidth;
+ (CGFloat)screenScale;
+ (CGFloat)nativeScale;
@end

@interface PerformanceMonitor ()
@property (strong, nonatomic) CADisplayLink *caDisplayLink;
@property (assign, nonatomic) CFTimeInterval prevTimestamp;
- (void)hostCpuLoadInfo:(host_cpu_load_info_t)cpucounters;
- (void)displayLinkAction:(CADisplayLink *)sender;
@end

@implementation PerformanceMonitor

+ (PerformanceMonitor *)sharedInstance
{
    static PerformanceMonitor *_sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PerformanceMonitor alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cpuUser = 0.0;
        _cpuSys = 0.0;
        _cpuIdle = 0.0;
        _fps = 0.0;
        _caDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        _caDisplayLink.paused = NO;
        [_caDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _prevTimestamp = 0.0;
    }
    return self;
}

- (void)dealloc
{
    [self.caDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.caDisplayLink.paused = YES;
    self.caDisplayLink = nil;
}

- (NSInteger)hwMemSize
{
    int64_t hw_mem_size = 0;
    int64_t val = 0;
    size_t valSiz = sizeof(val);
    int ids[2] = {CTL_HW, HW_MEMSIZE};
    int error = sysctl(ids, 2, &val, &valSiz, NULL, 0);
    if (error == 0) {
        hw_mem_size = val;
    }
    DBGMSG(@"%s HW_MEMSIZE %qx", __func__, hw_mem_size);
    return (NSInteger)hw_mem_size;
}

- (NSInteger)hwUserMem
{
    int64_t hw_user_mem = 0;
    int64_t val = 0;
    size_t valSiz = sizeof(val);
    int selection[2] = {CTL_HW, HW_USERMEM};
    int error = sysctl(selection, 2, &val, &valSiz, NULL, 0);
    if (error == 0) {
        hw_user_mem = val;
    }
    DBGMSG(@"%s HW_USERMEM: %qx", __func__, hw_user_mem);
    return (NSInteger)hw_user_mem;
}

- (NSInteger)freeMemory
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;

    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;

    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        DBGMSG(@"Failed to fetch vm statistics");
        return 0;
    }

    int64_t mem_free = (int64_t) vm_stat.free_count * pagesize;

    DBGMSG(@"%s free_memory: %qx", __func__, mem_free);
    return (NSInteger)mem_free;
}

- (NSInteger)processMemory
{
    struct task_basic_info basic_info;
    mach_msg_type_number_t t_info_count = TASK_BASIC_INFO_COUNT;
    kern_return_t status;

    status = task_info(current_task(), TASK_BASIC_INFO,
                       (task_info_t)&basic_info, &t_info_count);

    if (status != KERN_SUCCESS) {
        DBGMSG(@"%s(): Error in task_info(): %s", __FUNCTION__, strerror(errno));
        return 0;
    }

    int64_t mem_process = (int64_t) basic_info.resident_size;

    DBGMSG(@"%s process_memory: %qx", __func__, mem_process);
    return (NSInteger)mem_process;
}

- (void)updateCpuInfo
{
    static host_cpu_load_info_data_t lastcounters;
    static BOOL initFlag = NO;
    if (! initFlag) {
        [self hostCpuLoadInfo:&lastcounters];
        initFlag = YES;
    }

    host_cpu_load_info_data_t curcounters;
    [self hostCpuLoadInfo:&curcounters];
    double userticks = curcounters.cpu_ticks[CPU_STATE_USER] - lastcounters.cpu_ticks[CPU_STATE_USER];
    double systicks = curcounters.cpu_ticks[CPU_STATE_SYSTEM] - lastcounters.cpu_ticks[CPU_STATE_SYSTEM];
    double idleticks = curcounters.cpu_ticks[CPU_STATE_IDLE] - lastcounters.cpu_ticks[CPU_STATE_IDLE];
    double totalticks = userticks + systicks + idleticks;
    lastcounters = curcounters;

    if (totalticks != 0.0) {
        self.cpuUser = (100.0 * userticks) / totalticks;
        self.cpuSys = (100.0 * systicks) / totalticks;
        self.cpuIdle = (100.0 * idleticks) / totalticks;
    }
    DBGMSG(@"%s CPU usage: %.1lf%%%% user, %.1lf%%%% sys, %.1lf%%%% idle",
           __func__, self.cpuUser, self.cpuSys, self.cpuIdle);
}

- (void)hostCpuLoadInfo:(host_cpu_load_info_t)cpucounters
{
    mach_msg_type_number_t count = HOST_CPU_LOAD_INFO_COUNT;
    (void)host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO,
                          (host_info_t)cpucounters, &count);
}

- (NSInteger)diskFreeSize
{
    int64_t freesize = 0;

    NSArray*      paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSDictionary* dict  = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:nil];

    if (dict) {
        freesize = [[dict objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    }

    return (NSInteger)freesize;
}

- (float)batteryLevel
{
    return [BatStat sharedInstance].batteryLevel;
}

- (NSString *)batteryState
{
    return [[BatStat sharedInstance] batteryStateString];
}

- (double)currentModeWidth
{
    return DeviceResolution.currentModeWidth;
}

- (double)currentModeHeight
{
    return DeviceResolution.currentModeHeight;
}

- (double)screenScale
{
    return DeviceResolution.screenScale;
}

- (double)nativeScale
{
    return DeviceResolution.nativeScale;
}

- (void)displayLinkAction:(CADisplayLink *)sender
{
    double diff = (double)(sender.timestamp - self.prevTimestamp);
    self.fps = 1.0 / diff;
    self.prevTimestamp = sender.timestamp;
}

@end

@implementation BatStat

+ (BatStat *)sharedInstance
{
    static BatStat *_sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BatStat alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self)
    {
        _batteryLevel = -1.0;
        _batteryState = UIDeviceBatteryStateUnknown;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(batteryLevelChanged:)
                                              name:UIDeviceBatteryLevelDidChangeNotification
                                              object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(batteryStateChanged:)
                                              name:UIDeviceBatteryStateDidChangeNotification
                                              object:nil];
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    self.batteryLevel = -1.0;
    self.batteryState = UIDeviceBatteryStateUnknown;

    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                          name:UIDeviceBatteryLevelDidChangeNotification
                                          object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                          name:UIDeviceBatteryStateDidChangeNotification
                                          object:nil];
}

- (NSString *)batteryStateString
{
    DBGMSG(@"%s batteryState(%d)", __func__, (int)self.batteryState);
    NSString *batteryState = nil;
    switch (self.batteryState) {
        case UIDeviceBatteryStateUnknown:
            batteryState = kBatteryStateUnknown;
            break;
        case UIDeviceBatteryStateUnplugged:
            batteryState = kBatteryStateUnplugged;
            break;
        case UIDeviceBatteryStateCharging:
            batteryState = kBatteryStateCharging;
            break;
        case UIDeviceBatteryStateFull:
            batteryState = kBatteryStateFull;
            break;
        default:
            batteryState = kBatteryStateUnknown;
            break;
    }
    return batteryState;
}

- (void)batteryLevelChanged:(NSNotification *)notification
{
    DBGMSG(@"%s", __func__);
    [self updateBatteryLevel];
}

- (void)batteryStateChanged:(NSNotification *)notification
{
    DBGMSG(@"%s", __func__);
    [self updateBatteryLevel];
    [self updateBatteryState];
}

- (void)updateBatteryLevel
{
    self.batteryLevel = [UIDevice currentDevice].batteryLevel;
}

- (void)updateBatteryState
{
    self.batteryState = [UIDevice currentDevice].batteryState;
}
@end

@implementation DeviceResolution
+ (CGFloat)currentModeHeight
{
    return UIScreen.mainScreen.currentMode.size.height;
}

+ (CGFloat)currentModeWidth
{
    return UIScreen.mainScreen.currentMode.size.width;
}

+ (CGFloat)screenScale
{
    return UIScreen.mainScreen.scale;
}

+ (CGFloat)nativeScale
{
    if (UIDevice.currentDevice.systemVersion.floatValue >= 8.0) {
        return UIScreen.mainScreen.nativeScale;
    }
    return -1.f;
}
@end
