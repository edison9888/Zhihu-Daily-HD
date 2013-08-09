//
//  DailyViewController.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>
#import <Reachability/Reachability.h>

#import "DailyViewController.h"
#import "DailyNewsDataCenter.h"
#import "NewsDetailViewController.h"

@interface DailyViewController () <BDDynamicGridViewDelegate>

@property (nonatomic, strong) NSArray *newsItemViews;

@property (nonatomic, strong) Reachability *reachability;

@end

@implementation DailyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"知乎日报";
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.reachability = [Reachability reachabilityWithHostname:@"zhihu.com"];

    __block BOOL isLoading = NO;
    __weak DailyViewController *blockSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                          handler:^(id sender) {
                                                                                              if (isLoading) {
                                                                                                  return;
                                                                                              }
                                                                                              isLoading = YES;
                                                                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                                                                              [[DailyNewsDataCenter sharedInstance] reloadData:^(BOOL success) {
                                                                                                  isLoading = NO;
                                                                                                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                                                  if (success) {
                                                                                                      [blockSelf asyncDataLoading];
                                                                                                  }
                                                                                              }];
                                                                                          }];
	
    [self setBackgroundColor:[UIColor lightGrayColor]];
    self.delegate = self;
    self.onSingleTap = ^(UIView* view, NSInteger viewIndex) {
        if (viewIndex < [[[[DailyNewsDataCenter sharedInstance] latestNews] news] count]) {
            MONewsItem *newsItem = [[[[[DailyNewsDataCenter sharedInstance] latestNews] news][viewIndex] items] lastObject];
            NewsDetailViewController *webViewController = [[NewsDetailViewController alloc] initWithUrl:[newsItem url]];
//            [blockSelf presentModalViewController:webViewController animated:YES];
            webViewController.title = newsItem.title;
            [blockSelf.navigationController pushViewController:webViewController animated:YES];
        }
    };
    
    [self asyncDataLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self reloadData];
}

- (void)asyncDataLoading {
    self.newsItemViews = [NSArray array];
    //load the placeholder image
    for (int i = 0, count = [[[[DailyNewsDataCenter sharedInstance] latestNews] news] count]; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 200, 50)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        titleLabel.alpha = 0.0f;
        [imageView addSubview:titleLabel];
        
        self.newsItemViews = [self.newsItemViews arrayByAddingObject:imageView];
    }
    [self reloadData];
    
    for (int i = 0, count = [[[[DailyNewsDataCenter sharedInstance] latestNews] news] count]; i < count; i++) {
        UIImageView *imageView = [self.newsItemViews objectAtIndex:i];
        MONews *news = [[[[DailyNewsDataCenter sharedInstance] latestNews] news] objectAtIndex:i];
        
        [self performSelector:@selector(animateUpdate:)
                   withObject:@[imageView, news]
                   afterDelay:0.2 + (arc4random()%3) + (arc4random()%10 * 0.1)];
    }
}

- (void) animateUpdate:(NSArray*)objects {
    UIImageView *imageView = [objects objectAtIndex:0];
    UILabel *titleLabel = [[imageView subviews] lastObject];
    if ( ! [titleLabel isKindOfClass:[UILabel class]]) {
        titleLabel = nil;
    }
    MONews *news = [objects objectAtIndex:1];
    [UIView animateWithDuration:0.5
                     animations:^{
                         imageView.alpha = 0.0f;
                         titleLabel.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         NSString *url;
                         if ([self.reachability isReachableViaWiFi]) {
                             url = [(MONewsItem *)[[news items] lastObject] image];
                         }
                         if ( ! [url length]) {
                             url = [news thumbnail];
                         }
                         [imageView setImageWithURL:[NSURL URLWithString:url]];
                         titleLabel.text = [news title];
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              imageView.alpha = 1;
                                              titleLabel.alpha = 1;
                                          }
                                          completion:^(BOOL finished) {
                                              NSArray *visibleRowInfos =  [self visibleRowInfos];
                                              for (BDRowInfo *rowInfo in visibleRowInfos) {
                                                  [self updateLayoutWithRow:rowInfo animiated:YES];
                                              }
                                          }];
                     }];
}

#pragma mark - BDDynamicGridViewController

- (NSUInteger)maximumViewsPerCell {
    return 3;
}

- (NSUInteger)numberOfViews {
//    return [[[[DailyNewsDataCenter sharedInstance] latestNews] news] count];
    return [self.newsItemViews count];
}

- (UIView*) viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo*)rowInfo {
    /*
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView setImageWithURL:[NSURL URLWithString:[[[[DailyNewsDataCenter sharedInstance] latestNews] news][index] thumbnail]]
              placeholderImage:nil];
    return imageView;
     */
    return self.newsItemViews[index];
}

- (NSUInteger)minimumViewsPerCell {
    return 2;
}

- (CGFloat) rowHeightForRowInfo:(BDRowInfo*)rowInfo {
    return 200;
}

@end
