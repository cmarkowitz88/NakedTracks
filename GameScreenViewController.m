//
//  GameScreenViewController.m
//  NakedTracks
//
//  Created by rockstar on 4/6/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import <AWSCORE/Awscore.h>
#import <AWSS3/AWSS3.h>
#import "NakedTracksViewController.h"
#import "GameReviewViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "Song.h"
#import "Answer.h"
#import "GameReview.h"
#import "Reachability.h"
#import "NoConnectionViewController.h"
#import "GameOverViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "UserInfo.h"
#import "GameScreenViewController.h"
#import "WelcomeViewController.h"
#import "DeviceType.h"
#import "Constants.h"
#import "IAPViewController.h"

@import UIKit;

@interface GameScreenViewController () <GameReviewViewControllerDelegate>

// UI View Objects
@property (nonatomic, weak) IBOutlet UIImageView *mainBackgroundImage;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UILabel *streakLabel;
@property (nonatomic, weak) IBOutlet UILabel *streakLabelText;
@property (nonatomic, weak) IBOutlet UIImageView *dial1;
@property (nonatomic, weak) IBOutlet UIImageView *dial2;
@property (nonatomic, weak) IBOutlet UIButton *hintButton;
@property (nonatomic, weak) IBOutlet UIButton *pauseButton;
@property (nonatomic, weak) IBOutlet UIImageView *stopWatch;
@property (nonatomic, weak) IBOutlet UILabel *timeRemainingText;
@property (nonatomic, weak) IBOutlet UILabel *timeRemaining;
@property (nonatomic, weak) IBOutlet UIImageView *instrument;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITextView *hintText;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIButton *button3;
@property (nonatomic, weak) IBOutlet UIButton *button4;
@property (nonatomic, weak) IBOutlet UILabel *levelText;
@property (nonatomic, weak) IBOutlet UILabel *levelNumber;
@property (nonatomic, weak) IBOutlet UILabel *pipeSeparator;
@property (nonatomic, weak) IBOutlet UILabel *roundText;
@property (nonatomic, weak) IBOutlet UILabel *roundNumber;
@property (nonatomic, weak) IBOutlet UILabel *scoreText;
@property (nonatomic, weak) IBOutlet UILabel *scoreNumber;
@property (nonatomic, weak) IBOutlet UILabel *yourTimeText;
@property (nonatomic, weak) IBOutlet UILabel *yourTimeNumber;
@property (nonatomic, weak) IBOutlet UILabel *countOff;
@property (nonatomic, weak) IBOutlet UIImageView *soundBarStill;


// Network Reachability Properties
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation GameScreenViewController

@synthesize propHasInternetConnection;
@synthesize propGameReset;
@synthesize propGameOver;

AVAudioPlayer *avSound;
NSString *correctAnswer;
NSString *fileName;
NSDate *start;
NSString *playerSkillLevel;
NSString *formattedScore;
NSString *correctAnswerButtonName;
NSString *deviceType;
NSTimeInterval beforePausetimeInterval = 0.0;


//*** intLevel used to display to user. If user answers 8 out of 10 the level will increase by 1. After 10 levels user will advance to next skill level
int intLevel;

//*** intSkillLevel used to select songs from the database (1 = gold, 2 = silver, 3 = platinum)
int intSkillLevel;

int score;
int songCount;
int countOff;
int correctlyAnswered;
int downLoadSongCount;
int globalSongPointer;
int numCorrect;
int numIncorrect;
int indexOfHintAnswer;
int intSongCount;
int intStreak;
double trackLength;
double origTrackLength;
int blnGameReview;

Song *nextSong;
UserInfo *userInfo;
Song *firstSong;
DeviceType *currentDevice;

NSMutableArray *songList;
NSMutableArray *randomizedSongList;  // Will hold the randomized songs
NSMutableArray *answerList;
NSMutableArray *selectedSongs;
NSMutableArray *selectedAnswers;
NSMutableArray *gameReviewList;
NSMutableArray *currentAnswerArray;
NSMutableArray *gameScreenArray;
NSMutableArray *gameScreenArrayLarge;
NSMutableArray *soundBarsArray;
NSMutableArray *soundBarsStillArray;
NSMutableArray *soundBarsArraySmall;
NSMutableArray *soundBarsStillArraySmall;

UIButton *playSong;
UIButton *pauseButton;
UIButton *hintButton;

bool clickedAnswerButton;
bool isPaused;
bool isFirstSong;
bool blnPurchasedProduct;

int GS_SONGS_PER_ROUND = 10;
NSInteger GSVC_intSkillLevelGOLD = 1;
NSInteger GSVC_intSkillLevelSILVER = 21;
NSInteger GSVC_intSkillLevelPLATINUM = 31;
NSInteger GSVC_intSkillLevelGAMEOVER = 41;
NSInteger GSVC_SONGS_PER_ROUND = 10;
NSInteger intFontSize1;
NSInteger intFontSize2;

NSString *strIAPAlertTitle = @"Naked Tracks In App Purchase Required";
NSString *strIAPAlertMessage = @"You have used all the free songs available with this version. Click Purchase to purchase the full version or click Reset to reset the game and play again.";



// Flag to specify if the user is playing the free version.
NSInteger intFreeTier;

//******************************************************** Start Program *****************************************************************

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   
    
    //***** First Method that is called when the NIB File is called
    
    [timer invalidate];
    timer = nil;
    
    
    // Get the current value of the UserDefault if the user has purchased the full version
    DeviceType *currentDevice = [[DeviceType alloc]init];
    blnPurchasedProduct = [currentDevice getIapPurchaseValue];

    // Call the init method implemented by the SuperClass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:UIApplicationDidEnterBackgroundNotification object:nil];

    if(avSound)
    {
        [avSound stop];
    }
    
    // Stub out area where we'll retrieve the player's game data [high score, game level, etc]
    
    gameReviewList = [[NSMutableArray alloc]init];
    
    // * Check the user info archive
    userInfo = [[UserInfo alloc]init];
    userInfo = [userInfo getUserInfo];
    
    if(userInfo == Nil)
    {
        //*** If there is no User Profile Archive Information then this is the first time in
        userInfo = [[UserInfo alloc]init];
        intSkillLevel = 1;
        intLevel = 1;
        score = 0;
        intStreak = 0;
        intSongCount= 0;
    }
    else
    {   //*** If there is a archive then we will load that to restore the player's session
        intSkillLevel = userInfo.intSkillLevel;
        intLevel = userInfo.intRound;
        score = userInfo.dblScore;
        globalSongPointer = userInfo.intGlobalSongPointer;
        intSongCount = userInfo.intCurrentSongIndex;
        numCorrect = userInfo.intNumCorrect;
        intStreak = userInfo.intStreak;
        
    }
    
    //intLevel = 20;
    //intSkillLevel = 1;
    
    [self FormatScore:(score)];
    
    // * Check the game review array
    // * If intSongCount is 0 the user completed a full round and we don't want to load up the game review information
    if(intSongCount)
    {
        GameReview *savedGameReview = [[GameReview alloc]init];
        gameReviewList = [savedGameReview getSavedGameReviewInfo];
    }
    
    if(gameReviewList == Nil)
    {
        gameReviewList = [[NSMutableArray alloc]init];
    }

    if(self)
    {
        // ## Step 1 - Get the list of songs and check the hasInternetConnection to see if we are connected
        [self initializeSongList];
        
        if(propHasInternetConnection == 0)
        {
            return self;
        }
        
        // ## Step 2 - Get the list of answers and check the hasInternetConnection to see if we are still connected
        [self initializeAnswerList];
        
        if(propHasInternetConnection == 0)
        {
            return self;
        }
        
        firstSong = [[Song alloc]init];
        // ** Call to get the first song
        firstSong = [songList objectAtIndex:globalSongPointer];
        
        
        // ** Call this method to Download current round of songs
        isFirstSong = TRUE;
        
        //  ON 4/15/2017
        //[self displaySong:firstSong];
        //countOff = 2;
        //[self countOffTimer];
        
        
    }

    
    return self;
}



-(void)viewWillDisappear:(BOOL)animated
{
    //[avSound pause];
}
-(void)presentIAPMessage
{
    if(blnPurchasedProduct == false && intLevel == numOfFreeLevels)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:strIAPAlertTitle message:strIAPAlertMessage preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Purchase" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action )
                             {
                                 IAPViewController *iapVC = [[IAPViewController alloc]init];
                                 //iapVC.strCaller = @"MainMenu";
                                 iapVC.strCaller = @"AlertController";
                                 [self presentViewController:iapVC animated:YES completion:nil];
                             }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction  *action)
                                 {
                                     DeviceType *currentDevice = [[DeviceType alloc]init];
                                     [currentDevice gameReset];
                                     [currentDevice buildTabBar:1];
                                 }];
        
        [alert addAction: ok];
        [alert addAction: cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }

}


-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Will Appear");
    [self FormatScore:(score)];
    [self SetStreak:(intStreak)];
    
    self.mainBackgroundImage.image = [gameScreenArrayLarge objectAtIndex:intSkillLevel];
    
    if(isFirstSong)
    {
        [self displaySong:firstSong];
        countOff = 2;
        [self countOffTimer];
    }
    else if(blnGameReview)
    {
        // When we return from the game review controller check if the user is playing the free version and if they have completed round 8
        
        if(blnPurchasedProduct == false && intLevel == numOfFreeLevels)
        {
            [self presentIAPMessage];
            
            //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:strAlertTitle message:strAlertMessage preferredStyle:(UIAlertControllerStyleAlert)];
//            
//            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Purchase" style:UIAlertActionStyleDefault
//                                                       handler:^(UIAlertAction *action )
//                                 {
//                                     IAPViewController *iapVC = [[IAPViewController alloc]init];
//                                     iapVC.strCaller = @"MainMenu";
//                                     [self presentViewController:iapVC animated:YES completion:nil];
//                                 }];
//            
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault
//                                                           handler:^(UIAlertAction  *action)
//                                {
//                                    DeviceType *currentDevice = [[DeviceType alloc]init];
//                                    [currentDevice gameReset];
//                                    [currentDevice buildTabBar:1];
//                                }];
//            
//            [alert addAction: ok];
//            [alert addAction: cancel];
//            [self presentViewController:alert animated:YES completion:nil];
        }
        
        else
        {
         [self queueNextSong];
        }
        
        // If we are coming back from the game review screen we will clear out the flag
        // If user clicks the tab bar controller and comes back we don't want to queue the song a second time
        blnGameReview = false;
    }
 }

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ViewWillAppear");
 
    if(!propHasInternetConnection)
    {
        [self showNoConnectViewController];
    }
}


- (void)viewDidLoad {
 
    // First Method That is Called in the View Lifecycle
    
    [super viewDidLoad];
    
    //NSString *aboutPath = [[NSBundle mainBundle] pathForResource:@"SoundBarsBlue" ofType:@"gif"];
    //NSURL  *fileUrl = [NSURL fileURLWithPath:aboutPath isDirectory:NO];
    //NSURLRequest *myRequest = [[NSURLRequest alloc ]initWithURL:fileUrl];
    //[self.webView loadRequest:myRequest];
    
    [self setUIConstraints];
 
    self.instrument.image = [UIImage imageNamed:@"Drums copy.png"];
     //[self displaySong:firstSong];
}

- (void)setUIConstraints
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];
    
    self.instrument.hidden = TRUE;
    
    gameScreenArrayLarge = [[NSMutableArray alloc]init];
    [gameScreenArrayLarge addObject:[UIImage imageNamed:@"GameScreen_Blue_414_736.png"]];
    [gameScreenArrayLarge addObject:[UIImage imageNamed:@"GameScreen_Blue_414_736.png"]];
    [gameScreenArrayLarge addObject:[UIImage imageNamed:@"GameScreen_Yellow_414_736.png"]];
    [gameScreenArrayLarge addObject:[UIImage imageNamed:@"GameScreen_Orange_414_736.png"]];
    
    gameScreenArray = [[NSMutableArray alloc]init];
    [gameScreenArray addObject:[UIImage imageNamed:@"GameScreen_Blue.png"]];
    [gameScreenArray addObject:[UIImage imageNamed:@"GameScreen_Blue.png"]];
    [gameScreenArray addObject:[UIImage imageNamed:@"GameScreen_Yellow.png"]];
    [gameScreenArray addObject:[UIImage imageNamed:@"GameScreen_Orange.png"]];
    
    
    self.streakLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.streakLabelText.translatesAutoresizingMaskIntoConstraints=NO;
    self.dial1.translatesAutoresizingMaskIntoConstraints=NO;
    self.dial2.translatesAutoresizingMaskIntoConstraints=NO;
    self.hintButton.translatesAutoresizingMaskIntoConstraints=NO;
    self.pauseButton.translatesAutoresizingMaskIntoConstraints=NO;
    self.stopWatch.translatesAutoresizingMaskIntoConstraints=NO;
    self.timeRemainingText.translatesAutoresizingMaskIntoConstraints=NO;
    self.timeRemaining.translatesAutoresizingMaskIntoConstraints=NO;
    self.webView.translatesAutoresizingMaskIntoConstraints=NO;
    self.instrument.translatesAutoresizingMaskIntoConstraints=NO;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.hintText.translatesAutoresizingMaskIntoConstraints=NO;
    self.button1.translatesAutoresizingMaskIntoConstraints=NO;
    self.button2.translatesAutoresizingMaskIntoConstraints=NO;
    self.button3.translatesAutoresizingMaskIntoConstraints=NO;
    self.button4.translatesAutoresizingMaskIntoConstraints=NO;
    self.levelText.translatesAutoresizingMaskIntoConstraints=NO;
    self.levelNumber.translatesAutoresizingMaskIntoConstraints=NO;
    self.pipeSeparator.translatesAutoresizingMaskIntoConstraints=NO;
    self.roundText.translatesAutoresizingMaskIntoConstraints=NO;
    self.roundNumber.translatesAutoresizingMaskIntoConstraints=NO;
    self.scoreText.translatesAutoresizingMaskIntoConstraints=NO;
    self.scoreNumber.translatesAutoresizingMaskIntoConstraints=NO;
    self.yourTimeText.translatesAutoresizingMaskIntoConstraints=NO;
    self.yourTimeNumber.translatesAutoresizingMaskIntoConstraints=NO;
    self.countOff.translatesAutoresizingMaskIntoConstraints=NO;
    self.soundBarStill.translatesAutoresizingMaskIntoConstraints=NO;
    
    UIImage *hintBtnImage = [UIImage imageNamed:@"Hint_Full_Orange copy.png"];
    [self.hintButton setImage:hintBtnImage forState:UIControlStateNormal];
    
    UIImage *pauseBtnImage = [UIImage imageNamed:@"Pause_Full copy.png"];
    [self.pauseButton setImage:pauseBtnImage forState:UIControlStateNormal];
    
    //[self.button1 setBackgroundImage:AnswerBtnImage forState:UIControlStateNormal];
    //[self.button1 setTitle:@"Led Zeppelin\nStairway to Heaven" forState:UIControlStateNormal];
    self.button1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.button1.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //[self.button2 setBackgroundImage:AnswerBtnImage forState:UIControlStateNormal];
    //[self.button2 setTitle:@"Tears for Fears\nEverybody Wants to Rule the World" forState:UIControlStateNormal];
    self.button2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //[self.button3 setBackgroundImage:AnswerBtnImage forState:UIControlStateNormal];
    //[self.button3 setTitle:@"Paul Simon\nMe & Julio Down by the Schoolyard" forState:UIControlStateNormal];
    self.button3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.button3.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //[self.button4 setBackgroundImage:AnswerBtnImage forState:UIControlStateNormal];
    //[self.button4 setTitle:@"Billy Joel\nScenes From an Italin Restaurant" forState:UIControlStateNormal];
    self.button4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.button4.titleLabel.textAlignment = NSTextAlignmentCenter;

    
    
    // IPhone Plus
    if([currentDevice.deviceType  isEqual: @"plus"])
    {
        deviceType = @"plus";
        //self.mainBackgroundImage.image = [UIImage imageNamed:@"GameScreen_Blue_414_736.png"];
        
        self.mainBackgroundImage.image = [gameScreenArrayLarge objectAtIndex:intSkillLevel];
        self.mainBackgroundImage.frame = CGRectMake(0,0, screenWidth,screenHeight);
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.streakLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:348];
        [self.view addConstraint: constraint];
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.streakLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:385];
        [self.view addConstraint: constraint1];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.streakLabelText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:334];
        [self.view addConstraint: constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.streakLabelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:355];
        [self.view addConstraint: constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.dial1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:326];
        [self.view addConstraint: constraint4];
        
        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.dial1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
        [self.view addConstraint: constraint5];
        
        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.dial2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:326];
        [self.view addConstraint: constraint6];
        
        NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.dial2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:210];
        [self.view addConstraint: constraint7];
        
        NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.hintButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:314];
        [self.view addConstraint: constraint8];
        
        NSLayoutConstraint *constraint9 = [NSLayoutConstraint constraintWithItem:self.hintButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:150];
        [self.view addConstraint: constraint9];
        
        NSLayoutConstraint *constraint10 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:310];
        [self.view addConstraint: constraint10];
        
        NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:105];
        [self.view addConstraint: constraint11];
        
        NSLayoutConstraint *constraint12 = [NSLayoutConstraint constraintWithItem:self.stopWatch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:35];
        [self.view addConstraint: constraint12];
        
        NSLayoutConstraint *constraint13 = [NSLayoutConstraint constraintWithItem:self.stopWatch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:50];
        [self.view addConstraint: constraint13];

        NSLayoutConstraint *constraint14 = [NSLayoutConstraint constraintWithItem:self.timeRemainingText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:70];
        [self.view addConstraint: constraint14];
        
        NSLayoutConstraint *constraint15 = [NSLayoutConstraint constraintWithItem:self.timeRemainingText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:55];
        [self.view addConstraint: constraint15];
        
        NSLayoutConstraint *constraint16 = [NSLayoutConstraint constraintWithItem:self.timeRemaining attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:200];
        [self.view addConstraint: constraint16];
        
        NSLayoutConstraint *constraint17 = [NSLayoutConstraint constraintWithItem:self.timeRemaining attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:55];
        [self.view addConstraint: constraint17];
        
        NSLayoutConstraint *constraint18 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:200];
        [self.view addConstraint: constraint18];
        
        NSLayoutConstraint *constraint19 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50];
        [self.view addConstraint: constraint19];
        
        NSLayoutConstraint *constraint20 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:40];
        [self.view addConstraint: constraint20];
        
        NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:55];
        [self.view addConstraint: constraint21];

        NSLayoutConstraint *constraint22 = [NSLayoutConstraint constraintWithItem:self.instrument attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:43];
        [self.view addConstraint: constraint22];
        
        NSLayoutConstraint *constraint23 = [NSLayoutConstraint constraintWithItem:self.instrument attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:480];
        [self.view addConstraint: constraint23];
        
        NSLayoutConstraint *constraint24 = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:192];
        [self.view addConstraint: constraint24];
        
        NSLayoutConstraint *constraint25 = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:443];
        [self.view addConstraint: constraint25];
        
        NSLayoutConstraint *constraint26 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:124];
        [self.view addConstraint: constraint26];
        
        NSLayoutConstraint *constraint27 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:465];
        [self.view addConstraint: constraint27];
        
        NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-30];
        [self.view addConstraint: constraint28];
        
        NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:580];
        [self.view addConstraint: constraint29];

        NSLayoutConstraint *constraint30 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:22];
        [self.view addConstraint: constraint30];
        
        
        NSLayoutConstraint *constraint32 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:105];
        [self.view addConstraint: constraint32];
        
        NSLayoutConstraint *constraint33 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:270];
        [self.view addConstraint: constraint33];
        
        NSLayoutConstraint *constraint34 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
        [self.view addConstraint: constraint34];
        
        NSLayoutConstraint *constraint35 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:22];
        [self.view addConstraint: constraint35];
        
        NSLayoutConstraint *constraint36 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:185];
        [self.view addConstraint: constraint36];
        
        NSLayoutConstraint *constraint37 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:270];
        [self.view addConstraint: constraint37];
        
        NSLayoutConstraint *constraint38 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
        [self.view addConstraint: constraint38];
        
        NSLayoutConstraint *constraint39 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:22];
        [self.view addConstraint: constraint39];
        
        NSLayoutConstraint *constraint40 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:265];
        [self.view addConstraint: constraint40];
        
        NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:270];
        [self.view addConstraint: constraint41];
        
        NSLayoutConstraint *constraint42 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
        [self.view addConstraint: constraint42];
        
        NSLayoutConstraint *constraint43 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:22];
        [self.view addConstraint: constraint43];
        
        NSLayoutConstraint *constraint44 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:345];
        [self.view addConstraint: constraint44];
        
        NSLayoutConstraint *constraint45 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:270];
        [self.view addConstraint: constraint45];
        
        NSLayoutConstraint *constraint46 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
        [self.view addConstraint: constraint46];
        
        NSLayoutConstraint *constraint47 = [NSLayoutConstraint constraintWithItem:self.levelText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:15];
        [self.view addConstraint: constraint47];
        
        NSLayoutConstraint *constraint48 = [NSLayoutConstraint constraintWithItem:self.levelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:640];
        [self.view addConstraint: constraint48];
        
        NSLayoutConstraint *constraint49 = [NSLayoutConstraint constraintWithItem:self.levelNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:70];
        [self.view addConstraint: constraint49];
        
        NSLayoutConstraint *constraint50 = [NSLayoutConstraint constraintWithItem:self.levelNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:640];
        [self.view addConstraint: constraint50];
        
        NSLayoutConstraint *constraint51 = [NSLayoutConstraint constraintWithItem:self.pipeSeparator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:90];
        [self.view addConstraint: constraint51];
        
        NSLayoutConstraint *constraint52 = [NSLayoutConstraint constraintWithItem:self.pipeSeparator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:640];
        [self.view addConstraint: constraint52];
        
        NSLayoutConstraint *constraint53 = [NSLayoutConstraint constraintWithItem:self.roundText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:115];
        [self.view addConstraint: constraint53];
        
        NSLayoutConstraint *constraint54 = [NSLayoutConstraint constraintWithItem:self.roundText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:640];
        [self.view addConstraint: constraint54];
        
        NSLayoutConstraint *constraint55 = [NSLayoutConstraint constraintWithItem:self.roundNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:180];
        [self.view addConstraint: constraint55];
        
        NSLayoutConstraint *constraint56 = [NSLayoutConstraint constraintWithItem:self.roundNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:640];
        [self.view addConstraint: constraint56];
        
        NSLayoutConstraint *constraint57 = [NSLayoutConstraint constraintWithItem:self.scoreText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:260];
        [self.view addConstraint: constraint57];
        
        NSLayoutConstraint *constraint58 = [NSLayoutConstraint constraintWithItem:self.scoreText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:640];
        [self.view addConstraint: constraint58];
        
        NSLayoutConstraint *constraint59 = [NSLayoutConstraint constraintWithItem:self.scoreNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:315];
        [self.view addConstraint: constraint59];
        
        NSLayoutConstraint *constraint60 = [NSLayoutConstraint constraintWithItem:self.scoreNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:640];
        [self.view addConstraint: constraint60];
        
        NSLayoutConstraint *constraint61 = [NSLayoutConstraint constraintWithItem:self.countOff attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:70];
        [self.view addConstraint: constraint61];
        
        NSLayoutConstraint *constraint62 = [NSLayoutConstraint constraintWithItem:self.countOff attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:56];
        [self.view addConstraint: constraint62];
        
        NSLayoutConstraint *constraint63 = [NSLayoutConstraint constraintWithItem:self.yourTimeText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:38];
        [self.view addConstraint: constraint63];
        
        NSLayoutConstraint *constraint64 = [NSLayoutConstraint constraintWithItem:self.yourTimeText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:500];
        [self.view addConstraint: constraint64];
        
        NSLayoutConstraint *constraint65 = [NSLayoutConstraint constraintWithItem:self.yourTimeNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:52];
        [self.view addConstraint: constraint65];
        
        NSLayoutConstraint *constraint66 = [NSLayoutConstraint constraintWithItem:self.yourTimeNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:520];
        [self.view addConstraint: constraint66];
        
        NSLayoutConstraint *constraint67 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:253];
        [self.view addConstraint: constraint67];
        
        //NSLayoutConstraint *constraint68 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50];
        //[self.view addConstraint: constraint68];
        
        NSLayoutConstraint *constraint69 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:35];
        [self.view addConstraint: constraint69];
        
        //NSLayoutConstraint *constraint70 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:55];
        //[self.view addConstraint: constraint70];

    
    }
    
    // iPhone 6 or 7
    else if ([currentDevice.deviceType  isEqual: @"seven"])
    {
        deviceType = @"iphone7";
        //self.mainBackgroundImage.image = [UIImage imageNamed:@"GameScreen_Blue.png"];
        self.mainBackgroundImage.image = [gameScreenArray objectAtIndex:intSkillLevel];
        self.mainBackgroundImage.frame = CGRectMake(0,0,screenWidth,screenHeight);
        
        UIImage *hintBtnImage = [UIImage imageNamed:@"Hint_Full_Orange copy.png"];
        [self.hintButton setImage:hintBtnImage forState:UIControlStateNormal];
        
        UIImage *pauseBtnImage = [UIImage imageNamed:@"Pause_Full copy.png"];
        [self.pauseButton setImage:pauseBtnImage forState:UIControlStateNormal];
        
        UIImage *AnswerBtnImage = [UIImage imageNamed:@"Blue_Button copy.png"];
        
        intFontSize1 = 18;
        intFontSize2 = 14;
        
        [[self levelText] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self levelNumber] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self pipeSeparator] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self roundText] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self roundNumber] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self scoreText] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self scoreNumber] setFont:[UIFont systemFontOfSize:intFontSize1]];

        
        [self.button1 setBackgroundImage:AnswerBtnImage forState:UIControlStateNormal];
        //[self.button1 setTitle:@"Led Zeppelin\nStairway to Heaven" forState:UIControlStateNormal];
        self.button1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.button2 setBackgroundImage:AnswerBtnImage forState:UIControlStateNormal];
        //[self.button2 setTitle:@"Tears for Fears\nEverybody Wants to Rule the World" forState:UIControlStateNormal];
        self.button2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.button2.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.button3 setBackgroundImage:AnswerBtnImage forState:UIControlStateNormal];
        //[self.button3 setTitle:@"Paul Simon\nMe & Julio Down by the Schoolyard" forState:UIControlStateNormal];
        self.button3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.button3.titleLabel.textAlignment = NSTextAlignmentCenter;
     
     [self.button4 setBackgroundImage:AnswerBtnImage forState:UIControlStateNormal];
     //[self.button4 setTitle:@"Billy Joel\nScenes From an Italin Restaurant" forState:UIControlStateNormal];
     self.button4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     self.button4.titleLabel.textAlignment = NSTextAlignmentCenter;
     
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.streakLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:316];
        [self.view addConstraint: constraint];
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.streakLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:348];
        [self.view addConstraint: constraint1];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.streakLabelText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:296];
        [self.view addConstraint: constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.streakLabelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:322];
        [self.view addConstraint: constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.dial1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:293];
        [self.view addConstraint: constraint4];
        
        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.dial1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:260];
        [self.view addConstraint: constraint5];

        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.dial2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:293];
        [self.view addConstraint: constraint6];
        
        NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.dial2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:200];
        [self.view addConstraint: constraint7];
        
        NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.hintButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:280];
        [self.view addConstraint: constraint8];
        
        NSLayoutConstraint *constraint9 = [NSLayoutConstraint constraintWithItem:self.hintButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:150];
        [self.view addConstraint: constraint9];
        
        NSLayoutConstraint *constraint10 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:273];
        [self.view addConstraint: constraint10];
        
        NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:100];
        [self.view addConstraint: constraint11];
        
        NSLayoutConstraint *constraint12 = [NSLayoutConstraint constraintWithItem:self.stopWatch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:28];
        [self.view addConstraint: constraint12];
        
        NSLayoutConstraint *constraint13 = [NSLayoutConstraint constraintWithItem:self.stopWatch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:45];
        [self.view addConstraint: constraint13];
        
        NSLayoutConstraint *constraint14 = [NSLayoutConstraint constraintWithItem:self.timeRemainingText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:60];
        [self.view addConstraint: constraint14];
        
        NSLayoutConstraint *constraint15 = [NSLayoutConstraint constraintWithItem:self.timeRemainingText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:50];
        [self.view addConstraint: constraint15];
        
        NSLayoutConstraint *constraint16 = [NSLayoutConstraint constraintWithItem:self.timeRemaining attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:190];
        [self.view addConstraint: constraint16];
        
        NSLayoutConstraint *constraint17 = [NSLayoutConstraint constraintWithItem:self.timeRemaining attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:52];
        [self.view addConstraint: constraint17];
        
        NSLayoutConstraint *constraint18 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:180];
        [self.view addConstraint: constraint18];
        
        NSLayoutConstraint *constraint19 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50];
        [self.view addConstraint: constraint19];
        
        NSLayoutConstraint *constraint20 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:35];
        [self.view addConstraint: constraint20];
        
        NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:55];
        [self.view addConstraint: constraint21];
        
        NSLayoutConstraint *constraint22 = [NSLayoutConstraint constraintWithItem:self.instrument attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:36];
        [self.view addConstraint: constraint22];
        
        NSLayoutConstraint *constraint23 = [NSLayoutConstraint constraintWithItem:self.instrument attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:432];
        [self.view addConstraint: constraint23];
        
       
        
        NSLayoutConstraint *constraint24 = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:160];
        [self.view addConstraint: constraint24];
        
        NSLayoutConstraint *constraint25 = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
        [self.view addConstraint: constraint25];
        
        NSLayoutConstraint *constraint26 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:115];
        [self.view addConstraint: constraint26];
        
        NSLayoutConstraint *constraint27 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:420];
        [self.view addConstraint: constraint27];
        
        NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-35];
        [self.view addConstraint: constraint28];
        
        NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:525];
        [self.view addConstraint: constraint29];

        
        NSLayoutConstraint *constraint30 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:15];
        [self.view addConstraint: constraint30];
        
        
        NSLayoutConstraint *constraint32 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:95];
        [self.view addConstraint: constraint32];
        
        NSLayoutConstraint *constraint33 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250];
        [self.view addConstraint: constraint33];
        
        NSLayoutConstraint *constraint34 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
        [self.view addConstraint: constraint34];
        
        NSLayoutConstraint *constraint35 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:15];
        [self.view addConstraint: constraint35];
        
        NSLayoutConstraint *constraint36 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:165];
        [self.view addConstraint: constraint36];
        
        NSLayoutConstraint *constraint37 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250];
        [self.view addConstraint: constraint37];
        
        NSLayoutConstraint *constraint38 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
        [self.view addConstraint: constraint38];

        NSLayoutConstraint *constraint39 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:15];
        [self.view addConstraint: constraint39];
        
        NSLayoutConstraint *constraint40 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:235];
        [self.view addConstraint: constraint40];
        
        NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250];
        [self.view addConstraint: constraint41];
        
        NSLayoutConstraint *constraint42 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
        [self.view addConstraint: constraint42];
     
        NSLayoutConstraint *constraint43 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:15];
        [self.view addConstraint: constraint43];
     
        NSLayoutConstraint *constraint44 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:305];
        [self.view addConstraint: constraint44];
     
        NSLayoutConstraint *constraint45 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250];
        [self.view addConstraint: constraint45];
     
        NSLayoutConstraint *constraint46 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
        [self.view addConstraint: constraint46];

        NSLayoutConstraint *constraint47 = [NSLayoutConstraint constraintWithItem:self.levelText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:9];
        [self.view addConstraint: constraint47];
     
        NSLayoutConstraint *constraint48 = [NSLayoutConstraint constraintWithItem:self.levelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:575];
        [self.view addConstraint: constraint48];
     
        NSLayoutConstraint *constraint49 = [NSLayoutConstraint constraintWithItem:self.levelNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:67];
        [self.view addConstraint: constraint49];
     
        NSLayoutConstraint *constraint50 = [NSLayoutConstraint constraintWithItem:self.levelNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:575];
        [self.view addConstraint: constraint50];

        NSLayoutConstraint *constraint51 = [NSLayoutConstraint constraintWithItem:self.pipeSeparator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:82];
        [self.view addConstraint: constraint51];
     
        NSLayoutConstraint *constraint52 = [NSLayoutConstraint constraintWithItem:self.pipeSeparator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:574];
        [self.view addConstraint: constraint52];
     
        NSLayoutConstraint *constraint53 = [NSLayoutConstraint constraintWithItem:self.roundText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:95];
        [self.view addConstraint: constraint53];
     
        NSLayoutConstraint *constraint54 = [NSLayoutConstraint constraintWithItem:self.roundText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:575];
        [self.view addConstraint: constraint54];
     
        NSLayoutConstraint *constraint55 = [NSLayoutConstraint constraintWithItem:self.roundNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:164];
        [self.view addConstraint: constraint55];
     
        NSLayoutConstraint *constraint56 = [NSLayoutConstraint constraintWithItem:self.roundNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:575];
        [self.view addConstraint: constraint56];
     
        NSLayoutConstraint *constraint57 = [NSLayoutConstraint constraintWithItem:self.scoreText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:215];
        [self.view addConstraint: constraint57];
     
        NSLayoutConstraint *constraint58 = [NSLayoutConstraint constraintWithItem:self.scoreText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:575];
        [self.view addConstraint: constraint58];
     
        NSLayoutConstraint *constraint59 = [NSLayoutConstraint constraintWithItem:self.scoreNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:280];
        [self.view addConstraint: constraint59];
     
        NSLayoutConstraint *constraint60 = [NSLayoutConstraint constraintWithItem:self.scoreNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:575];
        [self.view addConstraint: constraint60];
        
        NSLayoutConstraint *constraint61 = [NSLayoutConstraint constraintWithItem:self.countOff attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:70];
        [self.view addConstraint: constraint61];
        
        NSLayoutConstraint *constraint62 = [NSLayoutConstraint constraintWithItem:self.countOff attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:52];
        [self.view addConstraint: constraint62];
        
        NSLayoutConstraint *constraint63 = [NSLayoutConstraint constraintWithItem:self.yourTimeText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:33];
        [self.view addConstraint: constraint63];
        
        NSLayoutConstraint *constraint64 = [NSLayoutConstraint constraintWithItem:self.yourTimeText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:445];
        [self.view addConstraint: constraint64];
        
        NSLayoutConstraint *constraint65 = [NSLayoutConstraint constraintWithItem:self.yourTimeNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:48];
        [self.view addConstraint: constraint65];
        
        NSLayoutConstraint *constraint66 = [NSLayoutConstraint constraintWithItem:self.yourTimeNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:465];
        [self.view addConstraint: constraint66];
        
        NSLayoutConstraint *constraint67 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:253];
        [self.view addConstraint: constraint67];
        
        //NSLayoutConstraint *constraint68 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50];
        //[self.view addConstraint: constraint68];
        
        NSLayoutConstraint *constraint69 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:35];
        [self.view addConstraint: constraint69];
        
        //NSLayoutConstraint *constraint70 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:55];
        //[self.view addConstraint: constraint70];

    }
    
    else if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        //self.mainBackgroundImage.image = [UIImage imageNamed:@"GameScreen_Blue.png"];
        self.mainBackgroundImage.image = [gameScreenArray objectAtIndex:intSkillLevel];
        self.mainBackgroundImage.frame = CGRectMake(0,0,screenWidth,screenHeight);
        intFontSize1 = 13;
        intFontSize2 = 14;
        
        [[self streakLabel] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self streakLabelText] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self timeRemaining] setFont:[UIFont systemFontOfSize:intFontSize2]];
        [[self timeRemainingText] setFont:[UIFont systemFontOfSize:intFontSize2]];
        [[self statusLabel] setFont:[UIFont systemFontOfSize:intFontSize2]];
        
        [self.button1.titleLabel setFont:[UIFont systemFontOfSize:intFontSize1]];
        [self.button2.titleLabel setFont:[UIFont systemFontOfSize:intFontSize1]];
        [self.button3.titleLabel setFont:[UIFont systemFontOfSize:intFontSize1]];
        [self.button4.titleLabel setFont:[UIFont systemFontOfSize:intFontSize1]];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.streakLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:270];
        [self.view addConstraint: constraint];
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.streakLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:296];
        [self.view addConstraint: constraint1];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.streakLabelText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:255];
        [self.view addConstraint: constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.streakLabelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:275];
        [self.view addConstraint: constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.dial1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:247];
        [self.view addConstraint: constraint4];
        
        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.dial1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:220];
        [self.view addConstraint: constraint5];
        
        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.dial2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:247];
        [self.view addConstraint: constraint6];
        
        NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.dial2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:163];
        [self.view addConstraint: constraint7];
        
        NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.hintButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:233];
        [self.view addConstraint: constraint8];
        
        NSLayoutConstraint *constraint9 = [NSLayoutConstraint constraintWithItem:self.hintButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:120];
        [self.view addConstraint: constraint9];
        
        NSLayoutConstraint *constraint10 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:229];
        [self.view addConstraint: constraint10];
        
        NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:80];
        [self.view addConstraint: constraint11];
        
        NSLayoutConstraint *constraint12 = [NSLayoutConstraint constraintWithItem:self.stopWatch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:28];
        [self.view addConstraint: constraint12];
        
        NSLayoutConstraint *constraint13 = [NSLayoutConstraint constraintWithItem:self.stopWatch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:35];
        [self.view addConstraint: constraint13];
        
        NSLayoutConstraint *constraint14 = [NSLayoutConstraint constraintWithItem:self.timeRemainingText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:60];
        [self.view addConstraint: constraint14];
        
        NSLayoutConstraint *constraint15 = [NSLayoutConstraint constraintWithItem:self.timeRemainingText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:43];
        [self.view addConstraint: constraint15];
        
        NSLayoutConstraint *constraint16 = [NSLayoutConstraint constraintWithItem:self.timeRemaining attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:172];
        [self.view addConstraint: constraint16];
        
        NSLayoutConstraint *constraint17 = [NSLayoutConstraint constraintWithItem:self.timeRemaining attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:43];
        [self.view addConstraint: constraint17];
        
        NSLayoutConstraint *constraint18 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
        [self.view addConstraint: constraint18];
        
        NSLayoutConstraint *constraint19 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:70];
        [self.view addConstraint: constraint19];
        
        NSLayoutConstraint *constraint20 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:32];
        [self.view addConstraint: constraint20];
        
        NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:55];
        [self.view addConstraint: constraint21];
        
        NSLayoutConstraint *constraint22 = [NSLayoutConstraint constraintWithItem:self.instrument attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint22];
        
        NSLayoutConstraint *constraint23 = [NSLayoutConstraint constraintWithItem:self.instrument attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:370];
        [self.view addConstraint: constraint23];
        
        
        NSLayoutConstraint *constraint24 = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:150];
        [self.view addConstraint: constraint24];
        
        NSLayoutConstraint *constraint25 = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:340];
        [self.view addConstraint: constraint25];
        
        NSLayoutConstraint *constraint26 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:100];
        [self.view addConstraint: constraint26];
        
        NSLayoutConstraint *constraint27 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:360];
        [self.view addConstraint: constraint27];
        
        NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-25];
        [self.view addConstraint: constraint28];
        
        NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:450];
        [self.view addConstraint: constraint29];
        
        
        NSLayoutConstraint *constraint30 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint30];
        
        
        NSLayoutConstraint *constraint32 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:85];
        [self.view addConstraint: constraint32];
        
        NSLayoutConstraint *constraint33 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220];
        [self.view addConstraint: constraint33];
        
        NSLayoutConstraint *constraint34 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [self.view addConstraint: constraint34];
        
        NSLayoutConstraint *constraint35 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint35];
        
        NSLayoutConstraint *constraint36 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:145];
        [self.view addConstraint: constraint36];
        
        NSLayoutConstraint *constraint37 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220];
        [self.view addConstraint: constraint37];
        
        NSLayoutConstraint *constraint38 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [self.view addConstraint: constraint38];
        
        NSLayoutConstraint *constraint39 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint39];
        
        NSLayoutConstraint *constraint40 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:205];
        [self.view addConstraint: constraint40];
        
        NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220];
        [self.view addConstraint: constraint41];
        
        NSLayoutConstraint *constraint42 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [self.view addConstraint: constraint42];
        
        NSLayoutConstraint *constraint43 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint43];
        
        NSLayoutConstraint *constraint44 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:265];
        [self.view addConstraint: constraint44];
        
        NSLayoutConstraint *constraint45 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220];
        [self.view addConstraint: constraint45];
        
        NSLayoutConstraint *constraint46 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [self.view addConstraint: constraint46];
        
        NSLayoutConstraint *constraint47 = [NSLayoutConstraint constraintWithItem:self.levelText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:9];
        [self.view addConstraint: constraint47];
        
        NSLayoutConstraint *constraint48 = [NSLayoutConstraint constraintWithItem:self.levelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:488];
        [self.view addConstraint: constraint48];
        
        NSLayoutConstraint *constraint49 = [NSLayoutConstraint constraintWithItem:self.levelNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:61];
        [self.view addConstraint: constraint49];
        
        NSLayoutConstraint *constraint50 = [NSLayoutConstraint constraintWithItem:self.levelNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:488];
        [self.view addConstraint: constraint50];
        
        NSLayoutConstraint *constraint51 = [NSLayoutConstraint constraintWithItem:self.pipeSeparator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:74];
        [self.view addConstraint: constraint51];
        
        NSLayoutConstraint *constraint52 = [NSLayoutConstraint constraintWithItem:self.pipeSeparator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:486];
        [self.view addConstraint: constraint52];
        
        NSLayoutConstraint *constraint53 = [NSLayoutConstraint constraintWithItem:self.roundText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:85];
        [self.view addConstraint: constraint53];
        
        NSLayoutConstraint *constraint54 = [NSLayoutConstraint constraintWithItem:self.roundText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:488];
        [self.view addConstraint: constraint54];
        
        NSLayoutConstraint *constraint55 = [NSLayoutConstraint constraintWithItem:self.roundNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:145];
        [self.view addConstraint: constraint55];
        
        NSLayoutConstraint *constraint56 = [NSLayoutConstraint constraintWithItem:self.roundNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:488];
        [self.view addConstraint: constraint56];
        
        NSLayoutConstraint *constraint57 = [NSLayoutConstraint constraintWithItem:self.scoreText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:175];
        [self.view addConstraint: constraint57];
        
        NSLayoutConstraint *constraint58 = [NSLayoutConstraint constraintWithItem:self.scoreText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:488];
        [self.view addConstraint: constraint58];
        
        NSLayoutConstraint *constraint59 = [NSLayoutConstraint constraintWithItem:self.scoreNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:230];
        [self.view addConstraint: constraint59];
        
        NSLayoutConstraint *constraint60 = [NSLayoutConstraint constraintWithItem:self.scoreNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:488];
        [self.view addConstraint: constraint60];
        
        NSLayoutConstraint *constraint61 = [NSLayoutConstraint constraintWithItem:self.countOff attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:70];
        [self.view addConstraint: constraint61];
        
        NSLayoutConstraint *constraint62 = [NSLayoutConstraint constraintWithItem:self.countOff attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:40];
        [self.view addConstraint: constraint62];
        
        NSLayoutConstraint *constraint63 = [NSLayoutConstraint constraintWithItem:self.yourTimeText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:25];
        [self.view addConstraint: constraint63];
        
        NSLayoutConstraint *constraint64 = [NSLayoutConstraint constraintWithItem:self.yourTimeText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:385];
        [self.view addConstraint: constraint64];
        
        NSLayoutConstraint *constraint65 = [NSLayoutConstraint constraintWithItem:self.yourTimeNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:38];
        [self.view addConstraint: constraint65];
        
        NSLayoutConstraint *constraint66 = [NSLayoutConstraint constraintWithItem:self.yourTimeNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
        [self.view addConstraint: constraint66];
        
        NSLayoutConstraint *constraint67 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:217];
        [self.view addConstraint: constraint67];
        
        //NSLayoutConstraint *constraint68 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50];
        //[self.view addConstraint: constraint68];
        
        NSLayoutConstraint *constraint69 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:28];
        [self.view addConstraint: constraint69];

    }
    
    else if ([currentDevice.deviceType isEqualToString:@"eleven,xr"])
    {
        intFontSize1 = 13;
        intFontSize2 = 14;
        
        self.mainBackgroundImage.image = [gameScreenArray objectAtIndex:intSkillLevel];
        self.mainBackgroundImage.frame = CGRectMake(0,0,screenWidth,screenHeight);
        
        [[self streakLabel] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self streakLabelText] setFont:[UIFont systemFontOfSize:intFontSize1]];
        [[self timeRemaining] setFont:[UIFont systemFontOfSize:intFontSize2]];
        [[self timeRemainingText] setFont:[UIFont systemFontOfSize:intFontSize2]];
        [[self statusLabel] setFont:[UIFont systemFontOfSize:intFontSize2]];
        
        [self.button1.titleLabel setFont:[UIFont systemFontOfSize:intFontSize1]];
        [self.button2.titleLabel setFont:[UIFont systemFontOfSize:intFontSize1]];
        [self.button3.titleLabel setFont:[UIFont systemFontOfSize:intFontSize1]];
        [self.button4.titleLabel setFont:[UIFont systemFontOfSize:intFontSize1]];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.streakLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:350];
        [self.view addConstraint: constraint];
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.streakLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:472];
        [self.view addConstraint: constraint1];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.streakLabelText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:300];
        [self.view addConstraint: constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.streakLabelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:275];
        [self.view addConstraint: constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.dial1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:247];
        [self.view addConstraint: constraint4];
        
        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.dial1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:220];
        [self.view addConstraint: constraint5];
        
        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.dial2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:247];
        [self.view addConstraint: constraint6];
        
        NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.dial2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:163];
        [self.view addConstraint: constraint7];
        
        NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.hintButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:233];
        [self.view addConstraint: constraint8];
        
        NSLayoutConstraint *constraint9 = [NSLayoutConstraint constraintWithItem:self.hintButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:120];
        [self.view addConstraint: constraint9];
        
        NSLayoutConstraint *constraint10 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:229];
        [self.view addConstraint: constraint10];
        
        NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:80];
        [self.view addConstraint: constraint11];
        
        NSLayoutConstraint *constraint12 = [NSLayoutConstraint constraintWithItem:self.stopWatch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:28];
        [self.view addConstraint: constraint12];
        
        NSLayoutConstraint *constraint13 = [NSLayoutConstraint constraintWithItem:self.stopWatch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:35];
        [self.view addConstraint: constraint13];
        
        NSLayoutConstraint *constraint14 = [NSLayoutConstraint constraintWithItem:self.timeRemainingText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:60];
        [self.view addConstraint: constraint14];
        
        NSLayoutConstraint *constraint15 = [NSLayoutConstraint constraintWithItem:self.timeRemainingText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:43];
        [self.view addConstraint: constraint15];
        
        NSLayoutConstraint *constraint16 = [NSLayoutConstraint constraintWithItem:self.timeRemaining attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:172];
        [self.view addConstraint: constraint16];
        
        NSLayoutConstraint *constraint17 = [NSLayoutConstraint constraintWithItem:self.timeRemaining attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:43];
        [self.view addConstraint: constraint17];
        
        NSLayoutConstraint *constraint18 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
        [self.view addConstraint: constraint18];
        
        NSLayoutConstraint *constraint19 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:70];
        [self.view addConstraint: constraint19];
        
        NSLayoutConstraint *constraint20 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:32];
        [self.view addConstraint: constraint20];
        
        NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:55];
        [self.view addConstraint: constraint21];
        
        NSLayoutConstraint *constraint22 = [NSLayoutConstraint constraintWithItem:self.instrument attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:45];
        [self.view addConstraint: constraint22];
        
        NSLayoutConstraint *constraint23 = [NSLayoutConstraint constraintWithItem:self.instrument attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:590];
        [self.view addConstraint: constraint23];
        
        
        NSLayoutConstraint *constraint24 = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:220];
        [self.view addConstraint: constraint24];
        
        NSLayoutConstraint *constraint25 = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:540];
        [self.view addConstraint: constraint25];
        
        NSLayoutConstraint *constraint26 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:140];
        [self.view addConstraint: constraint26];
        
        NSLayoutConstraint *constraint27 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:570];
        [self.view addConstraint: constraint27];
        
        NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-55];
        [self.view addConstraint: constraint28];
        
        NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.hintText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:700];
        [self.view addConstraint: constraint29];
        
        
        NSLayoutConstraint *constraint30 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint30];
        
        
        NSLayoutConstraint *constraint32 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:85];
        [self.view addConstraint: constraint32];
        
        NSLayoutConstraint *constraint33 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220];
        [self.view addConstraint: constraint33];
        
        NSLayoutConstraint *constraint34 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [self.view addConstraint: constraint34];
        
        NSLayoutConstraint *constraint35 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint35];
        
        NSLayoutConstraint *constraint36 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:145];
        [self.view addConstraint: constraint36];
        
        NSLayoutConstraint *constraint37 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220];
        [self.view addConstraint: constraint37];
        
        NSLayoutConstraint *constraint38 = [NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [self.view addConstraint: constraint38];
        
        NSLayoutConstraint *constraint39 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint39];
        
        NSLayoutConstraint *constraint40 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:205];
        [self.view addConstraint: constraint40];
        
        NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220];
        [self.view addConstraint: constraint41];
        
        NSLayoutConstraint *constraint42 = [NSLayoutConstraint constraintWithItem:self.button3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [self.view addConstraint: constraint42];
        
        NSLayoutConstraint *constraint43 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint43];
        
        NSLayoutConstraint *constraint44 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:265];
        [self.view addConstraint: constraint44];
        
        NSLayoutConstraint *constraint45 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220];
        [self.view addConstraint: constraint45];
        
        NSLayoutConstraint *constraint46 = [NSLayoutConstraint constraintWithItem:self.button4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [self.view addConstraint: constraint46];
        
        NSLayoutConstraint *constraint47 = [NSLayoutConstraint constraintWithItem:self.levelText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10];
        [self.view addConstraint: constraint47];
        
        NSLayoutConstraint *constraint48 = [NSLayoutConstraint constraintWithItem:self.levelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:775];
        [self.view addConstraint: constraint48];
        
        NSLayoutConstraint *constraint49 = [NSLayoutConstraint constraintWithItem:self.levelNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:61];
        [self.view addConstraint: constraint49];
        
        NSLayoutConstraint *constraint50 = [NSLayoutConstraint constraintWithItem:self.levelNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:775];
        [self.view addConstraint: constraint50];
        
        NSLayoutConstraint *constraint51 = [NSLayoutConstraint constraintWithItem:self.pipeSeparator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:74];
        [self.view addConstraint: constraint51];
        
        NSLayoutConstraint *constraint52 = [NSLayoutConstraint constraintWithItem:self.pipeSeparator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:775];
        [self.view addConstraint: constraint52];
        
        NSLayoutConstraint *constraint53 = [NSLayoutConstraint constraintWithItem:self.roundText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:85];
        [self.view addConstraint: constraint53];
        
        NSLayoutConstraint *constraint54 = [NSLayoutConstraint constraintWithItem:self.roundText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:775];
        [self.view addConstraint: constraint54];
        
        NSLayoutConstraint *constraint55 = [NSLayoutConstraint constraintWithItem:self.roundNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:145];
        [self.view addConstraint: constraint55];
        
        NSLayoutConstraint *constraint56 = [NSLayoutConstraint constraintWithItem:self.roundNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:775];
        [self.view addConstraint: constraint56];
        
        NSLayoutConstraint *constraint57 = [NSLayoutConstraint constraintWithItem:self.scoreText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:275];
        [self.view addConstraint: constraint57];
        
        NSLayoutConstraint *constraint58 = [NSLayoutConstraint constraintWithItem:self.scoreText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:775];
        [self.view addConstraint: constraint58];
        
        NSLayoutConstraint *constraint59 = [NSLayoutConstraint constraintWithItem:self.scoreNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:340];
        [self.view addConstraint: constraint59];
        
        NSLayoutConstraint *constraint60 = [NSLayoutConstraint constraintWithItem:self.scoreNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:775];
        [self.view addConstraint: constraint60];
        
        NSLayoutConstraint *constraint61 = [NSLayoutConstraint constraintWithItem:self.countOff attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:70];
        [self.view addConstraint: constraint61];
        
        NSLayoutConstraint *constraint62 = [NSLayoutConstraint constraintWithItem:self.countOff attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:40];
        [self.view addConstraint: constraint62];
        
        NSLayoutConstraint *constraint63 = [NSLayoutConstraint constraintWithItem:self.yourTimeText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:25];
        [self.view addConstraint: constraint63];
        
        NSLayoutConstraint *constraint64 = [NSLayoutConstraint constraintWithItem:self.yourTimeText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:385];
        [self.view addConstraint: constraint64];
        
        NSLayoutConstraint *constraint65 = [NSLayoutConstraint constraintWithItem:self.yourTimeNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:38];
        [self.view addConstraint: constraint65];
        
        NSLayoutConstraint *constraint66 = [NSLayoutConstraint constraintWithItem:self.yourTimeNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
        [self.view addConstraint: constraint66];
        
        NSLayoutConstraint *constraint67 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeLeading multiplier:1.0f constant:217];
        [self.view addConstraint: constraint67];
        
        //NSLayoutConstraint *constraint68 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainBackgroundImage attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:50];
        //[self.view addConstraint: constraint68];
        
        NSLayoutConstraint *constraint69 = [NSLayoutConstraint constraintWithItem:self.soundBarStill attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:28];
        [self.view addConstraint: constraint69];

    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)removeNewLineCharacter:(NSString *)inTitle
{
    NSString *strReturn;
    
    return strReturn;
}


- (void)initializeSongList
{
    Song *mySong = [[Song alloc]init];
    
    [songList removeAllObjects];
    songList = [mySong fetchSongsSynch:intSkillLevel arg2:blnPurchasedProduct];
    
    // Check the song list to see if it contains the songs - if not we probably don't have an active internet connection
    if([songList count] == 0)
    {
        // No Songs were retured and we need to send the user to the view controller for no internet connection
        //hasInternetConnection = 0;
        propHasInternetConnection = 0;
    }
    else
    {
        propHasInternetConnection = 1;
    }
    
    selectedSongs = [[NSMutableArray alloc]init];
 
}

- (void) initializeAnswerList
{
    Answer *myAnswer = [[Answer alloc]init];
    //answerList = [myAnswer getAnswers];
    answerList = [myAnswer FetchAnswersSync];
    
    if([answerList count] == 0)
    {
        // No answers were returned and we need to send the user to the view controller for on internet connection
        propHasInternetConnection = 0;
    }
    else
    {
        propHasInternetConnection = 1;
    }
    
    selectedAnswers = [[NSMutableArray alloc]init];
    
}

- (NSString *)getRandomAnswer:(int)featuredInstrumentIn
{
    NSInteger answerIndex;
    NSString *randomAnswer;
    int featuredInstrument = 0;
    Answer *currentAnswer = [[Answer alloc] init];
    int x = 0;
    
    NSString *tmpCorrectAnswer = correctAnswer;
    tmpCorrectAnswer = [tmpCorrectAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    do
    {
        featuredInstrument = 0;
        while( (int)featuredInstrumentIn != (int)featuredInstrument)
        {
            
            answerIndex = arc4random() % [answerList count];
            x++;
            
            while ([currentAnswerArray containsObject:[NSNumber numberWithInteger: answerIndex]])
            {
                answerIndex = arc4random() % [answerList count];
            }
            
            [currentAnswerArray addObject:[NSNumber numberWithInteger:answerIndex]];
            
            
            currentAnswer = [answerList objectAtIndex:answerIndex];
            randomAnswer = currentAnswer.answerName;
            randomAnswer = [randomAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            featuredInstrument = currentAnswer.intFeaturedInstrument;
            
            if([tmpCorrectAnswer isEqualToString:randomAnswer])
            {
                //continue;
            }
            
        }
    } while ([tmpCorrectAnswer isEqualToString:randomAnswer]);
    
    
    if([tmpCorrectAnswer isEqualToString:randomAnswer])
    {
        NSLog(@"RANDOM ANSWER DOES EQUAL THE CORRECT ANSWER");
    }
    
    if(randomAnswer == nil)
    {
        NSLog(@"No answer was found");
        NSLog(@"%@",currentAnswer);
    }
    
    
    return randomAnswer;
}

- (NSString *)addNewLineCharacter:(NSString *)inTitle
{
    NSString *title = [inTitle stringByReplacingOccurrencesOfString:@" - " withString:@"\n"];
    return title;
}

- (void)displaySong:(Song*)inSong
{
    NSString *answer1;
    NSString *answer2;
    NSString *answer3;
    NSString *answer4;
    NSString *playButtonTitle;
    NSString *roundDialImageName;
    NSInteger instrumentImageOffset = 7;
    NSInteger imageInstrumentIndex;
    soundBarsArray = [[NSMutableArray alloc]init];
    soundBarsStillArray = [[NSMutableArray alloc]init];
    
    soundBarsArraySmall = [[NSMutableArray alloc]init];
    soundBarsStillArraySmall = [[NSMutableArray alloc]init];
    
    [soundBarsArray addObject:@"SoundBarsBlue"];
    [soundBarsArray addObject:@"SoundBarsBlue"];
    [soundBarsArray addObject:@"SoundBarsYellow"];
    [soundBarsArray addObject:@"SoundBarsOrange"];
    
    [soundBarsArraySmall addObject:@"SoundBars_Blue_Small"];
    [soundBarsArraySmall addObject:@"SoundBars_Blue_Small"];
    [soundBarsArraySmall addObject:@"SoundBarsYellowSmall"];
    [soundBarsArraySmall addObject:@"SoundBarsOrangeSmall"];
    
    [soundBarsStillArray addObject:[UIImage imageNamed:@"SoundBars_Blue_High copy.png"]];
    [soundBarsStillArray addObject:[UIImage imageNamed:@"SoundBars_Blue_High copy.png"]];
    [soundBarsStillArray addObject:[UIImage imageNamed:@"SoundBars_Yellow_High copy.png"]];
    [soundBarsStillArray addObject:[UIImage imageNamed:@"SoundBars_Orange_High copy.png"]];
    
    [soundBarsStillArraySmall addObject:[UIImage imageNamed:@"Sound Bars Blue High Small.png"]];
    [soundBarsStillArraySmall addObject:[UIImage imageNamed:@"Sound Bars Blue High Small.png"]];
    [soundBarsStillArraySmall addObject:[UIImage imageNamed:@"SoundBars_Yellow_High_Small.png"]];
    [soundBarsStillArraySmall addObject:[UIImage imageNamed:@"SoundBars_Orange_High_Small.png"]];

    
    
    NSArray *instrumentImages;
    instrumentImages = [NSArray arrayWithObjects:
                        @"temp",
                        @"Electric copy.png",
                        @"Acoustic copy.png",
                        @"Bass copy.png",
                        @"Piano copy.png",
                        @"Keyboard copy.png",
                        @"Mandolin copy.png",
                        @"Drums copy.png",
                        @"Electric copy small.png",
                        @"Acoustic copy small.png",
                        @"Bass copy small.png",
                        @"Piano copy small.png",
                        @"Keyboard copy small.png",
                        @"Mandolin copy small.png",
                        @"Drums copy small.png",
                        nil];
    
    int featuredInstrument = [inSong intFeaturedInstrument];
    
    // Clear out the array of selected answers from the previous song
    [selectedAnswers removeAllObjects];
    
    fileName = [inSong fileLocation];
    correctAnswer = [inSong correctAnswer];
    trackLength = [inSong trackLength];
    origTrackLength = trackLength;
    
    correctAnswer = [self addNewLineCharacter:correctAnswer];
    
    
    int numOfAnswers = 4;
    int indexOfCorrectAnswer;
    
    NSString *aboutPath;
    
    if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        aboutPath = [[NSBundle mainBundle] pathForResource:[soundBarsArraySmall objectAtIndex:intSkillLevel] ofType:@"gif"];
        self.soundBarStill.image = [soundBarsStillArraySmall objectAtIndex:intSkillLevel];
    }
    else
    {
       //aboutPath = [[NSBundle mainBundle] pathForResource:@"SoundBarsBlue" ofType:@"gif"];
        aboutPath = [[NSBundle mainBundle] pathForResource:[soundBarsArray objectAtIndex:intSkillLevel] ofType:@"gif"];
        //self.soundBarStill.image = [UIImage imageNamed:@"SoundBars_Blue_High copy.png"];
        self.soundBarStill.image = [soundBarsStillArray objectAtIndex:intSkillLevel];
    }
    
    NSURL  *fileUrl = [NSURL fileURLWithPath:aboutPath isDirectory:NO];
    NSURLRequest *myRequest = [[NSURLRequest alloc ]initWithURL:fileUrl];
    [self.webView loadRequest:myRequest];
    self.webView.hidden=TRUE;
    
    // *** Configure the Pause Button
    [pauseButton addTarget:self action:@selector(Pause:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseButton.enabled = false;
    
    //*** Configure the Hint Button
    [hintButton addTarget:self action:@selector(ShowHint:)forControlEvents:UIControlEventTouchUpInside];
    hintButton.hidden = TRUE;
    
    if(songCount == 1)
    {
        playButtonTitle = @"Play Song";
    }
    else
    {
        playButtonTitle = @"Play Next Track";
    }
    
    // Randonly select the answer button that will contain the correct answer
    indexOfCorrectAnswer = (arc4random() % numOfAnswers) + 1;
    
    do
    {
        indexOfHintAnswer = (arc4random() % numOfAnswers) + 1;
        
    } while (indexOfCorrectAnswer == indexOfHintAnswer);
    
    
    // Randomly select the answer that will be hiddne when a user select the hint button
    
    
    // Initialize CurrentAnswerArray - This will prevent selecting the same answer multiple times.
    currentAnswerArray = [[NSMutableArray alloc]init];
    
    if(indexOfCorrectAnswer == 1)
    {
        answer1 = correctAnswer;
        correctAnswerButtonName = @"button1";
    }
    else
    {
        answer1 = [self getRandomAnswer:featuredInstrument];
        answer1 = [self addNewLineCharacter:answer1];
        NSLog(@"%@",answer1);
    }
    
    
    
    [self.button1 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    self.button1.hidden = TRUE;
    [self.button1 setTitle:answer1 forState:UIControlStateNormal];

    
    if(indexOfCorrectAnswer == 2)
    {
        answer2 = correctAnswer;
        correctAnswerButtonName = @"button2";
    }
    else
    {
        answer2 = [self getRandomAnswer:featuredInstrument];
        answer2 = [self addNewLineCharacter:answer2];
        NSLog(@"%@",answer2);
    }
    [self.button2 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    self.button2.hidden = TRUE;
    [self.button2 setTitle:answer2 forState:UIControlStateNormal];
    
    if(indexOfCorrectAnswer == 3)
    {
        answer3 = correctAnswer;
        correctAnswerButtonName = @"button3";
    }
    else
    {
        answer3 = [self getRandomAnswer:featuredInstrument];
        answer3 = [self addNewLineCharacter:answer3];
        NSLog(@"%@",answer3);
    }
    [self.button3 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    self.button3.hidden = TRUE;
    [self.button3 setTitle:answer3 forState:UIControlStateNormal];
    
    if(indexOfCorrectAnswer == 4)
    {
        answer4 = correctAnswer;
        correctAnswerButtonName = @"button4";
    }
    else
    {
        answer4 = [self getRandomAnswer:featuredInstrument];
        answer4 = [self addNewLineCharacter:answer4];
        NSLog(@"%@",answer4);
    }
    
    [self.button4 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    self.button4.hidden = TRUE;
    [self.button4 setTitle:answer4 forState:UIControlStateNormal];
    
    
    // Set the Instrument Icon
    imageInstrumentIndex = (NSInteger)featuredInstrument;
    
     if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
         imageInstrumentIndex +=instrumentImageOffset;
    
    self.instrument.image = [UIImage imageNamed:[instrumentImages objectAtIndex:imageInstrumentIndex]];
    
    /*switch(featuredInstrument)
    {
        case 1:
            self.instrument.image = [UIImage imageNamed:[instrumentImages objectAtIndex:featuredInstrument]];
            break;
            
        case 2:
            self.instrument.image = [UIImage imageNamed:@"Acoustic copy.png"];
            break;
            
        case 3:
            self.instrument.image = [UIImage imageNamed:@"Bass copy.png"];
            break;
            
        case 4:
            self.instrument.image = [UIImage imageNamed:@"Piano copy.png"];
            break;
            
        case 5:
            self.instrument.image = [UIImage imageNamed:@"@Keyboard copy"];
            break;
            
        case 6:
            self.instrument.image = [UIImage imageNamed:@"Mandolin copy.png"];
            break;
            
        case 7:
            self.instrument.image = [UIImage imageNamed:@"Drums copy.png"];
            break;
    }*/
    

    // Set the round-streak dial
    roundDialImageName = [NSString stringWithFormat:@"Dial_%d copy.png", intSongCount];
    self.dial1.image = [UIImage imageNamed:roundDialImageName];
    
    //Clear out the array of answers for the current song
    [currentAnswerArray removeAllObjects];
    self.levelNumber.text = [NSString stringWithFormat:@"%d", intSkillLevel];
    self.roundNumber.text = [NSString stringWithFormat:@"%d", intLevel];
    
    self.hintText.text = [inSong hint];
    self.hintText.hidden = true;
    self.statusLabel.text = @". . . . .";
    self.yourTimeNumber.hidden = TRUE;
    self.yourTimeText.hidden = TRUE;
    self.timeRemaining.hidden = TRUE;
    self.timeRemainingText.hidden = TRUE;
    self.pauseButton.titleLabel.hidden = TRUE;
    self.soundBarStill.hidden = TRUE;
}

/*
- (UITabBarItem *)tabBarItem
{
    return [[UITabBarItem alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"Navigation_HomeIcon copy.png"] tag:0];
}
 */

- (void)FormatScore:(NSInteger)inScore
{
 
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedScore = [formatter stringFromNumber:[NSNumber numberWithInteger:(inScore)]];
 
    self.scoreNumber.text = [NSString stringWithFormat:@"%@", formattedScore];
 
}

- (void)SetStreak: (NSInteger)inStreak
{
 
    self.streakLabel.text = [NSString stringWithFormat:@"%ld", (long)inStreak];
 
}

- (void)countOffTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountOffTimer:) userInfo:nil repeats:YES];
    
    self.countOff.text = @"Ready In:";
    
}

- (void)updateCountOffTimer:(NSTimer *)theTimer
{
    self.countOff.hidden = false;
    self.countOff.text = [NSString stringWithFormat:@"Ready In: %02d", countOff];
    
    if(countOff == 0)
    {
        self.countOff.text = @"Loading Track...";
 
    }
    
    if(countOff < 0)
    {
        if(timer)
        {
            [timer invalidate];
            timer = nil;
            self.countOff.hidden = true;
            //self.countOff.text = @"Loading...";
           
        }
        
        //self.questionLabel.text = @"Status:";
        //self.questionLabel.textColor = [UIColor whiteColor];
        //self.answerLabel.text = @"Your Time:";
        clickedAnswerButton = false;
        
        if(isFirstSong != true)
        {
            [self displaySong:nextSong];
        }
        
        isFirstSong = false;
        [self startSong];
    }
    
    countOff--;
    
}

- (void)countdownTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}

- (void)updateCounter:(NSTimer *)theTimer
{
    self.timeRemaining.text = [NSString stringWithFormat:@"%d", (int)trackLength];
    
    if(isPaused == true)
    {
        [timer invalidate];
        timer = nil;
        beforePausetimeInterval += [start timeIntervalSinceNow] * -1;
    }
    
    else if(trackLength == 0)
    {
        if(timer)
        {
            [timer invalidate];
            timer = nil;
            //self.answerBtn1.enabled = false;
            //self.answerBtn2.enabled = false;
            //self.answerBtn3.enabled = false;
            //self.answerBtn4.enabled = false;
            //self.answerBtn5.enabled = false;
            [self checkAnswer:@"OutOfTime"];
            //self.answerLabel.text = @"Out of Time";
            //Song *nextSong = [[Song alloc]init];
            //nextSong = [self getNextSong];
            //[self displaySong:nextSong];
            //countOff = 2;
            //[self countOffTimer];
            
        }
    }
    
    else
    {
        trackLength--;
    }
    
}

- (IBAction)checkAnswer:(id)sender
{
    [avSound stop];
    
    NSString *title = nil;
    BOOL blnOutOfTime = false;
    NSString *SoundFxName;
    
    self.timeRemainingText.hidden = TRUE;
    self.timeRemaining.text = @"";
    
    
    // If the user selected the pause button and then answered the song we need to reset the pause button back to pause
    isPaused = false;
    self.pauseButton.enabled = FALSE;
    [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    UIImage *pauseBtnImage = [UIImage imageNamed:@"Pause_Full copy.png"];
    [self.pauseButton setImage:pauseBtnImage forState:UIControlStateNormal];
    
    self.webView.hidden = TRUE;
    self.soundBarStill.hidden = FALSE;
    
    // Create an instance of the GameReview Object to store the user's answer status that we'll show after their round has completed
    // We will pass an array of these objects for each song
    GameReview *gmReviewCurrent = [[GameReview alloc]init];
    gmReviewCurrent.correctAnswer = correctAnswer;
    gmReviewCurrent.skillLevel = playerSkillLevel;
    
    // Check to make sure we haven't clicked the button multiple times
    // First time in this will be false and we will execute, if it was already clicked we will ignore it.
    
    if(clickedAnswerButton == false)
    {
        clickedAnswerButton = true;
        
        // Pepare the wrong answer sound affect so it's ready to go
        //NSString *wrongAnswerSound = @"Wrong-answer-sound-effect";
        //NSString *wrongAnswerSound = @"boo_2";
        //AVAudioSession *session = [AVAudioSession sharedInstance];
        //[session setCategory:AVAudioSessionCategoryPlayback error:nil];
        //NSURL *soundUrl = [[NSBundle mainBundle]URLForResource:wrongAnswerSound withExtension:@"mp3"];
        //NSURL *soundUrl = [[NSBundle mainBundle]URLForResource:wrongAnswerSound withExtension:@"wav"];
        //avSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
        //[avSound prepareToPlay];
        
        if(timer)
        {
            [timer invalidate];
            timer = nil;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"ss's'"];
        NSTimeInterval timeInterval = [start timeIntervalSinceNow] * -1;
        timeInterval += beforePausetimeInterval;
        NSString *length =[NSString stringWithFormat:@"%d", (int)timeInterval];
        
        if ((int)timeInterval <= 9)
        {
            self.yourTimeNumber.text = [NSString stringWithFormat:@"0:0%@", length];
        }
        else
        {
            self.yourTimeNumber.text = [NSString stringWithFormat:@"0:%@", length];
        }
        
        if ([sender isKindOfClass:[UIButton class]])
        {
            title = [(UIButton *)sender currentTitle];
        }
        else
        {
            blnOutOfTime = true;
        }
        
        self.yourTimeNumber.hidden = FALSE;
        self.yourTimeText.hidden = FALSE;
        self.instrument.hidden = TRUE;
        
        
        if (title == correctAnswer)
        {
            SoundFxName = [self PrepareAnswerSoundFX:(1)];
            numCorrect++;
            gmReviewCurrent.answerStatus = @"Correct";
            correctlyAnswered = 1;
            double tmpInterval = timeInterval;
            double tmp = (tmpInterval / origTrackLength) * 100;
            score += 1000 - tmp;
            intStreak ++;
            
            //formattedScore = [self FormatScore:(score)];
            [self FormatScore:(score)];
            [self SetStreak:(intStreak)];
            //self.scoreLabel.text = [NSString stringWithFormat:@"Score:%i", score];
            //self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", formattedScore];
            self.statusLabel.text = @"CORRECT!";
            //self.questionLabel.textColor = [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];
            //[(UIButton *)sender setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1]];
            UIImage *correctAnswerBtnImage = [UIImage imageNamed:@"Green_Button copy.png"];
            [(UIButton *)sender setBackgroundImage:correctAnswerBtnImage forState:UIControlStateNormal];
            [(UIButton *)sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            // If user answered correctly we will show the hint
            //[self.hintLabel sizeToFit];
            self.hintText.hidden = false;
            
            
        }
        else
        {
            SoundFxName = [self PrepareAnswerSoundFX:(0)];
            numIncorrect++;
            gmReviewCurrent.answerStatus = @"Incorrect";
            //[avSound play];
            correctlyAnswered = 0;
            intStreak = 0;
            [self SetStreak:(intStreak)];
            self.statusLabel.text = @"INCORRECT";
            
            //self.correctAnswerLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:12.0f];
            
            //self.correctAnswerLabel.text = [strCorretAnswerText stringByAppendingString:correctAnswer];
            
            
            
            if(!blnOutOfTime)
            {
                UIImage *correctAnswerBtnImage = [UIImage imageNamed:@"Green_Button copy.png"];
                UIImage *incorrectAnswerBtnImage = [UIImage imageNamed:@"Pink_Button copy.png"];
                
                // Set the selected button to Red and change the font to black
                [(UIButton *)sender setBackgroundImage:incorrectAnswerBtnImage forState:UIControlStateNormal];
                [(UIButton *)sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                // Set the correct button to Green and change the font to black
                UIButton *button = [self valueForKey:correctAnswerButtonName];
                [button setBackgroundImage:correctAnswerBtnImage forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                self.statusLabel.text = @"INCORRECT";
                
            }
            
            else
            {
                UIImage *correctAnswerBtnImage = [UIImage imageNamed:@"Green_Button copy.png"];
                UIButton *button = [self valueForKey:correctAnswerButtonName];
                [button setBackgroundImage:correctAnswerBtnImage forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                
                self.statusLabel.text = @"OUT OF TIME";
                
            }
        }
        
        beforePausetimeInterval = 0.0;
        AVAudioSession *FxSession = [AVAudioSession sharedInstance];
        [FxSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSURL *soundFxUrl = [[NSBundle mainBundle]URLForResource:SoundFxName withExtension:@"wav"];
        avSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundFxUrl error:nil];
        [avSound prepareToPlay];
        [avSound play];
        
        [gameReviewList addObject:gmReviewCurrent];
        
        // UNComment Here to have alert display after each response.
        //[self showAlert];
        
        // UNComment Here to not show alert
        
        // Check to see if the player has guessed 10 songs [10 songs per round]
        
        //intSongCount = globalSongPointer + 1;
        intSongCount++;
        globalSongPointer++;
        
        if(intSongCount % GSVC_SONGS_PER_ROUND == 0)
        {
            //Show view that will recap their round, show which songs were right, which were wrong and the correct answers
            
            //Perform check to see if we should increment the player's level
            if(numCorrect >= 8)
            {
                intLevel++;
                [self checkGameLevel:intLevel];
            }
            
            // Remove the previous round of songs from the TMP directory
            //[self ClearTmpDirectory];
            
            // Get the next 10 songs
            //  [self downLoadSongs];
            
            [NSThread sleepForTimeInterval:1];
            GameReviewViewController *gmReviewCntrl = [[GameReviewViewController alloc]init];
            gmReviewCntrl.delegate = self;
            gmReviewCntrl.data = gameReviewList;
            gmReviewCntrl.intRound = intLevel;
            gmReviewCntrl.modalPresentationStyle = UIModalPresentationFullScreen;
            gmReviewCntrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
            [self presentViewController:gmReviewCntrl animated:YES completion:Nil ];
            
            numCorrect = 0;
            intSongCount = 0;
        }
        
        else
        {
            
            [self queueNextSong];
            
        }
        
        
    } // End if clicked answer button first time
}

-(void) resetButtonStates
{
    UIImage *defaultBtnImage = [UIImage imageNamed:@"Gray_Button copy.png"];
    [self.button1 setBackgroundImage:defaultBtnImage forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:defaultBtnImage forState:UIControlStateNormal];
    [self.button3 setBackgroundImage:defaultBtnImage forState:UIControlStateNormal];
    [self.button4 setBackgroundImage:defaultBtnImage forState:UIControlStateNormal];

    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void) startSong
{
    self.button1.hidden = FALSE;
    self.button2.hidden = FALSE;
    self.button3.hidden = FALSE;
    self.button4.hidden = FALSE;
    self.webView.hidden = FALSE;
    self.pauseButton.enabled = TRUE;
    self.hintButton.hidden = FALSE;
    self.hintText.hidden = TRUE;
    self.timeRemainingText.hidden = FALSE;
    self.timeRemaining.text = @"";
    self.timeRemaining.hidden = FALSE;
    self.instrument.hidden = FALSE;
    self.soundBarStill.hidden = TRUE;
    
    [self resetButtonStates];

    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:NULL];
    
    NSString *tmpFilePrefix = @"https://s3.amazonaws.com/nakedtracks.audio/";
    NSString *tmpFileName = [tmpFilePrefix stringByAppendingString: fileName];
    
    tmpFileName = [tmpFileName stringByAppendingString:@".wav"];
    
    NSURL *url = [NSURL URLWithString:tmpFileName];
    //NSData *soundData = [NSData dataWithContentsOfURL:url];
    NSData *soundData2;
    
    NSURLResponse *urlResponse;
    NSError *error;
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    soundData2 = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    
    // ** Check to see if we have the data
    if(soundData2 != Nil)
    {
        avSound = [[AVAudioPlayer alloc]initWithData:soundData2 error:NULL];
        [avSound prepareToPlay];
        [avSound play];
    }
    
    else
    {
        [self showNoConnectViewController];
        return;
    }
       
    // Start the Clock
    start = [NSDate date];
    [self countdownTimer];
    
    [playSong setEnabled:NO];
    [playSong setBackgroundColor:[UIColor grayColor]];
    [playSong setTitle:@"Rolling..." forState:UIControlStateNormal];
    
}


-(void)showNoConnectViewController
{
    [self saveState];
 
    NoConnectionViewController *noConnectReviewCntrl = [[NoConnectionViewController alloc]init];
    noConnectReviewCntrl.modalPresentationStyle = UIModalPresentationFullScreen;
    noConnectReviewCntrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:noConnectReviewCntrl animated:NO completion:Nil ];
 
}

- (void)saveState
{
    // Package up the current score, round, and skill level to send to the archive file
    userInfo.dblScore = score;
    userInfo.intRound = intLevel;
    userInfo.intSkillLevel = intSkillLevel;
    userInfo.intGlobalSongPointer = globalSongPointer;
    userInfo.intCurrentSongIndex = intSongCount;
    userInfo.intNumCorrect = numCorrect;
    userInfo.intStreak = intStreak;
    [userInfo saveUserInfo];
 
    // Package up the current list of songs that the user has played for this round
    GameReview* tmpGameReview  = [[GameReview alloc]init];
    [tmpGameReview saveGameReviewInfo:gameReviewList];
 
}

- (NSString *)PrepareAnswerSoundFX:(int)questionStatus
{
    NSString *strAnswerSoundFXName;
    
    int applauseFx = 0;
    int numOfApplauseFx = 4;
    
    int booFx = 0;
    int numOfBooFx = 2;
    
    // If the user answered the question correct we will play a crowd cheering, if not we will play crowd booing
    
    if(questionStatus == 1)
    {
        applauseFx = (arc4random_uniform(numOfApplauseFx) + 1);
        strAnswerSoundFXName = @"applause_";
        strAnswerSoundFXName = [strAnswerSoundFXName stringByAppendingString:[NSString stringWithFormat:@"%li", (long)applauseFx]];
    }
    
    else if(questionStatus == 0)
    {
        booFx = (arc4random_uniform(numOfBooFx) + 1);
        strAnswerSoundFXName = @"boo_";
        strAnswerSoundFXName = [strAnswerSoundFXName stringByAppendingString:[NSString stringWithFormat:@"%li", (long)booFx]];
    }
    
    return strAnswerSoundFXName;
}

- (void) checkGameLevel: (NSInteger)inLevel
{
    // Check the current level - if current level = 11 we will advance the skill level to 2 (silver)
    // If current level = 21 we will advance the skill level to 2 (platinum)
    if(inLevel == GSVC_intSkillLevelSILVER)
    {
        intSkillLevel = 2;
        [self initializeSongList];
        globalSongPointer = 0;
    }
    
    else if(inLevel == GSVC_intSkillLevelPLATINUM)
    {
        intSkillLevel = 3;
        [self initializeSongList];
        globalSongPointer = 0;
    }
    
    else if(inLevel == GSVC_intSkillLevelGAMEOVER)
    {
        propGameOver = 1;
        
        
    }
    
} // End Method

- (void)queueNextSong
{
    nextSong = [[Song alloc]init];
    nextSong = [self getNextSong];
    //[self displaySong:nextSong];
    
    countOff = 2;
    [self countOffTimer];
    
}

- (Song *)getNextSong
{
    
    //globalSongPointer++;
    Song *currentSong = [[Song alloc]init];
    
    // Check to see if we have any songs left
    if(globalSongPointer == [songList count])
    {
        // Get More Songs
        [self initializeSongList];
        globalSongPointer = 0;
    }
    
    currentSong = [songList objectAtIndex:globalSongPointer];
    
    return currentSong;
}

- (IBAction)ShowHint:(id)sender
{
    switch (indexOfHintAnswer)
    {
        case 1:
            self.button1.hidden = true;
            break;
            
        case 2:
            self.button2.hidden = true;
            break;
            
        case 3:
            self.button3.hidden = true;
            break;
            
        case 4:
            self.button4.hidden = true;
            break;
       
    }
    
    self.hintText.hidden = false;
    self.statusLabel.text = @"HINT";
    
}

// Delegate Method
-(void) GameReviewViewControllerDidFinish:(GameReviewViewController *)Vc
{
    
    if(numCorrect >= 8)
    {
        //intLevel++;
        score = score + (numCorrect * 100);
        //formattedScore = [self FormatScore:(score)];
        [self FormatScore:(score)];
        //self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", formattedScore];
    }
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    [gameReviewList removeAllObjects];
   
    // Check if we are moving on to the next level and show the Level Screen
    // Otherwise dismiss the gamereviewcontroller and proceed normally

    if(propGameOver == 1)
    {
        GameOverViewController *gameOverReviewCntrl = [[GameOverViewController alloc]init];
        gameOverReviewCntrl.modalPresentationStyle = UIModalPresentationFullScreen;
        gameOverReviewCntrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self presentViewController:gameOverReviewCntrl animated:NO completion:Nil ];
        
    }
    
    else
    {
        //[self queueNextSong];
        blnGameReview = TRUE;
    }
}

- (IBAction)Pause:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;
    
    if([buttonTitle  isEqualToString: @"Pause"])
    {
        beforePausetimeInterval += [start timeIntervalSinceNow] * -1;
        [timer invalidate];
        timer = nil;
        [avSound pause];
        [button setTitle:@"Play" forState:UIControlStateNormal];
        isPaused = true;
        
        UIImage *pauseBtnImage = [UIImage imageNamed:@"Play_Full_Green copy.png"];
        [self.pauseButton setImage:pauseBtnImage forState:UIControlStateNormal];
        
        self.webView.hidden = TRUE;
        self.soundBarStill.hidden = FALSE;
        
        self.button1.enabled = false;
        self.button2.enabled = false;
        self.button3.enabled = false;
        self.button4.enabled = false;
        
        
    }
    
    else if([buttonTitle  isEqualToString: @"Play"])
    {
        [avSound play];
        [button setTitle:@"Pause" forState:UIControlStateNormal];
        UIImage *pauseBtnImage = [UIImage imageNamed:@"Pause_Full copy.png"];
        [self.pauseButton setImage:pauseBtnImage forState:UIControlStateNormal];
        
        self.webView.hidden = FALSE;
        self.soundBarStill.hidden = TRUE;

        isPaused = false;
        start = [NSDate date];
        [self countdownTimer];
        
        self.button1.enabled = true;
        self.button2.enabled = true;
        self.button3.enabled = true;
        self.button4.enabled = true;

    }

}


@end
