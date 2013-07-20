//
//  NewsDetailViewController.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <BlocksKit/UIWebView+BlocksKit.h>

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
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
