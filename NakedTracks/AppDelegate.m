//
//  AppDelegate.m
//  NakedTracks
//
//  Created by rockstar on 1/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "AppDelegate.h"
#import "NakedTracksViewController.h"
#import "AboutViewController.h"
#import "NakedTracksMainView.h"
#import "RoundsViewController.h"
#import "Song.h"
#import "Answer.h"
#import "UserInfo.h"
#import "SettingsViewController.h"
#import "WelcomeViewController.h"
#import "GameScreenViewController.h"
#import "GameReviewViewController.h"
#import "MainMenuViewController.h"
#import "SettingsViewController.h"
#import "NoConnectionViewController.h"
#import "IAPViewController.h"
#import "GameOverViewController.h"
#import <AWSCORE/awscore.h>
#import <AWSS3/AWSS3.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

AVAudioPlayer *avSound;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Force the status bar to white
    // Set UIViewControllerBasedStatusBarAppearance to YES in the plist AND
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    // END status bar
    
    //STARTING POINT WITH WELCOME SCREEN
    //WelcomeViewController *welcomeVC = [[WelcomeViewController alloc]init];
    //self.window.rootViewController = welcomeVC;
    
    //STARTING POINT WITH GAME OVER CONTROLLER
    //GameOverViewController *gameOverVC = [[GameOverViewController alloc]init];
    //self.window.rootViewController = gameOverVC;
    
    // ***** REAL STARTING POINT
    //STARTING POINT WITH MAIN MENU SCREEN
    MainMenuViewController *mainMenuVC = [[MainMenuViewController alloc]init];
    self.window.rootViewController = mainMenuVC;
    
    //IAPViewController *iapVC = [[IAPViewController alloc]init];
    //self.window.rootViewController = iapVC;
    
    //AboutViewController *aboutVC = [[AboutViewController alloc]init];
    //self.window.rootViewController = aboutVC;
    
    //SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    //self.window.rootViewController = settingsVC;
    
    //STARTING POINT
    
    //GameReviewViewController *gameReviewVC = [[GameReviewViewController alloc]init];
    //self.window.rootViewController = gameReviewVC;
    
    //NoConnectionViewController *noConnectionVC = [[NoConnectionViewController alloc]init];
    //self.window.rootViewController  = noConnectionVC;

    
    //GameScreenViewController *gameScreenVC = [[GameScreenViewController alloc]init];
    //self.window.rootViewController = gameScreenVC;
    
    
        
    // Original Code that loads the game screen first and loads the navigation
    /*
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc]init];
    AboutViewController *aboutVC = [[AboutViewController alloc]init];
    SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:nakedVC,aboutVC,settingsVC,nil];
    self.window.rootViewController = tabBarController;*/
    
    // Test Code Used when project was first created.
    //self.window.rootViewController = nakedVC;
    //CGRect firstFrame = self.window.bounds;
    //NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc] initWithFrame:firstFrame];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
