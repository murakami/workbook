//
//  main.m
//  pipe
//
//  Created by 村上幸雄 on 2014/05/05.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        /* ディレクトリ/配下の一覧を取得するプロセスを用意 */
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/ls"];
        [task setArguments:[NSArray arrayWithObject:@"/"]];

        /* 渡されたデータを読み取るパイプを用意 */
        NSPipe *pipe = [[NSPipe alloc] init];
        NSFileHandle *readEnd = [pipe fileHandleForReading];

        /* 先ほどのプロセスの標準出力にパイプを繋げる */
        [task setStandardOutput:pipe];

        /* 実行 */
        [task launch];

        /* パイプに渡されたデータを印字 */
        NSData *stdOutData = [readEnd availableData];
        NSLog(@"%@", [[NSString alloc] initWithData:stdOutData encoding:NSUTF8StringEncoding]);
    }
    return 0;
}

