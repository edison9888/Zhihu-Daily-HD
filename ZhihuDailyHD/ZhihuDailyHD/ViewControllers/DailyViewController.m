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
#import <Appirater/Appirater.h>
#import "UMFeedback.h"

#import "Constants.h"
#import "DailyViewController.h"
#import "DailyNewsDataCenter.h"
#import "NewsDetailViewController.h"
#import "OptionsViewController.h"
#import "AboutViewController.h"

@interface DailyViewController () <UIPopoverControllerDelegate, BDDynamicGridViewDelegate, OptionsDelegate> {
    UIInterfaceOrientation orientationBeforeDisappearing;
}

@property (nonatomic, strong) NSArray *newsItemViews;

@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, strong) OptionsViewController *optionsViewController;
@property (nonatomic, strong) UIPopoverController *popover;

- (IBAction)showMoreOptions:(id)sender;

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
    orientationBeforeDisappearing = self.interfaceOrientation;
    
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
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [leftButton addTarget:self action:@selector(showMoreOptions:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
	
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
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    UIInterfaceOrientation currentOrientation = self.interfaceOrientation;
    if (orientationBeforeDisappearing != currentOrientation) {
        orientationBeforeDisappearing = currentOrientation;
        [self reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [super viewWillDisappear:animated];
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

- (IBAction)showMoreOptions:(id)sender {
    if ( ! self.optionsViewController) {
        self.optionsViewController = [[OptionsViewController alloc] initWithStyle:UITableViewStylePlain];
        self.optionsViewController.delegate = self;
    }
    
    if ( ! self.popover) {
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:self.optionsViewController];
        popoverController.delegate = self;
        self.popover = popoverController;
    }
    
    if ([self.popover isPopoverVisible]) {
        [self.popover dismissPopoverAnimated:YES];
    }
    else {
        self.popover.popoverContentSize = CGSizeMake(240, 320);
        [self.popover presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    }
}

#pragma mark - UIPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
}

#pragma mark - OptionsDelegate

- (void)optionsSelectAtIndex:(NSInteger)index {
    [self.popover dismissPopoverAnimated:YES];
    switch (index) {
        case 0: {
            [UMFeedback showFeedback:self withAppkey:UmengAppKey];
        }
            break;
            
        case 1: {
            [Appirater rateApp];
        }
            break;
            
        case 2: {
            AboutViewController *aboutViewController = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
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
