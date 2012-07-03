//
//  Database.m
//  Database
//
//  Created by 村上 幸雄 on 12/07/03.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "Database.h"

@interface Database ()
@end

@implementation Database

@synthesize database = _database;

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"database.sql"];
        if (sqlite3_open([path UTF8String], &_database) != SQLITE_OK) {
            sqlite3_close(_database);
            self.database = NULL;
            DBGMSG(@"Failed to open database with message '%s'.", sqlite3_errmsg(_database));
        }
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    if (sqlite3_close(_database) != SQLITE_OK) {
        DBGMSG(@"Error: failed to close database with message '%s'.", sqlite3_errmsg(_database));
    }
    self.database = NULL;
    /* [super dealloc]; */
}

- (void)demo
{
    DBGMSG(@"%s", __func__);
    if (NULL == self.database)  return;
    
    const char *sql = "CREATE TABLE demo ('id' INTEGER PRIMARY KEY, 'name' CHAR(32))";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL) == SQLITE_OK) {
        DBGMSG(@"[OK]sqlite3_prepare_v2(), srl: %s", sql);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            DBGMSG(@"[OK]sqlite3_step()");
        }
    }
    sqlite3_finalize(statement);
    
    sql = "INSERT INTO demo(name) VALUES ('test')";
    if (sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL) == SQLITE_OK) {
        DBGMSG(@"[OK]sqlite3_prepare_v2(), srl: %s", sql);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            DBGMSG(@"[OK]sqlite3_step()");
        }
    }
    sqlite3_finalize(statement);

    sql = "SELECT id FROM demo";
    if (sqlite3_prepare_v2(self.database, sql, -1, &statement, NULL) == SQLITE_OK) {
        DBGMSG(@"[OK]sqlite3_prepare_v2(), srl: %s", sql);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            DBGMSG(@"[OK]sqlite3_step()");
            int primaryKey = sqlite3_column_int(statement, 0);
            NSLog(@"primaryKey: %d", primaryKey);
        }
    }
    sqlite3_finalize(statement);
}

@end
