//
//  DailyNewsDataCenter.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "DailyNewsDataCenter.h"
#import <RestKit/RestKit.h>

@interface DailyNewsDataCenter ()

@property (nonatomic, strong) MOLatestNews *dailyNews;

@end

@implementation DailyNewsDataCenter

- (void)reloadData:(void (^)(BOOL success))loadOver {
    __weak DailyNewsDataCenter *blockSelf = self;
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://news.at.zhihu.com/"]];
    [objectManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [objectManager.HTTPClient setParameterEncoding:AFJSONParameterEncoding];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MOLatestNews commonMapping]
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:nil];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager getObjectsAtPath:@"/api/1.1/news/latest"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                blockSelf.dailyNews = [mappingResult firstObject];
                                if (loadOver) {
                                    loadOver(YES);
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (loadOver) {
                                    loadOver(NO);
                                }
                            }];
}

- (MOLatestNews *)latestNews {
    return self.dailyNews;
}

@end
