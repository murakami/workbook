//
//  main.m
//  hosttime
//
//  Created by 村上 幸雄 on 12/01/21.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <sys/time.h>
#import <mach/mach.h>
/* #import <CoreServices/CoreServices.h> */

#define TIMERSUB(a, b, result)                              \
    do {                                                    \
        (result)->tv_sec = (a)->tv_sec - (b)->tv_sec;       \
        (result)->tv_usec = (a)->tv_usec - (b)->tv_usec;    \
        if ((result)->tv_usec < 0) {                        \
            --(result)->tv_sec;                             \
            (result)->tv_usec += 1000000;                   \
        }                                                   \
    } while (0)

int main (int argc, const char * argv[])
{
	int				i, j;
	clock_serv_t		clock_serv;
	mach_timespec_t	cur_time;
	struct timeval		tv_start, tv_end, tv_diff;
    /* AbsoluteTime		at_start; */
	/* float				deltaTime; */
	/* uint64_t			result; */
	/* unsigned long		secs; */

    @autoreleasepool {
        
        /* ANSI C: clock_t clock(void) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                clock();
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("ANSI C: clock: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
        /* ANSI C: time_t time(time_t *pSec) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                time(NULL);
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("ANSI C: time: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
        /* Mach: kern_return_t clock_get_time(clock_serv_t clock_serv, mach_timespec_t *cur_time) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                host_get_clock_service(mach_host_self(), REALTIME_CLOCK, &clock_serv);
                clock_get_time(clock_serv, &cur_time);
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Mach: clock_get_time: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
        /* Mach: uint64_t mach_absolute_time(void) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                mach_absolute_time();
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Mach: mach_absolute_time: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
#if 0
        /* Kernel: void clock_get_uptime(uint64_t *result) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                clock_get_uptime(&result);
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Mach: clock_get_uptime: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
        /* Kernel: mach_timespec_t clock_get_system_value(void) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                clock_get_system_value();
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Mach: clock_get_system_value: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
        /* Kernel: mach_timespec_t clock_get_calendar_value(void) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                clock_get_calendar_value();
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Mach: clock_get_calendar_value: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
        /* Kernel: mach_timespec_t clock_get_calendar_offset(void) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                clock_get_calendar_offset();
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Mach: clock_get_calendar_offset: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
#endif /* 0 */
        
        /* POSIX: int gettimeofday(struct timeval *tv, struct timezone *tz) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                gettimeofday(&tv_end, NULL);
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("POSIX: gettimeofday: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
        /* Core Foundation: CFAbsoluteTimeGetCurrent */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                CFAbsoluteTimeGetCurrent();
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Core Foundation: CFAbsoluteTimeGetCurrent: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
#if 0
        /* Carbon: UpTime */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                UpTime();
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Carbon: UpTime: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
#endif /* 0 */

#if 0
        /* Carbon: ReadDateTime */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                ReadDateTime(&secs);
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Carbon: ReadDateTime: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
#endif /* 0 */

#if 0
        /* Carbon: GetDateTime */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                GetDateTime(&secs);
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Carbon: GetDateTime: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
#endif /* 0 */

        /* Cocoa: NSDate::timeIntervalSince1970 */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                [[NSDate date] timeIntervalSince1970];
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Cocoa: NSDate::timeIntervalSince1970: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
        /* Cocoa: NSDate::timeIntervalSinceReferenceDate */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                [[NSDate date] timeIntervalSinceReferenceDate];
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Cocoa: NSDate::timeIntervalSinceReferenceDate: %ld.%06d[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
        
#if 0
        /* Unsupported: hrtime_t gethrtime(void) */
        gettimeofday(&tv_start, NULL);
        for (i = 0; i < 10000; i++) {
            for (j = 0; j < 100; j++) {
                gethrtime();
            }
        }
        gettimeofday(&tv_end, NULL);
        TIMERSUB(&tv_end, &tv_start, &tv_diff);
        printf("Unsupported: gethrtime: %ld.%06ld[sec]\n", tv_diff.tv_sec, tv_diff.tv_usec);
#endif /* 0 */
        
    }
    return 0;
}

/* End Of File */