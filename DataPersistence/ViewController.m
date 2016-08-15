//
//  ViewController.m
//  DataPersistence
//
//  Created by Realank on 16/5/4.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "ViewController.h"
#import "RACFileManager.h"
#import "RACCodingDemo.h"
#import "RACSQLiteDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [RACSQLiteDemo operation];
    [self archiveObject];
    [self unArchiveObject];
//    NSLog(@"%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[RACFileManager homeDirectory] error:nil]);
//    [self fileManagement];
//    NSString* fileName = [[RACFileManager cacheDirectory] stringByAppendingPathComponent:@"myplist.plist"];
//    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
//    [dict writeToFile:fileName atomically:YES];
//    
//    [RACFileManager printHierachyOfSandBox];
//    [RACFileManager saveDict:dict inPlistFileOfPath:fileName];
//    NSLog(@"%@",[RACFileManager dictInPistFileOfPath:fileName]);

}

- (void)archiveObject{
    
    RACCodingDemo *demoObj = [[RACCodingDemo alloc] init];
    
    NSString* cachePath = [RACFileManager cacheDirectory];
    NSString* fileName = @"demoObj.data";
    NSString* filePath = [cachePath stringByAppendingPathComponent:fileName];
    
//    [NSKeyedArchiver archiveRootObject:demoObj toFile:filePath];
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver setRequiresSecureCoding:YES];
    [archiver encodeObject:demoObj forKey:NSKeyedArchiveRootObjectKey];
    [archiver finishEncoding];
    
    [data writeToFile:filePath atomically:YES];
    
//    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:demoObj];
//    demoObj = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
//    NSLog(@"%@ %ld",demoObj.name,(long)demoObj.age);

}

- (void)unArchiveObject{
    NSString* cachePath = [RACFileManager cacheDirectory];
    NSString* fileName = @"demoObj.data";
    NSString* filePath = [cachePath stringByAppendingPathComponent:fileName];
    
    NSData* archivedData = [[NSData alloc]initWithContentsOfFile:filePath];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archivedData];
    [unarchiver setRequiresSecureCoding:YES];
    RACCodingDemo *demoObj = [unarchiver decodeObjectOfClass:[RACCodingDemo class] forKey:NSKeyedArchiveRootObjectKey];
    NSLog(@"%@ %ld",demoObj.name,(long)demoObj.age);
    
//    RACCodingDemo *demoObj = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//    NSLog(@"%@ %ld",demoObj.name,(long)demoObj.age);
}

- (void)fileManagement{
    NSLog(@"home directory:%@",[RACFileManager homeDirectory]);
    
    NSLog(@"document directory:%@",[RACFileManager documentDirectory]);
    
    NSString* cachePath = [RACFileManager cacheDirectory];
    NSLog(@"cache directory:%@",cachePath);
    
    NSLog(@"tmp directory:%@",[RACFileManager tmpDirectory]);
    
    NSString* directoryName = @"myDirectory";
    BOOL createResult = [RACFileManager createDirectoryInPath:cachePath directoryName:directoryName];
    if (createResult) {
        NSLog(@"创建%@成功",directoryName);
    }else {
        NSLog(@"创建%@失败",directoryName);
    }
    
    
    
    NSString* fileName = @"myFile.txt";
    createResult = [RACFileManager createFileInPath:cachePath fileName:fileName];
    if (createResult) {
        NSLog(@"创建%@成功",fileName);
    }else {
        NSLog(@"创建%@失败",fileName);
    }
    NSString* filePath = [cachePath stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory;
    BOOL fileExist = [RACFileManager fileExistInPath:filePath isDirectory:&isDirectory];
    NSLog(@"是否存在：%@  是否是目录：%@",fileExist?@"是":@"否",isDirectory?@"是":@"否");
    
    
    NSString* content = @"hello world";
//    BOOL writeResult = [RACFileManager writeString:content toPath:filePath];
//    BOOL writeResult = [RACFileManager writeStringUsingFileHandle:content toPath:filePath];
    BOOL writeResult = [RACFileManager appendStringUsingFileHandle:content toPath:filePath];
    if (writeResult) {
        NSLog(@"写入%@成功",fileName);
    }else {
        NSLog(@"写入%@失败",fileName);
    }
    
//    content = [RACFileManager readFileFromPath:filePath];
    content = [RACFileManager readFileUsingFileHandleFromPath:filePath];
    NSLog(@"%@",content);
    
    //删除文件
    BOOL deleteResult = [RACFileManager deleteFileInPath:filePath];
    if (deleteResult) {
        NSLog(@"删除%@成功",fileName);
    }else {
        NSLog(@"删除%@失败",fileName);
    }
    //删除文件夹
    NSString *directoryPath = [cachePath stringByAppendingPathComponent:directoryName];
    deleteResult = [RACFileManager deleteFileInPath:directoryPath];
    if (deleteResult) {
        NSLog(@"删除%@成功",directoryName);
    }else {
        NSLog(@"删除%@失败",directoryName);
    }
    
}

- (void)preferenceManagement{
    //添加preference
    [[NSUserDefaults standardUserDefaults] setObject:@"value1" forKey:@"key1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"value2" forKey:@"key2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //删除preference
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"key1 "];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //删除所有preference
    NSString *appDomainStr = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomainStr];
}


@end
