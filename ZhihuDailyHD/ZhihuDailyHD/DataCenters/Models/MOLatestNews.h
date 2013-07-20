//
//  MOLatestNews.h
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "MOBase.h"
#import "MONews.h"

@interface MOLatestNews : MOBase

@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSArray *news;
@property (nonatomic, assign) BOOL is_today;
@property (nonatomic, strong) NSArray *top_stories;
@property (nonatomic, copy) NSString *display_date;

@end
