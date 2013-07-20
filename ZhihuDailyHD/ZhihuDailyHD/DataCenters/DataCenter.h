//
//  DataCenter.h
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

+ (instancetype)sharedInstance;

- (void)loadCache;

- (void)reloadData:(void (^)(BOOL success))loadOver;

@end
