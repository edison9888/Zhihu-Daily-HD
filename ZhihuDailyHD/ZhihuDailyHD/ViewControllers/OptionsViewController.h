//
//  OptionsViewController.h
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 8/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsDelegate <NSObject>

- (void)optionsSelectAtIndex:(NSInteger)index;

@end

@interface OptionsViewController : UITableViewController

@property (nonatomic, weak) id<OptionsDelegate> delegate;

@end
