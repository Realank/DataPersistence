//
//  RACFileManager.h
//  DataPersistence
//
//  Created by Realank on 16/5/4.
//  Copyright © 2016年 realank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RACFileManager : NSObject


+(NSString*)homeDirectory;
//获取Documents目录
+(NSString *)documentDirectory;
//获取Cache目录
+(NSString *)cacheDirectory;
//获取tmp目录
+(NSString *)tmpDirectory;
//文件或文件夹是否存在
+(BOOL)fileExistInPath:(NSString*)path isDirectory:(BOOL *)isDirectory;
//创建文件夹
+(BOOL)createDirectoryInPath:(NSString*)path directoryName:(NSString*)name;
//创建文件
+(BOOL)createFileInPath:(NSString*)path fileName:(NSString*)fileName;
//写文件
+(BOOL)writeStringToFile:(NSString*)string inPath:(NSString*)path;
//读文件
+(NSString*)readFileInPath:(NSString*)path;
//文件属性
+(NSDictionary *)fileAttriutesInPath:(NSString*)path;
//删除文件
+(BOOL)deleteFileInPath:(NSString*)path;

@end
