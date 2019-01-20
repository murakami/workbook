//
//  main.m
//  udpcli
//
//  Created by 村上幸雄 on 2018/04/25.
//  Copyright © 2018年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#include    <sys/types.h>
#include    <sys/socket.h>
#include    <netinet/in.h>
#include    <arpa/inet.h>
#include    <stdio.h>
#include    <stdlib.h>
#include    <string.h>
#include    <unistd.h>

#include    <errno.h>        /* for definition of errno */
#include    <stdarg.h>        /* ANSI C header file */
//#include    <stdio.h>        /* ANSI C header file */
//#include    <stdlib.h>        /* ANSI C header file */
//#include    <string.h>        /* ANSI C header file */
//#include    <unistd.h>        /* ANSI C header file */

#define    REQUEST    400                /* max size of request, in bytes */
#define    REPLY    400                /* max size of reply, in bytes */

#define    UDP_SERV_PORT    7777    /* UDP server's well-known port */
#define    TCP_SERV_PORT    8888    /* TCP server's well-known port */
#define    TTCP_SERV_PORT    9999    /* T/TCP server's well-known port */

#define    MAXLINE    4096

/* Following shortens all the type casts of pointer arguments */
#define    SA    struct sockaddr *

static void    err_doit(int, const char *, va_list);

void    err_quit(const char *, ...);
void    err_sys(const char *, ...);
int        read_stream(int, char *, int);

/* following for timing versions of client-server */
void    start_timer(void);
double    print_timer(void);
void    sleep_us(unsigned int);

#define    min(a,b)    ((a) < (b) ? (a) : (b))

/* Nonfatal error related to a system call.
 * Print a message and return. */

void
err_ret(const char *fmt, ...)
{
    va_list        ap;
    
    va_start(ap, fmt);
    err_doit(1, fmt, ap);
    va_end(ap);
    return;
}

/* Fatal error related to a system call.
 * Print a message and terminate. */

void
err_sys(const char *fmt, ...)
{
    va_list        ap;
    
    va_start(ap, fmt);
    err_doit(1, fmt, ap);
    va_end(ap);
    exit(1);
}

/* Fatal error related to a system call.
 * Print a message, dump core, and terminate. */

void
err_dump(const char *fmt, ...)
{
    va_list        ap;
    
    va_start(ap, fmt);
    err_doit(1, fmt, ap);
    va_end(ap);
    abort();        /* dump core and terminate */
    exit(1);        /* shouldn't get here */
}

/* Nonfatal error unrelated to a system call.
 * Print a message and return. */

void
err_msg(const char *fmt, ...)
{
    va_list        ap;
    
    va_start(ap, fmt);
    err_doit(0, fmt, ap);
    va_end(ap);
    return;
}

/* Fatal error unrelated to a system call.
 * Print a message and terminate. */

void
err_quit(const char *fmt, ...)
{
    va_list        ap;
    
    va_start(ap, fmt);
    err_doit(0, fmt, ap);
    va_end(ap);
    exit(1);
}

/* Print a message and return to caller.
 * Caller specifies "errnoflag". */

static void
err_doit(int errnoflag, const char *fmt, va_list ap)
{
    int        errno_save;
    char    buf[MAXLINE];
    
    errno_save = errno;        /* value caller might want printed */
    vsprintf(buf, fmt, ap);
    if (errnoflag)
        sprintf(buf+strlen(buf), ": %s", strerror(errno_save));
    strcat(buf, "\n");
    fflush(stdout);        /* in case stdout and stderr are the same */
    fputs(buf, stderr);
    fflush(stderr);        /* SunOS 4.1.* doesn't grok NULL argument */
    return;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        struct sockaddr_in    serv;
        char                request[REQUEST], reply[REPLY];
        int                    sockfd, n;
        
        if (argc != 2)
            err_quit("usage: udpcli <IP address of server>");
        
        if ( (sockfd = socket(PF_INET, SOCK_DGRAM, 0)) < 0)
            err_sys("socket error");
        
        memset(&serv, 0, sizeof(serv));
        serv.sin_family         = AF_INET;
        serv.sin_addr.s_addr = inet_addr(argv[1]);
        serv.sin_port         = htons(UDP_SERV_PORT);
        
        /* form request[] ... */
        
        if (sendto(sockfd, request, REQUEST, 0,
                   (SA) &serv, sizeof(serv)) != REQUEST)
            err_sys("sendto error");
        
        if ( (n = recvfrom(sockfd, reply, REPLY, 0,
                           (SA) NULL, (int *) NULL)) < 0)
            err_sys("recvfrom error");
        
        /* process "n" bytes of reply[] ... */
        
        //exit(0);
    }
    return 0;
}
