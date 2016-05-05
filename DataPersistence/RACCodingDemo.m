//
//  RACCodingDemo.m
//  DataPersistence
//
//  Created by Realank on 16/5/5.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "RACCodingDemo.h"


@implementation RACCodingDemo

- (instancetype)init{
    if (self = [super init]) {
        _name = @"xiaoming";
        _age = 5;
    }
    return self;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        if (!aDecoder) {
            return self;
        }
//        _name = [aDecoder decodeObjectForKey:@"name"];
        _name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _age = [aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeInteger:_age forKey:@"age"];
}

@end
