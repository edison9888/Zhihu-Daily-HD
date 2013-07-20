//
//  MONews.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "MONews.h"

@implementation MONews

+ (RKObjectMapping *)commonMapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    [objectMapping addAttributeMappingsFromArray:@[@"id", @"thumbnail", @"ga_prefix", @"title"]];
    [objectMapping addRelationshipMappingWithSourceKeyPath:@"items" mapping:[MONewsItem commonMapping]];
    return objectMapping;
}

@end
