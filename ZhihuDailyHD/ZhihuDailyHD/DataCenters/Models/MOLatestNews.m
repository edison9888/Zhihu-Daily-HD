//
//  MOLatestNews.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "MOLatestNews.h"

@implementation MOLatestNews

+ (RKObjectMapping *)commonMapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[self class]];
    [objectMapping addAttributeMappingsFromArray:@[@"date", @"is_today", @"display_date"]];
    [objectMapping addRelationshipMappingWithSourceKeyPath:@"news" mapping:[MONews commonMapping]];
    [objectMapping addRelationshipMappingWithSourceKeyPath:@"top_stories" mapping:[MONews commonMapping]];
    return objectMapping;
}

@end
