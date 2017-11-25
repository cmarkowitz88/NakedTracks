//
//  MainMenuViewController.m
//  NakedTracks
//
//  Created by rockstar on 4/25/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import "MainMenuViewController.h"
#import "DeviceType.h"
#import "WelcomeViewController.h"
#import "AboutViewController.h"
#import "IAPViewController.h"
#import "Constants.h"
#import "Config.h"

@interface MainMenuViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, weak) IBOutlet UIImageView *logoImage;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIButton *button3;
@property (nonatomic, weak) IBOutlet UIButton *button4;
@end

@implementation MainMenuViewController

NSString *strCheaterAlertTitle = @"Resetting Game.";
NSString *strCheaterAlertMessage = @"You have used all the free songs available with this version. The game will reset now. You can continue to play, however you won't be able to complete all the levels. Click the shopping cart to purchase the full game.";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUIConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUIConstraints
{
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];
    
    self.backgroundImage.image = [UIImage imageNamed:@"reel.jpg"];
    self.logoImage.image = [UIImage imageNamed:@"cam1000-02_Logo_Lighter copy.png"];
    
    self.button1.layer.borderWidth = 2.0f;
    self.button1.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.button1 setTitle:@"PLAY" forState:UIControlStateNormal];
    
    self.button2.layer.borderWidth = 2.0f;
    self.button2.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.button2 setTitle:@"ABOUT" forState:UIControlStateNormal];
     
    self.button3.layer.borderWidth = 2.0f;
    self.button3.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.button3 setTitle:@"HELP/SUPPORT" forState:UIControlStateNormal];
    
    self.button4.layer.borderWidth = 2.0f;
    self.button4.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.button4 setTitle:@"GET FULL VERSION" forState:UIControlStateNormal];
    
    
    self.backgroundImage.translatesAutoresizingMaskIntoConstraints=NO;
    self.logoImage.translatesAutoresizingMaskIntoConstraints=NO;
    self.button1.translatesAutoresizingMaskIntoConstraints=NO;
    self.button2.translatesAutoresizingMaskIntoConstraints=NO;
    self.button3.translatesAutoresizingMaskIntoConstraints=NO;
    self.button4.translatesAutoresizingMaskIntoConstraints=NO;
    
    if ( [currentDevice.deviceType isEqualToString:@"seven"] )
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:90.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:35.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:80.0]];
    
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:270.0]];
    
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
    
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:80.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:360.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:80.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:450.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];

    }
    
    else if ([currentDevice.deviceType isEqualToString:@"plus"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:110.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:45.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:270.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:360.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:450.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:68.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:35.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:52.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:250.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:52.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:340.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:52.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:430.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
    }
}

- (IBAction)playGame:(id)sender
{
    // If the user was presented with the IAP message and elected to purchase the game, they can still cancel out from the IAP screen
    // If the cancel out they will come back to the game screen, this check will inform the user the game is resetting
    if(blnTryingToCheat)
    {
        [self resetForCheater];
    }
    else
    {
        WelcomeViewController *welcomeVC = [[WelcomeViewController alloc]init];
        [self presentViewController:welcomeVC animated:YES completion:nil];
    }
}

-(void)resetForCheater
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:strCheaterAlertTitle message:strCheaterAlertMessage preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action )
                         {
                             DeviceType *currentDevice = [[DeviceType alloc]init];
                             [currentDevice gameReset];
                             [currentDevice buildTabBar:1];
                         }];
    
    
    [alert addAction: ok];
    
    blnTryingToCheat = FALSE;
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)showSupportLink:(id)sender
{
    Config *objConfig = [[Config alloc ] init];
    NSString *keyName = @"websiteaddress";
    
    NSString *webSiteName = [objConfig getKeyValue:keyName];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webSiteName]];
    
}

- (IBAction)showAboutScreen:(id)sender
{
    AboutViewController *aboutVC = [[AboutViewController alloc]init];
    [self presentViewController:aboutVC animated:YES completion:nil];
}

- (IBAction)inAppPurchase:(id)sender
{
    IAPViewController *iapVC = [[IAPViewController alloc]init];
    iapVC.strCaller = @"MainMenu";
    [self presentViewController:iapVC animated:YES completion:nil];
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
