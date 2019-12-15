//
//  GameOverViewController.m
//  NakedTracks
//
//  Created by rockstar on 1/15/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import "GameOverViewController.h"
#import "NakedTracksViewController.h"
#import "AboutViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "DeviceType.h"
#import "GameScreenViewController.h"

@interface GameOverViewController ()

@property (nonatomic,weak) IBOutlet UIButton *playAgainBtn;
@property (nonatomic,weak) IBOutlet UIImageView *imgViewBkgd;
@property (nonatomic,weak) IBOutlet UIImageView *imgLogo;
@property (nonatomic,weak) IBOutlet UILabel *congratsLabel;
@property (nonatomic,weak) IBOutlet UILabel *textLabel;
@property (nonatomic,weak) IBOutlet UILabel *lblScoreText;
@property (nonatomic,weak) IBOutlet UILabel *lblScoreNumber;


@end

@implementation GameOverViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.playAgainBtn.layer.borderWidth = 2.0f;
    self.playAgainBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.playAgainBtn setTitle:@"PLAY AGAIN" forState:UIControlStateNormal];
    
    [self setUIConstraints];
    [self setScore];
}

- (void)setScore
{
    DeviceType *DeviceTempScore = [[DeviceType alloc]init];
    
    
    self.score = 3450595;
    NSString *tmpScore = [DeviceTempScore FormatScore:self.score];
    //NSString *scoreText = @"Your Score: ";
    //scoreText = [scoreText stringByAppendingString:tmpScore];
    self.lblScoreNumber.text = tmpScore;
    self.lblScoreText.text = @"Score:";
}

- (void)setUIConstraints
{
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];

    self.imgViewBkgd.image = [UIImage imageNamed:@"About_BG_copy.png"];
    
    self.congratsLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.playAgainBtn.translatesAutoresizingMaskIntoConstraints=NO;
    self.textLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.imgLogo.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblScoreText.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblScoreNumber.translatesAutoresizingMaskIntoConstraints=NO;
    
    if ([currentDevice.deviceType isEqualToString:@"seven"])
    {
        self.textLabel.preferredMaxLayoutWidth = 279;
        self.imgLogo.image = [UIImage imageNamed:@"LogoLaunchSmall.png"];

        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:93.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:37.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:50.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:360.0]];
        
        
         [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:430.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:77.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgLogo attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgLogo attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:152.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:232.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:110.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:260.0]];
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"plus"])
    {
        self.textLabel.preferredMaxLayoutWidth = 279;
        self.imgLogo.image = [UIImage imageNamed:@"LogoLaunchSmall.png"];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:103.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:43.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:65.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:360.0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:430.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:92.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgLogo attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgLogo attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:110.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:170.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:237.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:117.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:265.0]];


    }
    
    
    else if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        self.textLabel.preferredMaxLayoutWidth = 279;
        self.imgLogo.image = [UIImage imageNamed:@"LogoLaunchSmall.png"];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:61.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:28.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:27.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:320.0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:395.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:50.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgLogo attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:70.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgLogo attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:80.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:125.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:210.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:82.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:240.0]];

    }
    
    else if ([currentDevice.deviceType isEqualToString:@"eleven,xr"])
    {
        self.textLabel.preferredMaxLayoutWidth = 279;
        self.imgLogo.image = [UIImage imageNamed:@"LogoLaunchSmall.png"];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:85.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.congratsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:47.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:420.0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:495.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:75.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playAgainBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgLogo attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:90.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgLogo attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:120.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:140.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:280.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:99.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblScoreNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:315.0]];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PlayGameAgain: (id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath1 = [documentsDirectory stringByAppendingPathComponent:@"userInfo.archive"];
    NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:@"gameReview.archive"];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath1 error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:filePath2 error:NULL];
    
    /*
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc]init];
    AboutViewController *aboutVC = [[AboutViewController alloc]init];
    SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:nakedVC,aboutVC,settingsVC, nil];
    myAppDelegate.window.rootViewController = tabBarController;
    */
    
    //[self presentViewController:nakedVC animated:NO completion:nil];
    //GameScreenViewController *gameVC = [[GameScreenViewController alloc]init];
    //gameVC.propGameReset = 1;
    DeviceType *localDevice = [[DeviceType alloc]init];
    [localDevice buildTabBar:0];

    //[self presentViewController:gameVC animated:NO completion:nil];
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
