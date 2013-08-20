//
//  NewsDetailViewController.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <BlocksKit/UIWebView+BlocksKit.h>
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>

@interface NewsDetailViewController ()

@property (nonatomic, copy) NSString *url;

@end

@implementation NewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUrl:(NSString *)urlString {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.url = urlString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.hidesBottomBarWhenPushed = NO;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.webView];
    
    __weak NewsDetailViewController *blockSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                          handler:^(id sender) {
                                                                                              if ( ! [blockSelf.webView isLoading]) {
                                                                                                  [blockSelf.webView reload];
                                                                                              }
                                                                                          }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
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

@end
