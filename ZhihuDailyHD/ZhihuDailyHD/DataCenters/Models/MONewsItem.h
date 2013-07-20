//
//  MONewsItem.h
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "MOBase.h"

@interface MONewsItem : MOBase

@property (nonatomic, copy) NSString *image_source;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, copy) NSString *share_image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger id;

@end
