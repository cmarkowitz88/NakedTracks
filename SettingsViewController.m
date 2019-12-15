//
//  SettingsViewController.m
//  NakedTracks
//
//  Created by rockstar on 11/13/16.
//  Copyright © 2016 NakedTracks Software. All rights reserved.
//

#import "SettingsViewController.h"
#import "NoConnectionViewController.h"
#import "NakedTracksViewController.h"
#import "AboutViewController.h"
#import "DeviceType.h"
#import "GameScreenViewController.h"
#import "AppDelegate.h"
#import "IAPViewController.h"
#import "Config.h"


@interface SettingsViewController () 

@property (nonatomic,weak) IBOutlet UIButton *resetBtn;
@property (nonatomic,weak) IBOutlet UIButton *backBtn;
@property (nonatomic,weak) IBOutlet UIButton *helpBtn;
@property (nonatomic,weak) IBOutlet UIButton *inAppPurchaseBtn;
@property (nonatomic,weak) IBOutlet UIImageView *bkgdImage;
@property (nonatomic,weak) IBOutlet UILabel *headerLabel;
@property (nonatomic,weak) IBOutlet UILabel *informationLabel;
@property (nonatomic,weak) IBOutlet UIImageView *logoImage;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setContraints];
    
    self.backBtn.hidden = YES;
    

}

- (void)setContraints
{
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];
    
    self.headerLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.informationLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.resetBtn.translatesAutoresizingMaskIntoConstraints=NO;
    self.backBtn.translatesAutoresizingMaskIntoConstraints=NO;
    self.logoImage.translatesAutoresizingMaskIntoConstraints=NO;
    self.helpBtn.translatesAutoresizingMaskIntoConstraints=NO;
    self.inAppPurchaseBtn.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.resetBtn.layer.borderWidth = 2.0f;
    self.resetBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.helpBtn.layer.borderWidth = 2.0f;
    self.helpBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.inAppPurchaseBtn.layer.borderWidth = 2.0f;
    self.inAppPurchaseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if ([currentDevice.deviceType isEqualToString:@"seven"])
    {
        self.bkgdImage.image = [UIImage imageNamed:@"About_BG_copy.png"];
        self.logoImage.image = [UIImage imageNamed:@"cam1000-02_Logo_Lighter copy 2_smaller.png"];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:140.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:42.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:75.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:150.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:75.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:240.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:115.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:480.0]];
        
        
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"plus"])
    {
        self.bkgdImage.image = [UIImage imageNamed:@"About_BG_copy.png"];
        self.logoImage.image = [UIImage imageNamed:@"cam1000-02_Logo_Lighter copy 2_smaller.png"];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:140.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:42.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:95.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:150.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:95.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:240.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
      
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:130.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:480.0]];
        
        
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        self.bkgdImage.image = [UIImage imageNamed:@"About_BG_copy.png"];
        self.logoImage.image = [UIImage imageNamed:@"cam1000-02_Logo_Lighter copy 2_smaller.png"];
        
        self.informationLabel.numberOfLines = 0;
        self.informationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.informationLabel.preferredMaxLayoutWidth = 300;
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:33.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:80.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:70.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:135.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:190]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:70.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:210.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:190]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:90.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:380.0]];
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"eleven,xr"])
    {
        self.bkgdImage.image = [UIImage imageNamed:@"About_BG_copy.png"];
        self.logoImage.image = [UIImage imageNamed:@"cam1000-02_Logo_Lighter copy 2_smaller.png"];
        
        self.informationLabel.numberOfLines = 0;
        self.informationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.informationLabel.preferredMaxLayoutWidth = 400;
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:136.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:53.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:110.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:90.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:220.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:190]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:90.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:300.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:190]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:110.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:450.0]];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UITabBarItem *)tabBarItem
{
    return [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"Navigation_SettingsIcon copy.png" ] tag:0];
}
 */



- (IBAction)ResetGame: (id)sender
{
  // Resetting Game consists of deleting the userinfo and the gamereivew files
    
    
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths objectAtIndex:0];
   NSString *filePath1 = [documentsDirectory stringByAppendingPathComponent:@"userInfo.archive"];
   NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:@"gameReview.archive"];
    
   [[NSFileManager defaultManager] removeItemAtPath:filePath1 error:NULL];
   [[NSFileManager defaultManager] removeItemAtPath:filePath2 error:NULL];
    
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice buildTabBar:1];
    
    //UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    //NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc]init];
    //AboutViewController *aboutVC = [[AboutViewController alloc]init];
    //SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    //GameScreenViewController *gameScreenVC = [[GameScreenViewController alloc]init];
    
    //AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tabBarController.viewControllers = [NSArray arrayWithObjects:gameScreenVC,aboutVC,settingsVC, nil];
    //myAppDelegate.window.rootViewController = tabBarController;


    //[self presentViewController:gameScreenVC animated:YES completion:nil];
    //[self presentViewController:nakedVC animated:NO completion:nil];
    //nakedVC.propGameReset = 1;
    //gameScreenVC.propGameReset = 1;

    
}

-(IBAction)BackToGame: (id)sender
{
    //UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice buildTabBar:0];
    
    //NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc]init];
    //AboutViewController *aboutVC = [[AboutViewController alloc]init];
    //SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    
    //nakedVC.propGameReset = 1;
    
    //AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[self presentViewController:nakedVC animated:NO completion:nil];
    
    //tabBarController.viewControllers = [NSArray arrayWithObjects:nakedVC,aboutVC,nil];
    //myAppDelegate.window.rootViewController = tabBarController;
}

- (IBAction)showSupportLink:(id)sender
{
    Config *objConfig = [[Config alloc ] init];
    NSString *keyName = @"websiteaddress";
    
    NSString *webSiteName = [objConfig getKeyValue:keyName];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webSiteName]];
    
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
