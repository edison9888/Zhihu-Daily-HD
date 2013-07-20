//
//  MONews.h
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "MOBase.h"
#import "MONewsItem.h"

@interface MONews : MOBase

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *ga_prefix;
@property (nonatomic, copy) NSString *title;

@end
