//
//  MOBase.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "MOBase.h"
#import <objc/runtime.h>

@implementation MOBase

+ (RKObjectMapping *)commonMapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    
    NSMutableArray *propertyArray = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
        [propertyArray addObject:propertyName];
    }
    free(properties);
    
    [objectMapping addAttributeMappingsFromArray:propertyArray];
    return objectMapping;
}

@end
