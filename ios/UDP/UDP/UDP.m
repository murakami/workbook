//
//  UDP.m
//  UDP
//
//  Created by 村上幸雄 on 2015/01/19.
//  Copyright (c) 2015年 村上幸雄. All rights reserved.
//

#import <sys/socket.h>
#import <netinet/in.h>
#import <fcntl.h>
#import <unistd.h>
#import <Foundation/Foundation.h>

#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
#import <CFNetwork/CFNetwork.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#import "UDP.h"

@interface UDP () 
@property (nonatomic, copy,   readwrite) NSString *             hostName;
@property (nonatomic, copy,   readwrite) NSData *               hostAddress;
@property (nonatomic, assign, readwrite) NSUInteger             port;

- (void)stopHostResolution;
- (void)stopWithError:(NSError *)error;
- (void)stopWithStreamError:(CFStreamError)streamError;
@end

@implementation UDP {
    CFHostRef   _cfHost;
    CFSocketRef _cfSocket;
}

- (id)init
{
    NSLog(@"%s", __func__);
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self stop];
}

- (BOOL)isServer
{
    NSLog(@"%s", __func__);
    return self.hostName == nil;
}

- (void)sendData:(NSData *)data toAddress:(NSData *)addr
{
    NSLog(@"%s", __func__);
    int                     err;
    int                     sock;
    ssize_t                 bytesWritten;
    const struct sockaddr * addrPtr;
    socklen_t               addrLen;
    
    sock = CFSocketGetNative(self->_cfSocket);
    
    if (addr == nil) {
        addr = self.hostAddress;
        addrPtr = NULL;
        addrLen = 0;
    } else {
        addrPtr = [addr bytes];
        addrLen = (socklen_t) [addr length];
    }
    
    bytesWritten = sendto(sock, [data bytes], [data length], 0, addrPtr, addrLen);
    if (bytesWritten < 0) {
        err = errno;
    } else  if (bytesWritten == 0) {
        err = EPIPE;
    } else {
        assert( (NSUInteger) bytesWritten == [data length] );
        err = 0;
    }
    
    if (err == 0) {
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(udp:didSendData:toAddress:)] ) {
            [self.delegate udp:self didSendData:data toAddress:addr];
        }
    } else {
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(udp:didFailToSendData:toAddress:error:)] ) {
            [self.delegate udp:self
             didFailToSendData:data
                     toAddress:addr
                         error:[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil]];
        }
    }
}

- (void)readData
{
    NSLog(@"%s", __func__);
    int                     err;
    int                     sock;
    struct sockaddr_storage addr;
    socklen_t               addrLen;
    uint8_t                 buffer[65536];
    ssize_t                 bytesRead;
    
    sock = CFSocketGetNative(self->_cfSocket);
    
    addrLen = sizeof(addr);
    bytesRead = recvfrom(sock, buffer, sizeof(buffer), 0, (struct sockaddr *) &addr, &addrLen);
    if (bytesRead < 0) {
        err = errno;
    } else if (bytesRead == 0) {
        err = EPIPE;
    } else {
        NSData *dataObj;
        NSData *addrObj;
        
        err = 0;
        
        dataObj = [NSData dataWithBytes:buffer length:(NSUInteger) bytesRead];
        assert(dataObj != nil);
        addrObj = [NSData dataWithBytes:&addr  length:addrLen  ];
        assert(addrObj != nil);
        
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(udp:didReceiveData:fromAddress:)] ) {
            [self.delegate udp:self didReceiveData:dataObj fromAddress:addrObj];
        }
        
        if (self.isServer) {
            [self sendData:dataObj toAddress:addrObj];
        }
    }
    
    if (err != 0) {
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(udp:didReceiveError:)] ) {
            [self.delegate udp:self
               didReceiveError:[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil]];
        }
    }
}

static void SocketReadCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    NSLog(@"%s", __func__);
    UDP *udp = (__bridge UDP *)info;
    [udp readData];
}

- (BOOL)setupSocketConnectedToAddress:(NSData *)address port:(NSUInteger)port error:(NSError **)errorPtr
{
    NSLog(@"%s", __func__);
    int                     err;
    int                     junk;
    int                     sock;
    const CFSocketContext   context = { 0, (__bridge void *)(self), NULL, NULL, NULL };
    CFRunLoopSourceRef      rls;
    
    err = 0;
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        err = errno;
    }
    
    if (err == 0) {
        struct sockaddr_in      addr;
        
        memset(&addr, 0, sizeof(addr));
        if (address == nil) {
            addr.sin_len         = sizeof(addr);
            addr.sin_family      = AF_INET;
            addr.sin_port        = htons(port);
            addr.sin_addr.s_addr = INADDR_ANY;
            err = bind(sock, (const struct sockaddr *) &addr, sizeof(addr));
        } else {
            if ([address length] > sizeof(addr)) {
                [address getBytes:&addr length:sizeof(addr)];
            } else {
                [address getBytes:&addr length:[address length]];
            }
            assert(addr.sin_family == AF_INET);
            addr.sin_port = htons(port);
            err = connect(sock, (const struct sockaddr *) &addr, sizeof(addr));
        }
        if (err < 0) {
            err = errno;
        }
    }
    
    if (err == 0) {
        int flags;
        
        flags = fcntl(sock, F_GETFL);
        err = fcntl(sock, F_SETFL, flags | O_NONBLOCK);
        if (err < 0) {
            err = errno;
        }
    }
    
    if (err == 0) {
        self->_cfSocket = CFSocketCreateWithNative(NULL, sock, kCFSocketReadCallBack, SocketReadCallback, &context);
        
        sock = -1;
        
        rls = CFSocketCreateRunLoopSource(NULL, self->_cfSocket, 0);
        assert(rls != NULL);
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
        
        CFRelease(rls);
    }
    
    if (sock != -1) {
        junk = close(sock);
    }
    if ( (self->_cfSocket == NULL) && (errorPtr != NULL) ) {
        *errorPtr = [NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil];
    }
    
    return (err == 0);
}

- (void)startServerOnPort:(NSUInteger)port
{
    NSLog(@"%s", __func__);
    if (self.port == 0) {
        BOOL        success;
        NSError *   error;
        
        success = [self setupSocketConnectedToAddress:nil port:port error:&error];
        
        if (success) {
            self.port = port;
            
            if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(udp:didStartWithAddress:)] ) {
                CFDataRef   localAddress;
                
                localAddress = CFSocketCopyAddress(self->_cfSocket);
                
                [self.delegate udp:self didStartWithAddress:(__bridge NSData *) localAddress];
                
                CFRelease(localAddress);
            }
        } else {
            [self stopWithError:error];
        }
    }
}

- (void)hostResolutionDone
{
    NSLog(@"%s", __func__);
    NSError *           error;
    Boolean             resolved;
    NSArray *           resolvedAddresses;
    
    error = nil;
    
    resolvedAddresses = (__bridge NSArray *) CFHostGetAddressing(self->_cfHost, &resolved);
    if ( resolved && (resolvedAddresses != nil) ) {
        for (NSData * address in resolvedAddresses) {
            BOOL                    success;
            const struct sockaddr * addrPtr;
            NSUInteger              addrLen;
            
            addrPtr = (const struct sockaddr *) [address bytes];
            addrLen = [address length];
            
            success = NO;
            if (
                (addrPtr->sa_family == AF_INET)
                ) {
                success = [self setupSocketConnectedToAddress:address port:self.port error:&error];
                if (success) {
                    CFDataRef   hostAddress;
                    
                    hostAddress = CFSocketCopyPeerAddress(self->_cfSocket);
                    
                    self.hostAddress = (__bridge NSData *) hostAddress;
                    
                    CFRelease(hostAddress);
                }
            }
            if (success) {
                break;
            }
        }
    }
    
    if ( (self.hostAddress == nil) && (error == nil) ) {
        error = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:kCFHostErrorHostNotFound userInfo:nil];
    }
    
    if (error == nil) {
        [self stopHostResolution];
        
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(udp:didStartWithAddress:)] ) {
            [self.delegate udp:self didStartWithAddress:self.hostAddress];
        }
    } else {
        [self stopWithError:error];
    }
}

static void HostResolveCallback(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info)
{
    NSLog(@"%s", __func__);
    UDP *udp;
    
    udp = (__bridge UDP *)info;
    
    if ( (error != NULL) && (error->domain != 0) ) {
        [udp stopWithStreamError:*error];
    } else {
        [udp hostResolutionDone];
    }
}

- (void)startConnectedToHostName:(NSString *)hostName port:(NSUInteger)port
{
    NSLog(@"%s", __func__);
    if (self.port == 0) {
        Boolean             success;
        CFHostClientContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        CFStreamError       streamError;
        
        self->_cfHost = CFHostCreateWithName(NULL, (__bridge CFStringRef) hostName);
        
        CFHostSetClient(self->_cfHost, HostResolveCallback, &context);
        
        CFHostScheduleWithRunLoop(self->_cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        
        success = CFHostStartInfoResolution(self->_cfHost, kCFHostAddresses, &streamError);
        if (success) {
            self.hostName = hostName;
            self.port = port;
        } else {
            [self stopWithStreamError:streamError];
        }
    }
}

- (void)sendData:(NSData *)data
{
    NSLog(@"%s", __func__);
    if (self.isServer || (self.hostAddress == nil) ) {
        assert(NO);
    } else {
        [self sendData:data toAddress:nil];
    }
}

- (void)stopHostResolution
{
    NSLog(@"%s", __func__);
    if (self->_cfHost != NULL) {
        CFHostSetClient(self->_cfHost, NULL, NULL);
        CFHostCancelInfoResolution(self->_cfHost, kCFHostAddresses);
        CFHostUnscheduleFromRunLoop(self->_cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        CFRelease(self->_cfHost);
        self->_cfHost = NULL;
    }
}

- (void)stop
{
    NSLog(@"%s", __func__);
    self.hostName = nil;
    self.hostAddress = nil;
    self.port = 0;
    [self stopHostResolution];
    if (self->_cfSocket != NULL) {
        CFSocketInvalidate(self->_cfSocket);
        CFRelease(self->_cfSocket);
        self->_cfSocket = NULL;
    }
}

- (void)noop
{
    NSLog(@"%s", __func__);
}

- (void)stopWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    [self stop];
    if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(udp:didStopWithError:)] ) {
        [self performSelector:@selector(noop) withObject:nil afterDelay:0.0];
        [self.delegate udp:self didStopWithError:error];
    }
}

- (void)stopWithStreamError:(CFStreamError)streamError
{
    NSLog(@"%s", __func__);
    NSDictionary *  userInfo;
    NSError *       error;
    
    if (streamError.domain == kCFStreamErrorDomainNetDB) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInteger:streamError.error], kCFGetAddrInfoFailureKey,
                    nil
                    ];
    } else {
        userInfo = nil;
    }
    error = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:kCFHostErrorUnknown userInfo:userInfo];
    
    [self stopWithError:error];
}

@end

/* End Of File */