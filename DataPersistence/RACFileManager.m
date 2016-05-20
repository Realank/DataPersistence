//
//  RACFileManager.m
//  DataPersistence
//
//  Created by Realank on 16/5/4.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "RACFileManager.h"

@implementation RACFileManager

#pragma mark - directory

//获取沙盒根目录
+(NSString*)homeDirectory{
    
    return NSHomeDirectory();

}

//获取Documents目录
+(NSString *)documentDirectory{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return documentsDirectory;
}

//获取Cache目录
+(NSString *)cacheDirectory{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return cachePath;
}

//获取tmp目录
+(NSString *)tmpDirectory{
    return NSTemporaryDirectory();
}

#pragma mark - file/directory operation

//文件或文件夹是否存在
+(BOOL)fileExistInPath:(NSString*)path isDirectory:(nullable BOOL *)isDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:isDirectory];
    return existed;
}

//创建文件夹
+(BOOL)createDirectoryInPath:(NSString*)path directoryName:(NSString*)name{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *newDirectory = [path stringByAppendingPathComponent:name];
    // 创建目录
    BOOL res = [fileManager createDirectoryAtPath:newDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        //文件夹创建成功
        return YES;
    }else{
        //文件夹创建失败
        return NO;
    }
}

//创建文件
+(BOOL)createFileInPath:(NSString*)path fileName:(NSString*)fileName{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *newFilePath = [path stringByAppendingPathComponent:fileName];
    BOOL res = [fileManager createFileAtPath:newFilePath contents:nil attributes:nil];
    if (res) {
        //文件创建成功
        return YES;
    }else{
        //文件创建失败
        return NO;
    }
}

//写文件
+(BOOL)writeString:(NSString*)string toPath:(NSString*)path{
    
    BOOL res=[string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (res) {
        //文件写入成功
        return YES;
    }else{
        //文件写入失败
        return NO;
    }
}

//读文件
+(NSString*)readFileFromPath:(NSString*)path{

    NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}


//覆盖写文件
+(BOOL)writeStringUsingFileHandle:(NSString*)string toPath:(NSString*)path{
    
    if (![self fileExistInPath:path isDirectory:nil]) {
        if(![[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]){
            return NO;
        }
    }
    
    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:path];
    if (file) {
        NSData* content = [string dataUsingEncoding:NSUTF8StringEncoding];
        [file truncateFileAtOffset:0];
        [file writeData:content];
        [file closeFile];
        return YES;
    }
    return NO;
}

//追加写文件
+(BOOL)appendStringUsingFileHandle:(NSString*)string toPath:(NSString*)path{
    
    if (![self fileExistInPath:path isDirectory:nil]) {
        if(![[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]){
            return NO;
        }
    }
    
    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:path];
    if (file) {
        NSData* content = [string dataUsingEncoding:NSUTF8StringEncoding];
        [file seekToEndOfFile];
        [file writeData:content];
        [file closeFile];
        return YES;
    }
    return NO;
}

//读文件
+(NSString*)readFileUsingFileHandleFromPath:(NSString*)path{
    
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:path];
    if (file) {
        NSData* content = [file readDataToEndOfFile];
        [file closeFile];
        return [[NSString alloc]initWithData:content encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}
//文件属性
+(NSDictionary *)fileAttriutesInPath:(NSString*)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    return [fileAttributes copy];
}



//删除文件
+(BOOL)deleteFileInPath:(NSString*)path{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager removeItemAtPath:path error:nil];
    if (res) {
        //文件删除成功
        return YES;
    }else{
        //文件删除失败
        return NO;
    }
}


#pragma mark - plist operation
//保存字典到plist文件
+(BOOL)saveDict:(NSDictionary*)dict inPlistFileOfPath:(NSString*)path{
    
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        return [dict writeToFile:path atomically:YES];
    }
    return NO;
}
//从plist文件读取字典
+(NSDictionary*)dictInPistFileOfPath:(NSString*)path{
    if ([self fileExistInPath:path isDirectory:nil]) {
        NSDictionary* dict = [[NSDictionary alloc]initWithContentsOfFile:path];
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            return dict;
        }
    }
    return nil;
}

//递归打印沙盒目录
+ (NSArray*)listForPath:(NSString*)path{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}


#pragma mark - application

+ (void)printHierachyOfSandBox{
    [self recursionPrintListOfPath:[RACFileManager homeDirectory] forLevel:0];
}

+ (void)recursionPrintListOfPath:(NSString*)path forLevel:(NSInteger)level{
    NSArray *list = [self listForPath:path];
    for (NSString* fileName in list) {
        NSString* indent = @"";
        for (int i = 0; i < level; i++) {
            indent = [indent stringByAppendingString:@"..."];
        }
        NSLog(@"%@/%@",indent,fileName);
        BOOL isDirectory;
        NSString* filePath = [path stringByAppendingPathComponent:fileName];
        [self fileExistInPath:filePath isDirectory:&isDirectory];
        if (isDirectory) {
            [self recursionPrintListOfPath:filePath forLevel:level+1];
        }
        
    }
}

@end
