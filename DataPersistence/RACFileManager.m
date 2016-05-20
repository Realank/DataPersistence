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



/**
 *  文件或文件夹是否存在
 *
 *  @param path        文件/文件夹路径
 *  @param isDirectory BOOL型变量的地址，用于反馈该路径是文件还是文件夹
 *
 *  @return 返回文件是否存在
 */
+(BOOL)fileExistInPath:(NSString*)path isDirectory:(nullable BOOL *)isDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:isDirectory];
    return existed;
}

/**
 *  创建文件夹
 *
 *  @param path 要创建文件夹的上级路径
 *  @param name 要创建的文件夹名称
 *
 *  @return 是否创建成功
 */
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


/**
 *  创建文件
 *
 *  @param path     要创建文件的上级路径
 *  @param fileName 要创建的文件名
 *
 *  @return 是否创建成功
 */
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

/**
 *  覆盖写文件
 *
 *  @param string 写入的内容
 *  @param path   文件的路径
 *
 *  @return 是否写入成功
 */
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

/**
 *  读文件
 *
 *  @param path 文件路径
 *
 *  @return 文件内容
 */
+(NSString*)readFileFromPath:(NSString*)path{

    NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}


/**
 *  覆盖写文件(使用NSFileHandle)
 *
 *  @param string 要写入的内容
 *  @param path   文件路径
 *
 *  @return 是否写入成功
 */
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

/**
 *  追加写文件(使用NSFileHandle)
 *
 *  @param string 追加的内容
 *  @param path   文件路径
 *
 *  @return 是否追加成功
 */
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


/**
 *  读文件(使用NSFileHandle)
 *
 *  @param path 文件路径
 *
 *  @return 文件内容
 */
+(NSString*)readFileUsingFileHandleFromPath:(NSString*)path{
    
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:path];
    if (file) {
        NSData* content = [file readDataToEndOfFile];
        [file closeFile];
        return [[NSString alloc]initWithData:content encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}
/**
 *  文件属性
 *
 *  @param path 文件路径
 *
 *  @return 文件属性字典
 */
+(NSDictionary *)fileAttriutesInPath:(NSString*)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    return [fileAttributes copy];
}



/**
 *  删除文件
 *
 *  @param path 文件路径
 *
 *  @return 是否删除成功
 */
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
/**
 *  保存字典到plist文件
 *
 *  @param dict 要保存的字典
 *  @param path 文件路径
 *
 *  @return 是否保存成功
 */
+(BOOL)saveDict:(NSDictionary*)dict inPlistFileOfPath:(NSString*)path{
    
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        return [dict writeToFile:path atomically:YES];
    }
    return NO;
}
/**
 *  从plist文件读取字典
 *
 *  @param path 文件路径
 *
 *  @return 读取到的字典
 */
+(NSDictionary*)dictInPistFileOfPath:(NSString*)path{
    if ([self fileExistInPath:path isDirectory:nil]) {
        NSDictionary* dict = [[NSDictionary alloc]initWithContentsOfFile:path];
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            return dict;
        }
    }
    return nil;
}

/**
 *  列出某路径下的文件/文件夹
 *
 *  @param path 要列的路径
 *
 *  @return 给定路径下的文件/文件夹名称数组
 */
+ (NSArray*)listForPath:(NSString*)path{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}


#pragma mark - application
/**
 *  递归打印沙盒
 */
+ (void)printHierachyOfSandBox{
    [self recursionPrintListOfPath:[RACFileManager homeDirectory] forLevel:0];
}
/**
 *  递归打印某个路径下的所有文件
 *
 *  @param path  路径
 *  @param level 打印的缩紧级别，从0开始
 */
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
