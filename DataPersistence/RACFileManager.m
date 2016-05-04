//
//  RACFileManager.m
//  DataPersistence
//
//  Created by Realank on 16/5/4.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "RACFileManager.h"

@implementation RACFileManager

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
+(BOOL)writeStringToFile:(NSString*)string inPath:(NSString*)path{
    
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
+(NSString*)readFileInPath:(NSString*)path{

    NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
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

@end
