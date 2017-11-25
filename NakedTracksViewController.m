//
//  NakedTracksViewController.m
//  NakedTracks
//
//  Created by rockstar on 1/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
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

@import UIKit;

@interface NakedTracksViewController () <GameReviewViewControllerDelegate>

@property (nonatomic) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property (nonatomic, weak) IBOutlet UILabel *countOffLabel;
@property (nonatomic, weak) IBOutlet UILabel *songDownloadLabel;
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;
@property (nonatomic, weak) IBOutlet UILabel *hintLabel;
@property (nonatomic, weak) IBOutlet UIButton *answerBtn1;
@property (nonatomic, weak) IBOutlet UIButton *answerBtn2;
@property (nonatomic, weak) IBOutlet UIButton *answerBtn3;
@property (nonatomic, weak) IBOutlet UIButton *answerBtn4;
@property (nonatomic, weak) IBOutlet UIButton *answerBtn5;
@property (nonatomic, weak) IBOutlet UILabel *correctAnswerLabel;
@property (nonatomic, weak) IBOutlet UILabel *streakLabel;
@property (nonatomic, weak) IBOutlet UITextView *textViewHintText;

// Network Reachability Properties
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;


@end

@implementation NakedTracksViewController

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


//*** intLevel used to display to user. If user answers 8 out of 10 the level will increase by 1. After 10 levels user will advance to next skill level
int intLevel;

//*** intSkillLevel used to select songs from the database (1 = gold, 2 = silver, 3 = platinum)
int intSkillLevel;

int score;
int songCount;
int countOff;
int correctlyAnswered;
int SONGS_PER_ROUND = 10;
double trackLength;
double origTrackLength;
int downLoadSongCount;
int globalSongPointer;
int numCorrect;
int numIncorrect;
int indexOfHintAnswer;
int intSongCount;
int intStreak;
//int hasInternetConnection = 1;

Song *nextSong;
UserInfo *userInfo;

NSMutableArray *songList;
NSMutableArray *randomizedSongList;  // Will hold the randomized songs
NSMutableArray *answerList;
NSMutableArray *selectedSongs;
NSMutableArray *selectedAnswers;
NSMutableArray *gameReviewList;
NSMutableArray *currentAnswerArray;

UIButton *playSong;
//UIButton *answerBtn1;
//UIButton *answerBtn2;
//UIButton *answerBtn3;
//UIButton *answerBtn4;
//UIButton *answerBtn5;
UIButton *pauseButton;
UIButton *hintButton;

bool clickedAnswerButton;
bool isPaused;
bool isFirstSong;

NSInteger intSkillLevelGOLD = 1;
NSInteger intSkillLevelSILVER = 11;
NSInteger intSkillLevelPLATINUM = 21;
NSInteger intSkillLevelGAMEOVER = 31;

bool blnFullVersion;

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
    
    // Check the user's level and if necessary retrieve songs for the next higher level
    //[self checkGameLevel:(intLevel)];
    if(propGameOver == 1)
    {
        GameOverViewController *gameOverReviewCntrl = [[GameOverViewController alloc]init];
        gameOverReviewCntrl.score = score;
        gameOverReviewCntrl.modalPresentationStyle = UIModalPresentationFullScreen;
        gameOverReviewCntrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self presentViewController:gameOverReviewCntrl animated:NO completion:Nil ];

    }
    
    else
    {
        [self queueNextSong];
    }
}

- (UITabBarItem *)tabBarItem
{
    return [[UITabBarItem alloc] initWithTitle:@"Play" image:[UIImage imageNamed:@"home.png"] tag:0];
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Changed tabs!!!");
}

-(void)viewWillDisappear:(BOOL)animated
{
     //[avSound pause];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Will Appear");
    [self FormatScore:(score)];
    [self SetStreak:(intStreak)];
    
    //***   Test of the saveUserInfo message
    //userInfo = [[UserInfo alloc]init];
    //userInfo.intSkillLevel = 3;
    //userInfo.intRound = 1;
    //userInfo.dblScore = 10.00;
    //[userInfo saveUserInfo];
    
    
    /*
    if(!hasInternetConnection)
    {
        [self showNoConnectViewController];
        //NoConnectionViewController *noConnectReviewCntrl = [[NoConnectionViewController alloc]init];
        //noConnectReviewCntrl.modalPresentationStyle = UIModalPresentationFullScreen;
        //noConnectReviewCntrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        //[self presentViewController:noConnectReviewCntrl animated:YES completion:Nil ];
    }
     */
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ViewWillAppear");
    
    if(!propHasInternetConnection)
    {
        [self showNoConnectViewController];
        //NoConnectionViewController *noConnectReviewCntrl = [[NoConnectionViewController alloc]init];
        //noConnectReviewCntrl.modalPresentationStyle = UIModalPresentationFullScreen;
        //noConnectReviewCntrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        //[self presentViewController:noConnectReviewCntrl animated:YES completion:Nil ];
    }
}


-(void)showNoConnectViewController
{
    [self saveState];
    
    NoConnectionViewController *noConnectReviewCntrl = [[NoConnectionViewController alloc]init];
    noConnectReviewCntrl.modalPresentationStyle = UIModalPresentationFullScreen;
    noConnectReviewCntrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:noConnectReviewCntrl animated:NO completion:Nil ];

}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [self.hostReachability startNotifier];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    [self logReachability:self.hostReachability];
    [self logReachability:self.internetReachability];
    [self logReachability:self.wifiReachability];
    
    #if TARGET_IPHONE_SIMULATOR
    // where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    #endif
}

/*
-(void)loadView
{
    Create View
    CGR/Users/alyssa/Downloads/Wrong-answer-sound-effect/Wrong-answer-sound-effect.mp3ect frame = [UIScreen mainScreen].bounds;
    NakedTracksMainView *backgroundView = [[NakedTracksMainView alloc] initWithFrame:frame];
    self.view = backgroundView;
    
}
*/

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reachability = [notification object];
    [self logReachability: reachability];
}

- (void)logReachability:(Reachability *)reachability
{
    NSString *whichReachabilityString = nil;
    
    if (reachability == self.hostReachability) {
        whichReachabilityString = @"www.apple.com";
    } else if (reachability == self.internetReachability) {
        whichReachabilityString = @"The Internet";
    } else if (reachability == self.wifiReachability) {
        whichReachabilityString = @"Local Wi-Fi";
    }
    
    NSString *howReachableString = nil;
    
    switch (reachability.currentReachabilityStatus) {
        case NotReachable: {
            howReachableString = @"not reachable";
            break;
        }
        case ReachableViaWWAN: {
            howReachableString = @"reachable by cellular data";
            break;
        }
            
        case ReachableViaWiFi: {
            howReachableString = @"reachable by Wi-Fi";
            break;
        }
        
    }
    
    NSLog(@"%@ %@", whichReachabilityString, howReachableString);
    

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
      // Call the init method implemented by the SuperClass
      self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:UIApplicationDidEnterBackgroundNotification object:nil];

     if(avSound)
     {
       [avSound stop];
     }
    
      // ** Test Method to stream audio from AWS
      //[self StreamAudio];
      // ***************************************
    
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
          
         Song *firstSong = [[Song alloc]init];
         // ** Call to get the first song
         firstSong = [songList objectAtIndex:globalSongPointer];
         
         // ** OLD UNRANDOMIZED CALL TO GET THE NEXT SONG
         //firstSong = [self getNextSong];
          
         // ** New Call to get the first song
         //firstSong = [randomizedSongList objectAtIndex:globalSongPointer];
          
         // ** Call this method to Download A Song
         //[self downLoadSong:firstSong];
         // **
          
         // ** Call this method to Downlaod the very first round of song, this message from now will get called from another spot
         //[self downLoadSongs];
         // **
          
          // ** Call this method to Download current round of songs
          isFirstSong = TRUE;
          [self displaySong:firstSong];
          countOff = 2;
          [self countOffTimer];
          //self.hintLabel.text = @"";
         
      }
    
    return self;
    
}

- (void)initializeSongList
{
    Song *mySong = [[Song alloc]init];
    
    // ** Get Song List using asynchrously
    //[mySong fetchSongsASynch];
    
    [songList removeAllObjects];
    songList = [mySong fetchSongsSynch:intSkillLevel arg2:blnFullVersion];
    
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
    
    
    // ** Get Song List from JSON file.
    //songList = [mySong getSongs:playerSkillLevel];
    
    selectedSongs = [[NSMutableArray alloc]init];
    
    // ** Method to randomize the songs from the JSON File
    //[self randomizeSongList];
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

//*** Deprecated and not being called
- (void) randomizeSongList
{
    randomizedSongList = [[NSMutableArray alloc]init];
    
    while ( [songList count] != [selectedSongs count] )
    {
    
      NSInteger songPointer = arc4random() % [songList count];
    
      while ([selectedSongs containsObject:[NSNumber numberWithInteger: songPointer]])
      {
        songPointer = arc4random() % [songList count];
      }
    
    
    [selectedSongs addObject:[NSNumber numberWithInteger: songPointer]];
    
    Song *currentSong = [[Song alloc]init];
    songCount++;
    currentSong = [songList objectAtIndex:songPointer];
    
    [randomizedSongList addObject:currentSong];
    
    } // End While
    
    // Set Global Song Pointer to 0
    
    globalSongPointer = 0;

}
//*** Deprecated and not being called


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

- (NSString *)getRandomAnswerBKUP:(NSString*)featuredInstrumentIn
{
    NSInteger answerIndex;
    NSString *randomAnswer;
    NSString *featuredInstrument;
    
    answerIndex = arc4random() % [answerList count];
    
    while(![featuredInstrumentIn isEqualToString:featuredInstrument])
    {
        
        while ([selectedAnswers containsObject:[NSNumber numberWithInteger: answerIndex]])
        {
            answerIndex = arc4random() % [answerList count];
        }
        
        [selectedAnswers addObject:[NSNumber numberWithInteger:answerIndex]];
        
        Answer *currentAnswer = [[Answer alloc] init];
        currentAnswer = [answerList objectAtIndex:answerIndex];
        randomAnswer = currentAnswer.answerName;
        featuredInstrument = currentAnswer.featuredInstrument;
    }
    
    return randomAnswer;
}


- (void)displaySong:(Song*)inSong
{
    NSString *answer1;
    NSString *answer2;
    NSString *answer3;
    NSString *answer4;
    NSString *answer5;
    NSString *playButtonTitle;
    int featuredInstrument = [inSong intFeaturedInstrument];
    
    // Clear out the array of selected answers from the previous song
    [selectedAnswers removeAllObjects];
    
    fileName = [inSong fileLocation];
    correctAnswer = [inSong correctAnswer];
    trackLength = [inSong trackLength];
    origTrackLength = trackLength;
   
    int numOfAnswers = 5;
    int indexOfCorrectAnswer;
    
    //[self RemoveButtonsFromView];
    
    // *** Configure the Pause Button
    pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:pauseButton];
    pauseButton.titleLabel.numberOfLines = 0;
    [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [pauseButton sizeToFit];
    [pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pauseButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [pauseButton setBackgroundColor:[UIColor grayColor]];
    [pauseButton addTarget:self action:@selector(Pause:) forControlEvents:UIControlEventTouchUpInside];
    [pauseButton setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    [[pauseButton titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13.0f]];
    //answerBtn1.tag = answer1;
    //Round Button Corners
    CALayer *btnLayerPause = [pauseButton layer];
    [btnLayerPause setMasksToBounds:YES];
    [btnLayerPause setCornerRadius:5.0f];
    [btnLayerPause setBorderWidth:1.0f];
    [btnLayerPause setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [pauseButton setFrame:CGRectMake(5, 115, 75, 25)];
     pauseButton.hidden = TRUE;
    
    //*** Configure the Hint Button
    hintButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:hintButton];
    [hintButton setTitle:@"?? Need A Hint ??" forState:UIControlStateNormal];
    [hintButton sizeToFit];
    [hintButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hintButton setTitleColor: [UIColor greenColor] forState:UIControlStateHighlighted];
    [hintButton setBackgroundColor: [UIColor whiteColor]];
    [hintButton addTarget:self action:@selector(ShowHint:)forControlEvents:UIControlEventTouchUpInside];
    [hintButton setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    [[hintButton titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13.0f]];
    CALayer *btnHintLayer = [hintButton layer];
    [btnHintLayer setMasksToBounds:YES];
    [btnHintLayer setCornerRadius:5.0f];
    [btnHintLayer setBorderWidth:1.0f];
    [btnHintLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [hintButton setFrame:CGRectMake(10, 400, 300,30)];
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
        correctAnswerButtonName = @"answerBtn1";
    }
    else
    {
        answer1 = [self getRandomAnswer:featuredInstrument];
        NSLog(@"%@",answer1);
    }
    //answerBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   
    [self.answerBtn1 setTitle:answer1 forState:UIControlStateNormal];
    [self.answerBtn1 sizeToFit];
    [self.answerBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.answerBtn1 setBackgroundColor:[UIColor blackColor]];
    [self.answerBtn1 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.answerBtn1 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    [[self.answerBtn1 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13.0f]];
    //answerBtn1.tag = answer1;
    //Round Button Corners
    CALayer *btnLayer = [self.answerBtn1 layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.answerBtn1 setFrame:CGRectMake(10, 200, 300, 30)];
     self.answerBtn1.hidden = TRUE;
     [self.view addSubview:self.answerBtn1];
    //answerBtn1.transform = CGAffineTransformMakeRotation(90.0 * M_PI / 180.0);
    
    
    if(indexOfCorrectAnswer == 2)
    {
        answer2 = correctAnswer;
        correctAnswerButtonName = @"answerBtn2";

    }
    else
    {
        answer2 = [self getRandomAnswer:featuredInstrument];
        NSLog(@"%@",answer2);
    }
    //answerBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:self.answerBtn2];
    [self.answerBtn2 setTitle:answer2 forState:UIControlStateNormal];
    [self.answerBtn2 sizeToFit];
    [self.answerBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.answerBtn2 setBackgroundColor:[UIColor blackColor]];
    [self.answerBtn2 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.answerBtn2 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    [[self.answerBtn2 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13.0f]];
    //Round Button Corners
    CALayer *btnLayer2 = [self.answerBtn2 layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:5.0f];
    [btnLayer2 setBorderWidth:1.0f];
    [btnLayer2 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.answerBtn2 setFrame:CGRectMake(10, 240, 300, 30)];
    self.answerBtn2.hidden = TRUE;
    
    
    if(indexOfCorrectAnswer == 3)
    {
        answer3 = correctAnswer;
        correctAnswerButtonName = @"answerBtn3";

    }
    else
    {
        answer3 = [self getRandomAnswer:featuredInstrument];
        NSLog(@"%@",answer3);
    }
    //self.answerBtn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:self.answerBtn3];
    [self.answerBtn3 setTitle:answer3 forState:UIControlStateNormal];
    [self.answerBtn3 sizeToFit];
    [self.answerBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn3 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.answerBtn3 setBackgroundColor:[UIColor blackColor]];
    [self.answerBtn3 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.answerBtn3 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    [[self.answerBtn3 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13.0f]];
    //Round Button Corners
    CALayer *btnLayer3 = [self.answerBtn3 layer];
    [btnLayer3 setMasksToBounds:YES];
    [btnLayer3 setCornerRadius:5.0f];
    [btnLayer3 setBorderWidth:1.0f];
    [btnLayer3 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.answerBtn3 setFrame:CGRectMake(10, 280, 300, 30)];
    self.answerBtn3.hidden = TRUE;
    
    
    if(indexOfCorrectAnswer == 4)
    {
        answer4 = correctAnswer;
        correctAnswerButtonName = @"answerBtn4";

    }
    else
    {
        answer4 = [self getRandomAnswer:featuredInstrument];
        NSLog(@"%@",answer4);
    }
    //answerBtn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:self.answerBtn4];
    [self.answerBtn4 setTitle:answer4 forState:UIControlStateNormal];
    [self.answerBtn4 sizeToFit];
    [self.answerBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn4 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.answerBtn4 setBackgroundColor:[UIColor blackColor]];
    [self.answerBtn4 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.answerBtn4 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    [[self.answerBtn4 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13.0f]];
    //Round Button Corners
    CALayer *btnLayer4 = [self.answerBtn4 layer];
    [btnLayer4 setMasksToBounds:YES];
    [btnLayer4 setCornerRadius:5.0f];
    [btnLayer4 setBorderWidth:1.0f];
    [btnLayer4 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.answerBtn4 setFrame:CGRectMake(10, 320, 300, 30)];
    self.answerBtn4.hidden = TRUE;
    
    
    if(indexOfCorrectAnswer == 5)
    {
        answer5 = correctAnswer;
        correctAnswerButtonName = @"answerBtn5";

    }
    else
    {
        answer5 = [self getRandomAnswer:featuredInstrument];
        NSLog(@"%@",answer5);
    }
    //answerBtn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:self.answerBtn5];
    [self.answerBtn5 setTitle:answer5 forState:UIControlStateNormal];
    [self.answerBtn5 sizeToFit];
    [self.answerBtn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn5 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.answerBtn5 setBackgroundColor:[UIColor blackColor]];
    [self.answerBtn5 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [self.answerBtn5 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    [[self.answerBtn5 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13.0f]];
    //Round Button Corners
    CALayer *btnLayer5 = [self.answerBtn5 layer];
    [btnLayer5 setMasksToBounds:YES];
    [btnLayer5 setCornerRadius:5.0f];
    [btnLayer5 setBorderWidth:1.0f];
    [btnLayer5 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.answerBtn5 setFrame:CGRectMake(10, 360, 300, 30)];
    self.answerBtn5.hidden = TRUE;
   
    //Clear out the array of answers for the current song
    [currentAnswerArray removeAllObjects];
    self.levelLabel.text = [NSString stringWithFormat:@"Round: %d", intLevel];
    
    self.hintLabel.text = [inSong hint];
    self.hintLabel.hidden = true;
    self.correctAnswerLabel.text = @"";
    
    self.textViewHintText.text = [inSong hint];
    self.textViewHintText.hidden = true;
    
}

- (IBAction)ShowHint:(id)sender
{
    switch (indexOfHintAnswer)
    {
        case 1:
            self.answerBtn1.hidden = true;
            break;
            
        case 2:
            self.answerBtn2.hidden = true;
            break;
            
        case 3:
            self.answerBtn3.hidden = true;
            break;
            
        case 4:
            self.answerBtn4.hidden = true;
            break;
            
        case 5:
            self.answerBtn5.hidden = true;
            break;
    }
    
    self.hintLabel.hidden = false;
    self.textViewHintText.hidden = false;
    //[self.hintLabel sizeToFit];
}

- (IBAction)showQuestion:(id)sender
{
    
    self.answerBtn1.hidden = FALSE;
    self.answerBtn2.hidden = FALSE;
    self.answerBtn3.hidden = FALSE;
    self.answerBtn4.hidden = FALSE;
    self.answerBtn5.hidden = FALSE;
    
    self.answerLabel.text = @"";
    self.questionLabel.text = @"";
    
    // Step to the next question
    self.currentQuestionIndex++;
    
    // Are we past the last question
    if(self.currentQuestionIndex == [self.questions count])
    {
        self.currentQuestionIndex = 0;
    }
    
    // Get the string at that index in the questions array
    //NSString *question = self.questions[self.currentQuestionIndex];
    
    // Display the string in the question label
    //self.questionLabel.text = question;
    
    // Reset the answer label
    //self.answerLabel.text = @"???";

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL *soundUrl = [[NSBundle mainBundle]URLForResource:fileName withExtension:@"wav"];
    avSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    [avSound prepareToPlay];
    [avSound play];
    
    // Start the Clock
    start = [NSDate date];
    [self countdownTimer];
    
    [playSong setEnabled:NO];
    [playSong setBackgroundColor:[UIColor grayColor]];
    [playSong setTitle:@"Rolling..." forState:UIControlStateNormal];
    

}


- (void) startSong
{
    self.answerBtn1.hidden = FALSE;
    self.answerBtn2.hidden = FALSE;
    self.answerBtn3.hidden = FALSE;
    self.answerBtn4.hidden = FALSE;
    self.answerBtn5.hidden = FALSE;
    pauseButton.hidden = FALSE;
    hintButton.hidden = false;
    self.hintLabel.hidden = true;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:NULL];
    
    NSString *tmpFilePrefix = @"https://s3.amazonaws.com/nakedtracks.audio/";
    
    
    //NSString *tmpFileName = [fileName stringByAppendingString:@".wav"];
    
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

    
    
    /*  Previous Method of playing the dowlnoaded mp3 file from the tmp directory in the bundle
     
     NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:tmpFileName];
     AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL *soundUrl = [NSURL fileURLWithPath:downloadingFilePath ];
    avSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    [avSound prepareToPlay];
    [avSound play];
     */

    // Start the Clock
    start = [NSDate date];
    [self countdownTimer];
    
    [playSong setEnabled:NO];
    [playSong setBackgroundColor:[UIColor grayColor]];
    [playSong setTitle:@"Rolling..." forState:UIControlStateNormal];
    
}


- (IBAction)showAnswer:(id)sender
{
    // What is the answer to the current question
    NSString *answer = self.answers[self.currentQuestionIndex];
    
    // Display it in the answer label
    self.answerLabel.text = answer;
    
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

- (IBAction)checkAnswer:(id)sender
{
    [avSound stop];
    pauseButton.hidden = TRUE;
    isPaused = false;
    NSString *title = nil;
    BOOL blnOutOfTime = false;
    NSString * strCorretAnswerText = @"Correct Answer: ";
    NSString *SoundFxName;
    
    // Remove the current song from the song list
    //[songList removeObjectAtIndex:globalSongPointer];
    
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
       NSString *length =[NSString stringWithFormat:@"%d", (int)timeInterval];
       
       if ((int)timeInterval <= 9)
       {
         self.answerLabel.text = [NSString stringWithFormat:@"Your Time: 0:0%@", length];
       }
       else
       {
         self.answerLabel.text = [NSString stringWithFormat:@"Your Time: 0:%@", length];
       }
    
       if ([sender isKindOfClass:[UIButton class]])
       {
           title = [(UIButton *)sender currentTitle];
       }
       else
       {
           blnOutOfTime = true;
       }
    
    
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
          self.questionLabel.text = @"Status: Correct!";
          self.questionLabel.textColor = [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];
          [(UIButton *)sender setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1]];
          
           // If user answered correctly we will show the hint
           //[self.hintLabel sizeToFit];
           self.hintLabel.hidden = false;
           self.textViewHintText.hidden = false;
        
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
          self.questionLabel.text = @"Status: Sorry, wrong answer";
          self.questionLabel.textColor = [UIColor redColor];
          self.correctAnswerLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:12.0f];

          self.correctAnswerLabel.text = [strCorretAnswerText stringByAppendingString:correctAnswer];
           
          
          
           if(!blnOutOfTime)
           {
               [(UIButton *)sender setBackgroundColor:[UIColor redColor]];
               UIButton *button = [self valueForKey:correctAnswerButtonName];
               [button setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1]];
               self.questionLabel.text = @"Status: Sorry, wrong answer";

           }
           
           else
           {
               UIButton *button = [self valueForKey:correctAnswerButtonName];
               [button setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1]];

               self.questionLabel.text = @"Status: Out of Time";

           }
       }
        
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
        
        if(intSongCount % SONGS_PER_ROUND == 0)
        {
            //Show view that will recap their round, show which songs were right, which were wrong and the correct answers
            
            //Perform check to see if we should increment the player's level
            if(numCorrect >= 8)
            {
                intLevel++;
                [self checkGameLevel:intLevel];
            }
            
          // Remove the previous round of songs from the TMP directory
            [self ClearTmpDirectory];
          
          // Get the next 10 songs
          //  [self downLoadSongs];
        
          [NSThread sleepForTimeInterval:1];
          GameReviewViewController *gmReviewCntrl = [[GameReviewViewController alloc]init];
          gmReviewCntrl.delegate = self;
          gmReviewCntrl.data = gameReviewList;
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

- (void)RemoveButtonsFromView
{
    
    [self.answerBtn1 removeFromSuperview];
    [self.answerBtn2 removeFromSuperview];
    [self.answerBtn3 removeFromSuperview];
    [self.answerBtn4 removeFromSuperview];
    [self.answerBtn5 removeFromSuperview];
}

- (void)FormatScore:(NSInteger)inScore
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedScore = [formatter stringFromNumber:[NSNumber numberWithInteger:(inScore)]];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", formattedScore];
    //self.questionLabel.text = @"Status: Correct!";
    //self.questionLabel.textColor = [UIColor colorWithRed:0 green:0.6 blue:0 alpha:1];

    //return formattedScore;
                                
}

- (void)SetStreak: (NSInteger)inStreak
{
    self.streakLabel.text = [NSString stringWithFormat:@"Streak: %ld", (long)inStreak];
}

- (IBAction)Pause:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;

    
    if([buttonTitle  isEqualToString: @"Pause"])
    {
      [avSound pause];
      [button setTitle:@"Play" forState:UIControlStateNormal];
      isPaused = true;

    }
    
    else if([buttonTitle  isEqualToString: @"Play"])
    {
        [avSound play];
        [button setTitle:@"Pause" forState:UIControlStateNormal];
        isPaused = false;
        start = [NSDate date];
        [self countdownTimer];
        
    }
    
    
}

- (void)queueNextSong
{
    nextSong = [[Song alloc]init];
    nextSong = [self getNextSong];
    //[self displaySong:nextSong];
    
    countOff = 2;
    [self countOffTimer];
    
}


- (void)countdownTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    self.countdownLabel.text = @"Time Remaining: ";
    
}

- (void)updateCounter:(NSTimer *)theTimer
{
    self.countdownLabel.text = [NSString stringWithFormat:@"Time Remaining: 0:%02d", (int)trackLength];
    
    if(isPaused == true)
    {
       [timer invalidate];
        timer = nil;
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

- (void)countOffTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountOffTimer:) userInfo:nil repeats:YES];
    
    //self.countOffLabel.text = @"Ready ";
    
}

- (void)updateCountOffTimer:(NSTimer *)theTimer
{
    self.countOffLabel.hidden = false;
    self.countOffLabel.text = [NSString stringWithFormat:@"Ready %02d", countOff];
    
    if(countOff == 0)
    {
        if(timer)
        {
            [timer invalidate];
            timer = nil;
            self.countOffLabel.hidden = true;
            
        }
    
        self.questionLabel.text = @"Status:";
        self.questionLabel.textColor = [UIColor whiteColor];
        self.answerLabel.text = @"Your Time:";
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

- (void)showAlert
{
    NSString *Message;
    NSString *Title;
    
    if(correctlyAnswered == 1)
    {
        Title = @"Correct";
        Message = @"Correct answer.";
    }
    else
    {
        Title = @"Incorrect";
        Message = [NSString stringWithFormat:@"Sorry, that is incorrect\n The correct answer is:\n %@ ", correctAnswer];
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:Title
                          message:Message
                          delegate:self
                          cancelButtonTitle:@"Play Next Track"
                          otherButtonTitles:nil
                          ];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self queueNextSong];
    }
}

- (void) downLoadSongs
{
    // Interate through the songList MutableArray and GET ALL the song titles to download
    
    // Start dispatch to run on different thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    NSString *tmpSongName;
    NSUInteger totalSongs;
    
    totalSongs = [songList count];
   
    __block int intSongCount = 0;
    
    //for(Song *mySong in songList)
    for(int x = 0;x < 10;x++)
    {
        Song *mySong = [[Song alloc]init];
        mySong = [songList objectAtIndex:globalSongPointer + x];
        
        tmpSongName = mySong.fileLocation;
        
        NSString *tmpFileName = [tmpSongName stringByAppendingString:@".wav"];
        
        
        AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]initWithRegionType:AWSRegionUSEast1 identityPoolId:@"us-east-1:ca7b9483-8da8-4ff1-806e-d3dd7596b5b1"];
        
        AWSServiceConfiguration *configuration  = [[AWSServiceConfiguration alloc]initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
        
        AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
        
        NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:tmpFileName];
        NSURL *downloadingFileUrl = [NSURL fileURLWithPath:downloadingFilePath];
        
        AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
        downloadRequest.bucket = @"nakedtracks.audio";
        downloadRequest.key = tmpFileName;
        downloadRequest.downloadingFileURL = downloadingFileUrl;
        
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        NSLog(@"Download started, please wait...");
        
        
        [[transferManager download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                               withBlock:^id(BFTask *task){
                                                                   NSString *tst;
                                                                   if (task.error != nil) {
                                                                       NSLog(@"%s %@","Error downloading :", downloadRequest.key);
                                                                       tst = @"false";
                                                                   }
                                                                   else {
                                                                       NSLog(@"download completed");
                                                                       intSongCount++;
                                                                       downLoadSongCount = intSongCount;
                                                                       NSString *count =[NSString stringWithFormat:@"%d", (int)downLoadSongCount];
                                                                       self.songDownloadLabel.text = count;
                                                                       tst = @"true";
                                                                       
                                                                      
                                                                   }
                                                                   return nil;
                                                               }];
        
        
      } // End For Loop
         
    }); // End Dispatch
}

- (void) downLoadSong:(Song*)inSong
{
    // Go retrieve the current song
    
    NSString *tmpSongName;
    
    tmpSongName = inSong.fileLocation;
        
        NSString *tmpFileName = [tmpSongName stringByAppendingString:@".wav"];
    
        AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]initWithRegionType:AWSRegionUSEast1 identityPoolId:@"us-east-1:ca7b9483-8da8-4ff1-806e-d3dd7596b5b1"];
    
        AWSServiceConfiguration *configuration  = [[AWSServiceConfiguration alloc]initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
        
        AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
        
        NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:tmpFileName];
        NSURL *downloadingFileUrl = [NSURL fileURLWithPath:downloadingFilePath];
        
        AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
        downloadRequest.bucket = @"nakedtracks.audio";
        downloadRequest.key = tmpFileName;
        downloadRequest.downloadingFileURL = downloadingFileUrl;
        
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        NSLog(@"Download started, please wait...");
        
        [[transferManager download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                               withBlock:^id(BFTask *task){
                                                                   NSString *tst;
                                                                   if (task.error != nil) {
                                                                       NSLog(@"%s %@","Error downloading :", downloadRequest.key);
                                                                       tst = @"false";
                                                                   }
                                                                   else {
                                                                       NSLog(@"download completed");
                                                                       tst = @"true";
                                                                       
                                                                       
                                                                   }
                                                                   return nil;
                                                               }];
    
} // End Method

- (void) checkGameLevel: (NSInteger)inLevel
{
    // Check the current level - if current level = 11 we will advance the skill level to 2 (silver)
    // If current level = 21 we will advance the skill level to 2 (platinum)
    if(inLevel == intSkillLevelSILVER)
    {
        intSkillLevel = 2;
        [self initializeSongList];
        globalSongPointer = 0;
    }
    
    else if(inLevel == intSkillLevelPLATINUM)
    {
        intSkillLevel = 3;
        [self initializeSongList];
        globalSongPointer = 0;
    }
    
    else if(inLevel == intSkillLevelGAMEOVER)
    {
        propGameOver = 1;
        
        
    }
    
} // End Method


- (void)ClearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[ NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(),file] error:NULL];
    }
    
} // End Method

- (void)StreamAudio
{
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/nakedtracks.audio/21_Guns.wav"];
    NSData *soundData = [NSData dataWithContentsOfURL:url];
    avSound = [[AVAudioPlayer alloc]initWithData:soundData error:NULL];
    [avSound play];
    
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



@end
