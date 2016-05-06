//
//  RACSQLiteDemo.m
//  DataPersistence
//
//  Created by Realank on 16/5/6.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "RACSQLiteDemo.h"
#import "RACFileManager.h"
#import <sqlite3.h>

@implementation RACSQLiteDemo

+ (void)operation{
    char sql_stmt[1000];
    
    sqlite3 *contactDB; //Declare a pointer to sqlite database structure
    
    NSString *databasePath = [[RACFileManager cacheDirectory] stringByAppendingPathComponent:@"contacts.sqlite"];
    const char *dbpath = [databasePath UTF8String]; // Convert NSString to UTF-8
    //打开数据库文件，没有则创建
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        //Database opened successfully
        NSLog(@"Database opened successfully");
    } else {
        //Failed to open database
        NSLog(@"Failed to open database");
    }
    
    //创建表
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char),"CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)");
    if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, NULL) == SQLITE_OK)
    {
        // SQL statement execution succeeded
        NSLog(@"SQL statement execution succeeded");
    }

    sqlite3_stmt *statement;
    
    //增
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "INSERT INTO CONTACTS (NAME, ADDRESS, PHONE) VALUES (\"zhang\",\"Nanjing Road\",\"18612345678\")");
    if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, NULL) == SQLITE_OK)
    {
        // SQL statement execution succeeded
        NSLog(@"SQL statement execution succeeded");
    }
    
    //删
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "DELETE FROM CONTACTS WHERE NAME = \"wang\"");
    //准备一个SQL语句，用于执行
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &statement, NULL);
    
    //执行一条准备的语句,如果找到一行匹配的数据，则返回SQLITE_ROW
    if(sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"SQL statement execution succeeded");
    }
    sqlite3_finalize(statement);//在内存中，清除之前准备的语句
    
    
    //改
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "UPDATE CONTACTS SET NAME = \"wang\" where name = \"zhang\"");
    //准备一个SQL语句，用于执行
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &statement, NULL);
    
    //执行一条准备的语句,如果找到一行匹配的数据，则返回SQLITE_ROW
    if(sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"SQL statement execution succeeded");
    }
    sqlite3_finalize(statement);//在内存中，清除之前准备的语句
    
    //查
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "SELECT id, NAME, ADDRESS FROM contacts");
    //准备一个SQL语句，用于执行
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &statement, NULL);
    
    //执行一条准备的语句,如果找到一行匹配的数据，则返回SQLITE_ROW
    while (sqlite3_step(statement) == SQLITE_ROW) {
        //获取执行的结果中，某一列的数据，并指定获取的类型（int, text...）,如果内部类型和获取的类型不一致，方法内部将会对内容进行类型转换
        NSInteger index = sqlite3_column_int(statement, 0);
        NSString *nameField = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
        NSString *addressField = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
        // Code to do something with extracted data here
        NSLog(@"%ld %@ %@",(long)index,nameField,addressField);
    }
    sqlite3_finalize(statement);//在内存中，清除之前准备的语句
    
    
    sqlite3_close(contactDB);//关闭数据库
}

@end
