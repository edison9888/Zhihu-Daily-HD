//
//  SloganViewController.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "SloganViewController.h"
#import "DailyViewController.h"
#import "DailyNewsDataCenter.h"

@interface SloganViewController ()

@property (nonatomic, strong) UILabel *hintLabel;

- (UIImage*)launchImageForOrientation:(UIInterfaceOrientation)orientation;

@end

@implementation SloganViewController

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
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = [self launchImageForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    [self.view addSubview:backgroundImageView];
    
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2 + 150, self.view.bounds.size.width, 100)];
    self.hintLabel.backgroundColor = [UIColor clearColor];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:self.hintLabel];
    
    self.hintLabel.text = @"正在为您获取今日知乎...";
	
    __weak SloganViewController *blockSelf = self;
    [self.view whenTapped:^{
        if ( ! [[DailyNewsDataCenter sharedInstance] latestNews]) {
            blockSelf.hintLabel.text = @"还在为您获取今日知乎，请稍等...";
            return;
        }
        DailyViewController *dailyViewController = [[DailyViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dailyViewController];
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [blockSelf presentModalViewController:navigationController animated:YES];
    }];
    
    [[DailyNewsDataCenter sharedInstance] reloadData:^(BOOL success) {
        blockSelf.hintLabel.text = @"今日知乎已获取到,轻触屏幕查看";
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (UIImage*)launchImageForOrientation:(UIInterfaceOrientation)orientation
{
    UIImage* launchImage = nil;
    
    if( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone )
        {
        // Use Retina 4 launch image
        if( [UIScreen mainScreen].bounds.size.height == 568.0 )
            {
            launchImage = [UIImage imageNamed:@"Default-568h@2x.png"];
            }
        // Use Retina 3.5 launch image
        else
            {
            launchImage = [UIImage imageNamed:@"Default.png"];
            }
        }
    else if( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad )
        {
        // Start with images for special orientations
        if( orientation == UIInterfaceOrientationPortraitUpsideDown )
            {
            launchImage = [UIImage imageNamed:@"Default-PortraitUpsideDown.png"];
            }
        else if( orientation == UIInterfaceOrientationLandscapeLeft )
            {
            launchImage = [UIImage imageNamed:@"Default-LandscapeLeft.png"];
            }
        else if( orientation == UIInterfaceOrientationLandscapeRight )
            {
            launchImage = [UIImage imageNamed:@"Default-LandscapeRight.png"];
            }
        
        // Use iPad default launch images if nothing found yet
        if( launchImage == nil )
            {
            if( UIInterfaceOrientationIsPortrait( orientation ) )
                {
                launchImage = [UIImage imageNamed:@"Default-Portrait.png"];
                }
            else
                {
                launchImage = [UIImage imageNamed:@"Default-Landscape.png"];
                }
            }
        
        // No launch image found so far, fall back to default
        if( launchImage == nil )
            {
            launchImage = [UIImage imageNamed:@"Default.png"];
            }
        }
    
    // As a last resort try to read the launch image from the app's Info.plist
    if( launchImage == nil )
        {
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* launchImageName = [infoDict valueForKey:@"UILaunchImageFile"];
        
        launchImage = [UIImage imageNamed:launchImageName];
        }
    
    return launchImage;
}

@end
