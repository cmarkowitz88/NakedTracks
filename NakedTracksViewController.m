//
//  NakedTracksViewController.m
//  NakedTracks
//
//  Created by rockstar on 1/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "NakedTracksViewController.h"
#import "NakedTracksMainView.h"
#import "AVFoundation/AVFoundation.h"
#import <AWSCORE/Awscore.h>
#import "Song.h"
#import "Answer.h"
@import UIKit;

@interface NakedTracksViewController ()

@property (nonatomic) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property (nonatomic, weak) IBOutlet UILabel *countOffLabel;

@end

@implementation NakedTracksViewController

AVAudioPlayer *avSound;
NSString *correctAnswer;
NSString *fileName;
NSDate *start;

int score;
int songCount;
int countOff;
int correctlyAnswered;
double trackLength;
double origTrackLength;

NSMutableArray *songList;
NSMutableArray *answerList;
NSMutableArray *selectedSongs;
NSMutableArray *selectedAnswers;

UIButton *playSong;
UIButton *answerBtn1;
UIButton *answerBtn2;
UIButton *answerBtn3;
UIButton *answerBtn4;
UIButton *answerBtn5;


-(void)viewDidLoad
{
    [super viewDidLoad];
}

/*
-(void)loadView
{
    Create View
    CGRect frame = [UIScreen mainScreen].bounds;
    NakedTracksMainView *backgroundView = [[NakedTracksMainView alloc] initWithFrame:frame];
    self.view = backgroundView;
    
}
*/

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
      // Call the init method implemented by the SuperClass
      self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
      //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mixer.png"]]];
    
    
      if(self)
      {
         [self initializeSongList];
         [self initializeAnswerList];
         
         Song *firstSong = [[Song alloc]init];
         firstSong = [self getNextSong];
         [self displaySong:firstSong];
          
         countOff = 3;
         [self countOffTimer];
         
      }
    
    return self;
}

- (void)initializeSongList
{
    Song *mySong = [[Song alloc]init];
    songList = [mySong getSongs];
    selectedSongs = [[NSMutableArray alloc]init];
}

- (void) initializeAnswerList
{
    Answer *myAnswer = [[Answer alloc]init];
    answerList = [myAnswer getAnswers];
    selectedAnswers = [[NSMutableArray alloc]init];
    
}


- (Song *)getNextSong
{
    NSInteger songPointer = arc4random() % [songList count];
    
    if([songList count] == [selectedSongs count])
    {
        exit(1);
    }

    
    while ([selectedSongs containsObject:[NSNumber numberWithInteger: songPointer]])
    {
        songPointer = arc4random() % [songList count];
    }

   
    [selectedSongs addObject:[NSNumber numberWithInteger: songPointer]];
    
    Song *currentSong = [[Song alloc]init];
    songCount++;
    currentSong = [songList objectAtIndex:songPointer];
    
    return currentSong;

}

- (NSString *)getRandomAnswer:(NSString*)featuredInstrumentIn
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
    NSString *answer1 = [inSong answer1];
    NSString *answer2 = [inSong answer2];
    NSString *answer3 = [inSong answer3];
    NSString *answer4 = [inSong answer4];
    NSString *answer5 = [inSong answer5];
    NSString *playButtonTitle;
    NSString *featuredInstrument = [inSong featuredInstrument];
    
    // Clear out the array of selected answers from the previous song
    [selectedAnswers removeAllObjects];
    
    fileName = [inSong fileLocation];
    correctAnswer = [inSong correctAnswer];
    trackLength = [inSong trackLength];
    origTrackLength = trackLength;
    
    int numOfAnswers = 5;
    int indexOfCorrectAnswer;
    
    
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
    
    if(indexOfCorrectAnswer == 1)
    {
        answer1 = correctAnswer;
    }
    else
    {
        answer1 = [self getRandomAnswer:featuredInstrument];
    }
    answerBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:answerBtn1];
    [answerBtn1 setTitle:answer1 forState:UIControlStateNormal];
    [answerBtn1 sizeToFit];
    [answerBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [answerBtn1 setBackgroundColor:[UIColor blackColor]];
    [answerBtn1 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [answerBtn1 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    //[[answerBtn1 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:15.0f]];
    //answerBtn1.tag = answer1;
    //Round Button Corners
    CALayer *btnLayer = [answerBtn1 layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [answerBtn1 setFrame:CGRectMake(15, 200, 300, 30)];
    answerBtn1.hidden = TRUE;
    //answerBtn1.transform = CGAffineTransformMakeRotation(90.0 * M_PI / 180.0);
    
    
    if(indexOfCorrectAnswer == 2)
    {
        answer2 = correctAnswer;
    }
    else
    {
        answer2 = [self getRandomAnswer:featuredInstrument];
    }
    answerBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:answerBtn2];
    [answerBtn2 setTitle:answer2 forState:UIControlStateNormal];
    [answerBtn2 sizeToFit];
    [answerBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [answerBtn2 setBackgroundColor:[UIColor blackColor]];
    [answerBtn2 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [answerBtn2 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    //[[answerBtn2 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:15.0f]];
    //Round Button Corners
    CALayer *btnLayer2 = [answerBtn2 layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:5.0f];
    [btnLayer2 setBorderWidth:1.0f];
    [btnLayer2 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [answerBtn2 setFrame:CGRectMake(15, 240, 300, 30)];
    answerBtn2.hidden = TRUE;
    
    
    if(indexOfCorrectAnswer == 3)
    {
        answer3 = correctAnswer;
    }
    else
    {
        answer3 = [self getRandomAnswer:featuredInstrument];
    }
    answerBtn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:answerBtn3];
    [answerBtn3 setTitle:answer3 forState:UIControlStateNormal];
    [answerBtn3 sizeToFit];
    [answerBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn3 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [answerBtn3 setBackgroundColor:[UIColor blackColor]];
    [answerBtn3 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [answerBtn3 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    //[[answerBtn3 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:15.0f]];
    //Round Button Corners
    CALayer *btnLayer3 = [answerBtn3 layer];
    [btnLayer3 setMasksToBounds:YES];
    [btnLayer3 setCornerRadius:5.0f];
    [btnLayer3 setBorderWidth:1.0f];
    [btnLayer3 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [answerBtn3 setFrame:CGRectMake(15, 280, 300, 30)];
    answerBtn3.hidden = TRUE;
    
    
    if(indexOfCorrectAnswer == 4)
    {
        answer4 = correctAnswer;
    }
    else
    {
        answer4 = [self getRandomAnswer:featuredInstrument];
    }
    answerBtn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:answerBtn4];
    [answerBtn4 setTitle:answer4 forState:UIControlStateNormal];
    [answerBtn4 sizeToFit];
    [answerBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn4 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [answerBtn4 setBackgroundColor:[UIColor blackColor]];
    [answerBtn4 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [answerBtn4 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    //[[answerBtn4 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:15.0f]];
    //Round Button Corners
    CALayer *btnLayer4 = [answerBtn4 layer];
    [btnLayer4 setMasksToBounds:YES];
    [btnLayer4 setCornerRadius:5.0f];
    [btnLayer4 setBorderWidth:1.0f];
    [btnLayer4 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [answerBtn4 setFrame:CGRectMake(15, 320, 300, 30)];
    answerBtn4.hidden = TRUE;
    
    
    if(indexOfCorrectAnswer == 5)
    {
        answer5 = correctAnswer;
    }
    else
    {
        answer5 = [self getRandomAnswer:featuredInstrument];
    }
    answerBtn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:answerBtn5];
    [answerBtn5 setTitle:answer5 forState:UIControlStateNormal];
    [answerBtn5 sizeToFit];
    [answerBtn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn5 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [answerBtn5 setBackgroundColor:[UIColor blackColor]];
    [answerBtn5 addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [answerBtn5 setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    //[[answerBtn5 titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:15.0f]];
    //Round Button Corners
    CALayer *btnLayer5 = [answerBtn5 layer];
    [btnLayer5 setMasksToBounds:YES];
    [btnLayer5 setCornerRadius:5.0f];
    [btnLayer5 setBorderWidth:1.0f];
    [btnLayer5 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [answerBtn5 setFrame:CGRectMake(15, 360, 300, 30)];
    answerBtn5.hidden = TRUE;
   

}

- (IBAction)showQuestion:(id)sender
{
    
    answerBtn1.hidden = FALSE;
    answerBtn2.hidden = FALSE;
    answerBtn3.hidden = FALSE;
    answerBtn4.hidden = FALSE;
    answerBtn5.hidden = FALSE;
    
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
    answerBtn1.hidden = FALSE;
    answerBtn2.hidden = FALSE;
    answerBtn3.hidden = FALSE;
    answerBtn4.hidden = FALSE;
    answerBtn5.hidden = FALSE;
    
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


- (IBAction)showAnswer:(id)sender
{
    // What is the answer to the current question
    NSString *answer = self.answers[self.currentQuestionIndex];
    
    // Display it in the answer label
    self.answerLabel.text = answer;
    
}

- (IBAction)checkAnswer:(id)sender
{
    [avSound stop];
    
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
       self.questionLabel.text = [NSString stringWithFormat:@"Your Time: 0:0%@", length];
    }
    else
    {
    self.questionLabel.text = [NSString stringWithFormat:@"Your Time: 0:%@", length];
    }
    
    if (![sender isKindOfClass:[UIButton class]])
        return;
    
    NSString *title = [(UIButton *)sender currentTitle];
    
    
    if (title == correctAnswer)
    {
        correctlyAnswered = 1;
        double tmpInterval = timeInterval;
        double tmp = (tmpInterval / origTrackLength) * 100;
        score += 100 - tmp;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score:%i", score];
        self.answerLabel.text = @"Correct!";
        [(UIButton *)sender setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1]];
        
    }
    else
    {
        correctlyAnswered = 0;
        self.answerLabel.text = @"Sorry, wrong answer";
        [(UIButton *)sender setBackgroundColor:[UIColor redColor]];
    }
    
    [self showAlert];
    

    playSong.enabled = NO;
    answerBtn1.enabled = NO;
    answerBtn2.enabled = NO;
    answerBtn3.enabled = NO;
    answerBtn4.enabled = NO;
    answerBtn5.enabled = NO;

    
    //Song *nextSong = [[Song alloc]init];
    //nextSong = [self getNextSong];
    //[self displaySong:nextSong];
    //countOff = 2;
    //[self countOffTimer];
}

- (void)queueNextSong
{
    Song *nextSong = [[Song alloc]init];
    nextSong = [self getNextSong];
    [self displaySong:nextSong];
    countOff = 2;
    [self startSong];
    //[self countOffTimer];
}


- (void)countdownTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    self.countdownLabel.text = @"Time Remaining: ";
    
}

- (void)updateCounter:(NSTimer *)theTimer
{
    self.countdownLabel.text = [NSString stringWithFormat:@"Time Remaining: 0:%02d", (int)trackLength];
    
    if(trackLength == 0)
    {
        if(timer)
        {
            [timer invalidate];
            timer = nil;
            self.answerLabel.text = @"Out of Time";
            Song *nextSong = [[Song alloc]init];
            nextSong = [self getNextSong];
            [self displaySong:nextSong];
            countOff = 2;
            [self countOffTimer];

        }
    }
    
    trackLength--;
    
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

@end
