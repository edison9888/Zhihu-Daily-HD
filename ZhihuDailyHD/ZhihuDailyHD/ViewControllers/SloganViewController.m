//
//  SloganViewController.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 7/20/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SloganViewController.h"
#import "DailyViewController.h"
#import "DailyNewsDataCenter.h"

@interface SloganViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, assign) BOOL isFetching;

- (UIImage*)launchImageForOrientation:(UIInterfaceOrientation)orientation;

- (void)fetchNews;

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
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.image = [self launchImageForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.backgroundImageView];
    
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2 + 150, self.view.bounds.size.width, 100)];
    self.hintLabel.backgroundColor = [UIColor clearColor];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.font = [UIFont systemFontOfSize:30];
    self.hintLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.hintLabel];
    	
    __weak SloganViewController *blockSelf = self;
    [self.view whenTapped:^{
        if (self.isFetching) {
            blockSelf.hintLabel.text = @"还在狂奔给您拿今日知乎，客官不要慌...";
            return;
        }
        else if ( ! [[DailyNewsDataCenter sharedInstance] latestNews]) {
            [blockSelf fetchNews];
            return;
        }
        [blockSelf.hintLabel.layer removeAllAnimations];
        DailyViewController *dailyViewController = [[DailyViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dailyViewController];
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [blockSelf presentModalViewController:navigationController animated:YES];
    }];
    
    [self fetchNews];
}

- (void)fetchNews {
    self.isFetching = YES;
    self.hintLabel.text = @"正在跑腿为您获取今日知乎...";
    __weak SloganViewController *blockSelf = self;
    [[DailyNewsDataCenter sharedInstance] reloadData:^(BOOL success) {
        blockSelf.isFetching = NO;
        if (success) {
            blockSelf.hintLabel.text = @"今日知乎已送到,轻触屏幕查看";
            [UIView animateWithDuration:2.0f
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                             animations:^{
                                 self.hintLabel.alpha = 0.3f;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        }
        else {
            blockSelf.hintLabel.text = @"跑腿的路上遇到点问题，轻触屏幕重新来过";
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.backgroundImageView.image = [self launchImageForOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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
