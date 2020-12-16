//
//  PerformanceMonitor.h
//  PerformanceMonitor
//
//  Created by 村上幸雄 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceMonitor : NSObject
@property (assign, nonatomic) double    cpuUser;
@property (assign, nonatomic) double    cpuSys;
@property (assign, nonatomic) double    cpuIdle;
@property (assign, nonatomic) double    fps;
+ (PerformanceMonitor *)sharedInstance;
- (NSInteger)hwMemSize;
- (NSInteger)hwUserMem;
- (NSInteger)freeMemory;
- (NSInteger)processMemory;
- (void)updateCpuInfo;
- (NSInteger)diskFreeSize;
- (float)batteryLevel;
- (NSString *)batteryState;
- (double)currentModeWidth;
- (double)currentModeHeight;
- (double)screenScale;
- (double)nativeScale;
@end

NS_ASSUME_NONNULL_END
