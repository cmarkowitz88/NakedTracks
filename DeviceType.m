//
//  DeviceType.m
//  NakedTracks
//
//  Created by rockstar on 4/23/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import "DeviceType.h"
#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import "AboutViewController.h"
#import "SettingsViewController.h"
#import "GameScreenViewController.h"
#import "IAPViewController.h"
@import UIKit;

@implementation DeviceType

- (void)getDeviceType
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;
    
    self.screenWidth = (NSInteger)screenRect.size.width;
    self.screenHeight = (NSInteger)screenRect.size.height;
    
    if(self.screenWidth == 414 && self.screenHeight == 736)
    {
        self.deviceType = @"plus";
    }
    else if (self.screenWidth == 375 && self.screenHeight == 667)
    {
        self.deviceType = @"seven";
        
    }
    else if (self.screenWidth == 320 && self.screenHeight == 568)
    {
        self.deviceType = @"6,7,zoom";
    }
    
   
}

- (void)buildTabBar:(NSInteger)Params
{
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    NSMutableArray *viewControllerArray = [[NSMutableArray alloc]initWithCapacity:4];
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    GameScreenViewController *gameVC = [[GameScreenViewController alloc]init];
    gameVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_GamePlayIcon copy.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if(Params == 1)
    {
        gameVC.propGameReset = 1;
    }
    
    MainMenuViewController *menuVC = [[MainMenuViewController alloc]init];
    menuVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_HomeIcon copy.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    AboutViewController *aboutVC = [[AboutViewController alloc]init];
    //aboutVC.tabBarItem.title = @"About";
    aboutVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_NTIcon copy.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    //settingsVC.title = @"Settings";
    settingsVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_SettingsIcon copy.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    IAPViewController *iapVC = [[IAPViewController alloc]init];
    iapVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_Cart.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [viewControllerArray addObject:gameVC];
    [viewControllerArray addObject:iapVC];
    [viewControllerArray addObject:aboutVC];
    [viewControllerArray addObject:settingsVC];
    
    
    //tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    //tabBarController.viewControllers = [NSArray arrayWithObjects:nakedVC,aboutVC,settingsVC, nil];
    //tabBarController.viewControllers = [NSArray arrayWithObjects:gameVC,aboutVC,settingsVC, nil];
    tabBarController.viewControllers = viewControllerArray;
    
    
    UIImage *tabImage = [UIImage imageNamed:@"tabbkgd.png"];
    [[UITabBar appearance] setBackgroundImage:tabImage];
    tabBarController.tabBar.translucent = YES;
    
    myAppDelegate.window.rootViewController = tabBarController;

}

- (bool)getIapPurchaseValue
{
    bool purchaseFullVersion;
    purchaseFullVersion = [[NSUserDefaults standardUserDefaults] boolForKey:@"purchaseFullVersion"];
    
    return purchaseFullVersion;
}

- (void)gameReset
{
    // Resetting Game consists of deleting the userinfo and the gamereivew files
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath1 = [documentsDirectory stringByAppendingPathComponent:@"userInfo.archive"];
    NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:@"gameReview.archive"];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath1 error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:filePath2 error:NULL];

}

- (NSString *)FormatScore:(NSInteger)inScore
{
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedScore = [formatter stringFromNumber:[NSNumber numberWithInteger:(inScore)]];
    return formattedScore;
    
    //self.scoreNumber.text = [NSString stringWithFormat:@"%@", formattedScore];
    
}


@end
