//
//  WelcomeViewController.m
//  NakedTracks
//
//  Created by rockstar on 3/21/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import "WelcomeViewController.h"
#import "NakedTracksViewController.h"
#import "AboutViewController.h"
#import "NakedTracksMainView.h"
#import "RoundsViewController.h"
#import "Song.h"
#import "Answer.h"
#import "UserInfo.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "GameScreenViewController.h"
#import "DeviceType.h"
#import "MainMenuViewController.h"
#import "UserInfo.h"

@interface WelcomeViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imgViewLevel;
@property (nonatomic, weak) IBOutlet UIButton *btnLevel;
@property (nonatomic, weak) IBOutlet UILabel *lblLevel;

@end

@implementation WelcomeViewController

NSInteger intSkillLevel;
UserInfo *userInfo;
NSString *strLevelText;
NSString *strSkillLevel;
NSMutableArray *aryTextColor;
NSString *strAlertMessage;
NSString *strAlertTitle;

-(void)viewWillAppear
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self showAlertBox];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getCurrentLevel];
    //intSkillLevel = 3;
    
    aryTextColor = [[NSMutableArray alloc]init];
    [aryTextColor addObject:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
    [aryTextColor addObject:[UIColor colorWithRed:0/255.0 green:179/255.0 blue:216/255.0 alpha:1.0]];
    [aryTextColor addObject:[UIColor colorWithRed:253/255.0 green:184/255.0 blue:19/255.0 alpha:1.0]];
    [aryTextColor addObject:[UIColor colorWithRed:246/255.0 green:139/255.0 blue:31/255.0 alpha:1.0]];

    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    self.imgViewLevel.image = [UIImage imageNamed:@"istock-186123477_orig_BW copy.jpg"];
    self.btnLevel.layer.borderWidth = 2.0f;
    self.btnLevel.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnLevel setTitleColor:[aryTextColor objectAtIndex:intSkillLevel] forState:UIControlStateNormal];
    
    strLevelText = @"LEVEL ";
    strLevelText = [strLevelText stringByAppendingString:strSkillLevel];
    
    self.lblLevel.text = strLevelText;
    self.lblLevel.textColor = [aryTextColor objectAtIndex:intSkillLevel];
    
    self.btnLevel.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblLevel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setUIConstraints];
    
}

-(void)showAlertBox
{
    strAlertTitle = @"Naked Tracks";
    strAlertMessage = @"To achieve the best user experience we recommend using either earbuds or headphones.";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:strAlertTitle message:strAlertMessage preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Okay, got it!" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action )
                         {
                             
                         }];
    
    
    [alert addAction: ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)getCurrentLevel
{
    // * Check the user info archive
    userInfo = [[UserInfo alloc]init];
    userInfo = [userInfo getUserInfo];
    
    if(userInfo == Nil)
    {
        //*** If there is no User Profile Archive Information then this is the first time in
        intSkillLevel = 1;
        strSkillLevel = @"1";
    }
    else
    {   //*** If there is a archive then we will load that to restore the player's session
        intSkillLevel = userInfo.intSkillLevel;
        strSkillLevel = [NSString stringWithFormat:@"%d", userInfo.intSkillLevel];
    }

}

- (void)setUIConstraints
{
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];
    
    if ([currentDevice.deviceType isEqualToString:@"seven"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:90.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:275.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:127.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:230.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:160]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
    }
    
    else if([currentDevice.deviceType isEqualToString:@"plus"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:110.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:325.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:145.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:280.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:160]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:52.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:250.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:88.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:205.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:160]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"eleven,xr"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120.0]];
              
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:205.0]];
              
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:160]];
              
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblLevel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:85.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:280.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLevel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
      
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playGame:(id)sender{
    
    //GameScreenViewController *gameVC = [[GameScreenViewController alloc]init];
    //[self presentViewController:gameVC  animated:YES completion:Nil];
    
    
    DeviceType *localDevice = [[DeviceType alloc]init];
    [localDevice buildTabBar:0];
    
    
    /*
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
   
    NSMutableArray *viewControllerArray = [[NSMutableArray alloc]initWithCapacity:3];
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MainMenuViewController *menuVC = [[MainMenuViewController alloc]init];
    menuVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_HomeIcon copy.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    //GameScreenViewController *gameVC = [[GameScreenViewController alloc]init];
    //gameVC.tabBarItem.title = @"Play";
    //gameVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_HomeIcon copy.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    AboutViewController *aboutVC = [[AboutViewController alloc]init];
    //aboutVC.tabBarItem.title = @"About";
    aboutVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_NTIcon copy.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    //settingsVC.title = @"Settings";
    settingsVC.tabBarItem.image = [[UIImage imageNamed:@"Navigation_SettingsIcon copy.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [viewControllerArray addObject:menuVC];
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
     */
    
    }

    
    


@end
