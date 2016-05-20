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
//覆盖写文件
+(BOOL)writeString:(NSString*)string toPath:(NSString*)path;
//追加写文件
+(BOOL)appendStringUsingFileHandle:(NSString*)string toPath:(NSString*)path;
//读文件
+(NSString*)readFileFromPath:(NSString*)path;
//覆盖写文件
+(BOOL)writeStringUsingFileHandle:(NSString*)string toPath:(NSString*)path;
//读文件
+(NSString*)readFileUsingFileHandleFromPath:(NSString*)path;
//文件属性
+(NSDictionary *)fileAttriutesInPath:(NSString*)path;
//删除文件
+(BOOL)deleteFileInPath:(NSString*)path;
//保存字典到plist文件
+(BOOL)saveDict:(NSDictionary*)dict inPlistFileOfPath:(NSString*)path;
//从plist文件读取字典
+(NSDictionary*)dictInPistFileOfPath:(NSString*)path;
//列出当前路径下的文件／文件夹
+ (NSArray*)listForPath:(NSString*)path;
//递归打印沙盒目录
+ (void)printHierachyOfSandBox;
@end
