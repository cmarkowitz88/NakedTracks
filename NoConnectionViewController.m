//
//  NoConnectionViewController.m
//  NakedTracks
//
//  Created by rockstar on 10/8/16.
//  Copyright © 2016 NakedTracks Software. All rights reserved.
//

#import "NoConnectionViewController.h"
#import "NakedTracksViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "DeviceType.h"
#import "GameScreenViewController.h"

@interface NoConnectionViewController ()

@property (nonatomic,weak) IBOutlet UIButton *retryBtn;
@property (nonatomic,weak) IBOutlet UIImageView *bkgdImage;
@property (nonatomic,weak) IBOutlet UILabel *lblNoConnection;
@property (nonatomic,weak) IBOutlet UILabel *lblMessage;

@end

@implementation NoConnectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setConstraints];
    
    self.retryBtn.layer.borderWidth = 2.0f;
    self.retryBtn.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (void)setConstraints
{
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];
    
    self.retryBtn.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblNoConnection.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblMessage.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.lblMessage.numberOfLines = 0;
    self.lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.bkgdImage.image = [UIImage imageNamed:@"istock-537319394_BW copy.jpg"];
    
    if([currentDevice.deviceType isEqualToString:@"seven"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:95.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:340.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:190]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblNoConnection attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblNoConnection attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:170.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:230.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:290.0]];

    }
    else if ([currentDevice.deviceType isEqualToString:@"plus"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:115.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:370.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:190]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblNoConnection attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblNoConnection attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:180.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:250.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:350.0]];
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:75.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:310.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:190]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.retryBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblNoConnection attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:55.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblNoConnection attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:170.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:25.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:230.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblMessage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:290.0]];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMainViewController:(id)sender
{
    // Attempt to load naked tracks view controller
    //NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc]init];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    GameScreenViewController *gameVC = [[GameScreenViewController alloc]init];
    AboutViewController *aboutVC = [[AboutViewController alloc]init];
    SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    
    
    if(gameVC.propHasInternetConnection == 1)
    {
        // If we now have an internet connection we will show the view
       //[self presentViewController:nakedVC animated:NO completion:Nil];
        UITabBarController *tabBarController = [[UITabBarController alloc]init];
        
        //NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc]init];
        //AboutViewController *aboutVC = [[AboutViewController alloc]init];
        
        
        tabBarController.viewControllers = [NSArray arrayWithObjects:gameVC,aboutVC,settingsVC, nil];
        myAppDelegate.window.rootViewController = tabBarController;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
