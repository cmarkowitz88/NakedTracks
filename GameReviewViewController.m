//
//  GameReviewViewController.m
//  NakedTracks
//
//  Created by rockstar on 7/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "GameReviewViewController.h"
#import "Song.h"
#import "GameReview.h"
#import "NakedTracksViewController.h"
#import "GameScreenViewController.h"
#import "DeviceType.h"

@import UIKit;

@interface GameReviewViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *bkgdImageView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *lblLevelReview;
@property (nonatomic, weak) IBOutlet UILabel *lblStatusHeader;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswerHeader;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus1;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer1;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus2;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer2;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus3;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer3;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus4;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer4;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus5;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer5;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus6;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer6;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus7;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer7;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus8;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer8;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus9;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer9;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus10;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer10;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusPointsText;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusPointsNumber;
@property (nonatomic, weak) IBOutlet UILabel *SongHeader;
@property (nonatomic, weak) IBOutlet UILabel *Answer1;
@property (nonatomic, weak) IBOutlet UILabel *SongReview1;
@property (nonatomic, weak) IBOutlet UILabel *BonusPoints;
@property (nonatomic, weak) IBOutlet UILabel *BonusPoints2;
@property (nonatomic, weak) IBOutlet UILabel *RoundIndicator;

@end

UIButton *backButton;
NSInteger numOfCorrect;
NSInteger numIncorrect;
NSInteger x = 0;
NSInteger numBonusPoints;
NSInteger intTimerInterval;
NSInteger intFontSize1;
NSInteger intFontSize2;

const NSInteger BONUS_POINTS_MULTIPLIER = 100;

@implementation GameReviewViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setConstraints];
    
    [self DisplayGameReview];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

-(void)setConstraints
{
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];
    
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;
    
    
    
    self.lblLevelReview.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswerHeader.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatusHeader.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus1.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer1.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus2.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer2.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer3.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus3.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer4.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus4.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer5.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus5.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer6.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus6.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer7.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus7.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer8.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus8.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus9.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer9.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblStatus10.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblAnswer10.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblBonusPointsText.translatesAutoresizingMaskIntoConstraints=NO;
    self.lblBonusPointsNumber.translatesAutoresizingMaskIntoConstraints=NO;
    self.RoundIndicator.translatesAutoresizingMaskIntoConstraints=NO;
    
    
    self.lblAnswer1.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer1.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer1.numberOfLines=1;
    self.lblAnswer2.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer2.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer2.numberOfLines=1;
    self.lblAnswer3.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer3.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer3.numberOfLines=1;
    self.lblAnswer4.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer4.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer4.numberOfLines=1;
    self.lblAnswer5.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer5.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer5.numberOfLines=1;
    self.lblAnswer6.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer6.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer6.numberOfLines=1;
    self.lblAnswer7.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer7.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer7.numberOfLines=1;
    self.lblAnswer8.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer8.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer8.numberOfLines=1;
    self.lblAnswer9.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer9.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer9.numberOfLines=1;
    self.lblAnswer10.adjustsFontSizeToFitWidth = NO;
    self.lblAnswer10.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblAnswer10.numberOfLines=1;
    
    self.RoundIndicator.numberOfLines = 0;
    self.RoundIndicator.lineBreakMode = NSLineBreakByWordWrapping;
    self.RoundIndicator.adjustsFontSizeToFitWidth = NO;
    
    //Code to wrap the text
    //self.lblAnswer2.numberOfLines = 0;
    //self.lblAnswer2.lineBreakMode = NSLineBreakByWordWrapping;
    

    //if(screenWidth == 375 && screenHeight == 667)
    if ([currentDevice.deviceType isEqualToString:@"seven"])
    {
        self.bkgdImageView.image = [UIImage imageNamed:@"LevelReview_BG_Orange copy.png"];
        self.RoundIndicator.preferredMaxLayoutWidth = 336;
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.lblLevelReview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:120];
        [self.view addConstraint: constraint];
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.lblLevelReview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:40];
        [self.view addConstraint: constraint1];
        
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.lblStatusHeader attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.lblStatusHeader attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:90];
        [self.view addConstraint: constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.lblAnswerHeader attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint4];
        
        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.lblAnswerHeader attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:90];
        [self.view addConstraint: constraint5];
        
        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.lblStatus1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint6];
        
        NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.lblStatus1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:125];
        [self.view addConstraint: constraint7];
        
        NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint8];
        
        NSLayoutConstraint *constraint9 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:125];
        [self.view addConstraint: constraint9];
        
        NSLayoutConstraint *constraint10 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint10];
        
        NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:self.lblStatus2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint11];
        
        NSLayoutConstraint *constraint12 = [NSLayoutConstraint constraintWithItem:self.lblStatus2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:155];
        [self.view addConstraint: constraint12];
        
        NSLayoutConstraint *constraint13 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint13];
        
        NSLayoutConstraint *constraint14 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:155];
        [self.view addConstraint: constraint14];
        
        NSLayoutConstraint *constraint15 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint15];
        
        NSLayoutConstraint *constraint16 = [NSLayoutConstraint constraintWithItem:self.lblStatus3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint16];
        
        NSLayoutConstraint *constraint17 = [NSLayoutConstraint constraintWithItem:self.lblStatus3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:185];
        [self.view addConstraint: constraint17];
        
        NSLayoutConstraint *constraint18 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint18];
        
        NSLayoutConstraint *constraint19 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:185];
        [self.view addConstraint: constraint19];
        
        NSLayoutConstraint *constraint20 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint20];
        
        NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:self.lblStatus4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint21];
        
        NSLayoutConstraint *constraint22 = [NSLayoutConstraint constraintWithItem:self.lblStatus4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:215];
        [self.view addConstraint: constraint22];
        
        NSLayoutConstraint *constraint23 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint23];
        
        NSLayoutConstraint *constraint24 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:215];
        [self.view addConstraint: constraint24];
        
        NSLayoutConstraint *constraint25 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint25];
        
        NSLayoutConstraint *constraint26 = [NSLayoutConstraint constraintWithItem:self.lblStatus5 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint26];
        
        NSLayoutConstraint *constraint27 = [NSLayoutConstraint constraintWithItem:self.lblStatus5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:245];
        [self.view addConstraint: constraint27];
        
        NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint28];
        
        NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:245];
        [self.view addConstraint: constraint29];
        
        NSLayoutConstraint *constraint30 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint30];
        
        NSLayoutConstraint *constraint31 = [NSLayoutConstraint constraintWithItem:self.lblStatus6 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint31];
        
        NSLayoutConstraint *constraint32 = [NSLayoutConstraint constraintWithItem:self.lblStatus6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
        [self.view addConstraint: constraint32];

        NSLayoutConstraint *constraint33 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint33];
        
        NSLayoutConstraint *constraint34 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
        [self.view addConstraint: constraint34];
        
        NSLayoutConstraint *constraint35 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint35];
        
        NSLayoutConstraint *constraint36 = [NSLayoutConstraint constraintWithItem:self.lblStatus7 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint36];
        
        NSLayoutConstraint *constraint37 = [NSLayoutConstraint constraintWithItem:self.lblStatus7 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:310];
        [self.view addConstraint: constraint37];
        
        NSLayoutConstraint *constraint38 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint38];
        
        NSLayoutConstraint *constraint39 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:310];
        [self.view addConstraint: constraint39];
        
        NSLayoutConstraint *constraint40 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint40];
        
        NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:self.lblStatus8 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint41];
        
        NSLayoutConstraint *constraint42 = [NSLayoutConstraint constraintWithItem:self.lblStatus8 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:340];
        [self.view addConstraint: constraint42];
        
        NSLayoutConstraint *constraint43 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint43];
        
        NSLayoutConstraint *constraint44 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:340];
        [self.view addConstraint: constraint44];
        
        NSLayoutConstraint *constraint45 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint45];
        
        
        NSLayoutConstraint *constraint46 = [NSLayoutConstraint constraintWithItem:self.lblStatus9 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint46];
        
        NSLayoutConstraint *constraint47 = [NSLayoutConstraint constraintWithItem:self.lblStatus9 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:370];
        [self.view addConstraint: constraint47];
        
        NSLayoutConstraint *constraint48 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint48];
        
        NSLayoutConstraint *constraint49 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:370];
        [self.view addConstraint: constraint49];
        
        NSLayoutConstraint *constraint50 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint50];
        
        NSLayoutConstraint *constraint51 = [NSLayoutConstraint constraintWithItem:self.lblStatus10 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint51];
        
        NSLayoutConstraint *constraint52 = [NSLayoutConstraint constraintWithItem:self.lblStatus10 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
        [self.view addConstraint: constraint52];
        
        NSLayoutConstraint *constraint53 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
        [self.view addConstraint: constraint53];
        
        NSLayoutConstraint *constraint54 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
        [self.view addConstraint: constraint54];
        
        NSLayoutConstraint *constraint55 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
        [self.view addConstraint: constraint55];

        
        NSLayoutConstraint *constraint56 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:120];
        [self.view addConstraint: constraint56];
        
        NSLayoutConstraint *constraint57 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:449];
        [self.view addConstraint: constraint57];
        
        NSLayoutConstraint *constraint58 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:155];
        [self.view addConstraint: constraint58];
        
        NSLayoutConstraint *constraint59 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:475];
        [self.view addConstraint: constraint59];
        
        NSLayoutConstraint *constraint60 = [NSLayoutConstraint constraintWithItem:self.RoundIndicator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
        [self.view addConstraint: constraint60];
        
        NSLayoutConstraint *constraint61 = [NSLayoutConstraint constraintWithItem:self.RoundIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:530];
        [self.view addConstraint: constraint61];
    }
    else if ([currentDevice.deviceType isEqualToString:@"plus"])
    {
            self.bkgdImageView.image = [UIImage imageNamed:@"LevelReview_BG_Orange copy.png"];
        self.RoundIndicator.preferredMaxLayoutWidth = 350;

            
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.lblLevelReview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:140];
            [self.view addConstraint: constraint];
            
            NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.lblLevelReview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:47];
            [self.view addConstraint: constraint1];
            
            
            NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.lblStatusHeader attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint2];
            
            NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.lblStatusHeader attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:96];
            [self.view addConstraint: constraint3];
            
            NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.lblAnswerHeader attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint4];
            
            NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.lblAnswerHeader attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:96];
            [self.view addConstraint: constraint5];
            
            NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.lblStatus1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint6];
            
            NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.lblStatus1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:125];
            [self.view addConstraint: constraint7];
            
            NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint8];
            
            NSLayoutConstraint *constraint9 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:125];
            [self.view addConstraint: constraint9];
            
            NSLayoutConstraint *constraint10 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint10];
            
            NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:self.lblStatus2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint11];
            
            NSLayoutConstraint *constraint12 = [NSLayoutConstraint constraintWithItem:self.lblStatus2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:155];
            [self.view addConstraint: constraint12];
            
            NSLayoutConstraint *constraint13 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint13];
            
            NSLayoutConstraint *constraint14 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:155];
            [self.view addConstraint: constraint14];
            
            NSLayoutConstraint *constraint15 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint15];
            
            NSLayoutConstraint *constraint16 = [NSLayoutConstraint constraintWithItem:self.lblStatus3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint16];
            
            NSLayoutConstraint *constraint17 = [NSLayoutConstraint constraintWithItem:self.lblStatus3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:185];
            [self.view addConstraint: constraint17];
            
            NSLayoutConstraint *constraint18 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint18];
            
            NSLayoutConstraint *constraint19 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:185];
            [self.view addConstraint: constraint19];
            
            NSLayoutConstraint *constraint20 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint20];
            
            NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:self.lblStatus4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint21];
            
            NSLayoutConstraint *constraint22 = [NSLayoutConstraint constraintWithItem:self.lblStatus4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:215];
            [self.view addConstraint: constraint22];
            
            NSLayoutConstraint *constraint23 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint23];
            
            NSLayoutConstraint *constraint24 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:215];
            [self.view addConstraint: constraint24];
            
            NSLayoutConstraint *constraint25 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint25];
            
            NSLayoutConstraint *constraint26 = [NSLayoutConstraint constraintWithItem:self.lblStatus5 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint26];
            
            NSLayoutConstraint *constraint27 = [NSLayoutConstraint constraintWithItem:self.lblStatus5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:245];
            [self.view addConstraint: constraint27];
            
            NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint28];
            
            NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:245];
            [self.view addConstraint: constraint29];
            
            NSLayoutConstraint *constraint30 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint30];
            
            NSLayoutConstraint *constraint31 = [NSLayoutConstraint constraintWithItem:self.lblStatus6 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint31];
            
            NSLayoutConstraint *constraint32 = [NSLayoutConstraint constraintWithItem:self.lblStatus6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
            [self.view addConstraint: constraint32];
            
            NSLayoutConstraint *constraint33 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint33];
            
            NSLayoutConstraint *constraint34 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
            [self.view addConstraint: constraint34];
            
            NSLayoutConstraint *constraint35 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint35];
            
            NSLayoutConstraint *constraint36 = [NSLayoutConstraint constraintWithItem:self.lblStatus7 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint36];
            
            NSLayoutConstraint *constraint37 = [NSLayoutConstraint constraintWithItem:self.lblStatus7 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:310];
            [self.view addConstraint: constraint37];
            
            NSLayoutConstraint *constraint38 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint38];
            
            NSLayoutConstraint *constraint39 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:310];
            [self.view addConstraint: constraint39];
            
            NSLayoutConstraint *constraint40 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint40];
            
            NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:self.lblStatus8 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint41];
            
            NSLayoutConstraint *constraint42 = [NSLayoutConstraint constraintWithItem:self.lblStatus8 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:340];
            [self.view addConstraint: constraint42];
            
            NSLayoutConstraint *constraint43 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint43];
            
            NSLayoutConstraint *constraint44 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:340];
            [self.view addConstraint: constraint44];
            
            NSLayoutConstraint *constraint45 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint45];
            
            
            NSLayoutConstraint *constraint46 = [NSLayoutConstraint constraintWithItem:self.lblStatus9 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint46];
            
            NSLayoutConstraint *constraint47 = [NSLayoutConstraint constraintWithItem:self.lblStatus9 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:370];
            [self.view addConstraint: constraint47];
            
            NSLayoutConstraint *constraint48 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint48];
            
            NSLayoutConstraint *constraint49 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:370];
            [self.view addConstraint: constraint49];
            
            NSLayoutConstraint *constraint50 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint50];
            
            NSLayoutConstraint *constraint51 = [NSLayoutConstraint constraintWithItem:self.lblStatus10 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
            [self.view addConstraint: constraint51];
            
            NSLayoutConstraint *constraint52 = [NSLayoutConstraint constraintWithItem:self.lblStatus10 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
            [self.view addConstraint: constraint52];
            
            NSLayoutConstraint *constraint53 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:132];
            [self.view addConstraint: constraint53];
            
            NSLayoutConstraint *constraint54 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
            [self.view addConstraint: constraint54];
            
            NSLayoutConstraint *constraint55 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
            [self.view addConstraint: constraint55];
            
            
            NSLayoutConstraint *constraint56 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:148];
            [self.view addConstraint: constraint56];
            
            NSLayoutConstraint *constraint57 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:497];
            [self.view addConstraint: constraint57];
            
            NSLayoutConstraint *constraint58 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:175];
            [self.view addConstraint: constraint58];
            
            NSLayoutConstraint *constraint59 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:528];
            [self.view addConstraint: constraint59];
        
            NSLayoutConstraint *constraint60 = [NSLayoutConstraint constraintWithItem:self.RoundIndicator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:38];
            [self.view addConstraint: constraint60];
        
            NSLayoutConstraint *constraint61 = [NSLayoutConstraint constraintWithItem:self.RoundIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:586];
            [self.view addConstraint: constraint61];
        }
    
    else if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        self.bkgdImageView.image = [UIImage imageNamed:@"LevelReview_BG_Orange copy.png"];
        self.RoundIndicator.preferredMaxLayoutWidth = 279;
        
        intFontSize1 = 15;
        intFontSize2 = 14;
        
        [[self RoundIndicator] setFont:[UIFont systemFontOfSize:intFontSize1]];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.lblLevelReview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:93];
        [self.view addConstraint: constraint];
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.lblLevelReview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:34];
        [self.view addConstraint: constraint1];
        
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.lblStatusHeader attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.lblStatusHeader attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:75];
        [self.view addConstraint: constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.lblAnswerHeader attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint4];
        
        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.lblAnswerHeader attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:75];
        [self.view addConstraint: constraint5];
        
        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.lblStatus1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint6];
        
        NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.lblStatus1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:105];
        [self.view addConstraint: constraint7];
        
        NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint8];
        
        NSLayoutConstraint *constraint9 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:105];
        [self.view addConstraint: constraint9];
        
        NSLayoutConstraint *constraint10 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint10];
        
        NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:self.lblStatus2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint11];
        
        NSLayoutConstraint *constraint12 = [NSLayoutConstraint constraintWithItem:self.lblStatus2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:130];
        [self.view addConstraint: constraint12];
        
        NSLayoutConstraint *constraint13 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint13];
        
        NSLayoutConstraint *constraint14 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:130];
        [self.view addConstraint: constraint14];
        
        NSLayoutConstraint *constraint15 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint15];
        
        NSLayoutConstraint *constraint16 = [NSLayoutConstraint constraintWithItem:self.lblStatus3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint16];
        
        NSLayoutConstraint *constraint17 = [NSLayoutConstraint constraintWithItem:self.lblStatus3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:155];
        [self.view addConstraint: constraint17];
        
        NSLayoutConstraint *constraint18 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint18];
        
        NSLayoutConstraint *constraint19 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:155];
        [self.view addConstraint: constraint19];
        
        NSLayoutConstraint *constraint20 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint20];
        
        NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:self.lblStatus4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint21];
        
        NSLayoutConstraint *constraint22 = [NSLayoutConstraint constraintWithItem:self.lblStatus4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:180];
        [self.view addConstraint: constraint22];
        
        NSLayoutConstraint *constraint23 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint23];
        
        NSLayoutConstraint *constraint24 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:180];
        [self.view addConstraint: constraint24];
        
        NSLayoutConstraint *constraint25 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint25];
        
        NSLayoutConstraint *constraint26 = [NSLayoutConstraint constraintWithItem:self.lblStatus5 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint26];
        
        NSLayoutConstraint *constraint27 = [NSLayoutConstraint constraintWithItem:self.lblStatus5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:205];
        [self.view addConstraint: constraint27];
        
        NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint28];
        
        NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:205];
        [self.view addConstraint: constraint29];
        
        NSLayoutConstraint *constraint30 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint30];
        
        NSLayoutConstraint *constraint31 = [NSLayoutConstraint constraintWithItem:self.lblStatus6 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint31];
        
        NSLayoutConstraint *constraint32 = [NSLayoutConstraint constraintWithItem:self.lblStatus6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:230];
        [self.view addConstraint: constraint32];
        
        NSLayoutConstraint *constraint33 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint33];
        
        NSLayoutConstraint *constraint34 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:230];
        [self.view addConstraint: constraint34];
        
        NSLayoutConstraint *constraint35 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint35];
        
        NSLayoutConstraint *constraint36 = [NSLayoutConstraint constraintWithItem:self.lblStatus7 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint36];
        
        NSLayoutConstraint *constraint37 = [NSLayoutConstraint constraintWithItem:self.lblStatus7 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:255];
        [self.view addConstraint: constraint37];
        
        NSLayoutConstraint *constraint38 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint38];
        
        NSLayoutConstraint *constraint39 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:255];
        [self.view addConstraint: constraint39];
        
        NSLayoutConstraint *constraint40 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint40];
        
        NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:self.lblStatus8 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint41];
        
        NSLayoutConstraint *constraint42 = [NSLayoutConstraint constraintWithItem:self.lblStatus8 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
        [self.view addConstraint: constraint42];
        
        NSLayoutConstraint *constraint43 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint43];
        
        NSLayoutConstraint *constraint44 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
        [self.view addConstraint: constraint44];
        
        NSLayoutConstraint *constraint45 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint45];
        
        
        NSLayoutConstraint *constraint46 = [NSLayoutConstraint constraintWithItem:self.lblStatus9 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint46];
        
        NSLayoutConstraint *constraint47 = [NSLayoutConstraint constraintWithItem:self.lblStatus9 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:305];
        [self.view addConstraint: constraint47];
        
        NSLayoutConstraint *constraint48 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint48];
        
        NSLayoutConstraint *constraint49 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:305];
        [self.view addConstraint: constraint49];
        
        NSLayoutConstraint *constraint50 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint50];
        
        NSLayoutConstraint *constraint51 = [NSLayoutConstraint constraintWithItem:self.lblStatus10 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:20];
        [self.view addConstraint: constraint51];
        
        NSLayoutConstraint *constraint52 = [NSLayoutConstraint constraintWithItem:self.lblStatus10 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:330];
        [self.view addConstraint: constraint52];
        
        NSLayoutConstraint *constraint53 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:105];
        [self.view addConstraint: constraint53];
        
        NSLayoutConstraint *constraint54 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:330];
        [self.view addConstraint: constraint54];
        
        NSLayoutConstraint *constraint55 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200];
        [self.view addConstraint: constraint55];
        
        
        NSLayoutConstraint *constraint56 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:98];
        [self.view addConstraint: constraint56];
        
        NSLayoutConstraint *constraint57 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:381];
        [self.view addConstraint: constraint57];
        
        NSLayoutConstraint *constraint58 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:130];
        [self.view addConstraint: constraint58];
        
        NSLayoutConstraint *constraint59 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:405];
        [self.view addConstraint: constraint59];
        
        NSLayoutConstraint *constraint60 = [NSLayoutConstraint constraintWithItem:self.RoundIndicator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:32];
        [self.view addConstraint: constraint60];
        
        NSLayoutConstraint *constraint61 = [NSLayoutConstraint constraintWithItem:self.RoundIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:453];
        [self.view addConstraint: constraint61];
    }
    
    if ([currentDevice.deviceType isEqualToString:@"eleven,xr"])
       {
           self.bkgdImageView.image = [UIImage imageNamed:@"LevelReview_BG_Orange copy.png"];
           self.RoundIndicator.preferredMaxLayoutWidth = 336;
           
           NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.lblLevelReview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:120];
           [self.view addConstraint: constraint];
           
           NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.lblLevelReview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:40];
           [self.view addConstraint: constraint1];
           
           
           NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.lblStatusHeader attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint2];
           
           NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.lblStatusHeader attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:90];
           [self.view addConstraint: constraint3];
           
           NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.lblAnswerHeader attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint4];
           
           NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.lblAnswerHeader attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:90];
           [self.view addConstraint: constraint5];
           
           NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.lblStatus1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint6];
           
           NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.lblStatus1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:125];
           [self.view addConstraint: constraint7];
           
           NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint8];
           
           NSLayoutConstraint *constraint9 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:125];
           [self.view addConstraint: constraint9];
           
           NSLayoutConstraint *constraint10 = [NSLayoutConstraint constraintWithItem:self.lblAnswer1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint10];
           
           NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:self.lblStatus2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint11];
           
           NSLayoutConstraint *constraint12 = [NSLayoutConstraint constraintWithItem:self.lblStatus2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:155];
           [self.view addConstraint: constraint12];
           
           NSLayoutConstraint *constraint13 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint13];
           
           NSLayoutConstraint *constraint14 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:155];
           [self.view addConstraint: constraint14];
           
           NSLayoutConstraint *constraint15 = [NSLayoutConstraint constraintWithItem:self.lblAnswer2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint15];
           
           NSLayoutConstraint *constraint16 = [NSLayoutConstraint constraintWithItem:self.lblStatus3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint16];
           
           NSLayoutConstraint *constraint17 = [NSLayoutConstraint constraintWithItem:self.lblStatus3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:185];
           [self.view addConstraint: constraint17];
           
           NSLayoutConstraint *constraint18 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint18];
           
           NSLayoutConstraint *constraint19 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:185];
           [self.view addConstraint: constraint19];
           
           NSLayoutConstraint *constraint20 = [NSLayoutConstraint constraintWithItem:self.lblAnswer3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint20];
           
           NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:self.lblStatus4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint21];
           
           NSLayoutConstraint *constraint22 = [NSLayoutConstraint constraintWithItem:self.lblStatus4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:215];
           [self.view addConstraint: constraint22];
           
           NSLayoutConstraint *constraint23 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint23];
           
           NSLayoutConstraint *constraint24 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:215];
           [self.view addConstraint: constraint24];
           
           NSLayoutConstraint *constraint25 = [NSLayoutConstraint constraintWithItem:self.lblAnswer4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint25];
           
           NSLayoutConstraint *constraint26 = [NSLayoutConstraint constraintWithItem:self.lblStatus5 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint26];
           
           NSLayoutConstraint *constraint27 = [NSLayoutConstraint constraintWithItem:self.lblStatus5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:245];
           [self.view addConstraint: constraint27];
           
           NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint28];
           
           NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:245];
           [self.view addConstraint: constraint29];
           
           NSLayoutConstraint *constraint30 = [NSLayoutConstraint constraintWithItem:self.lblAnswer5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint30];
           
           NSLayoutConstraint *constraint31 = [NSLayoutConstraint constraintWithItem:self.lblStatus6 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint31];
           
           NSLayoutConstraint *constraint32 = [NSLayoutConstraint constraintWithItem:self.lblStatus6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
           [self.view addConstraint: constraint32];

           NSLayoutConstraint *constraint33 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint33];
           
           NSLayoutConstraint *constraint34 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:280];
           [self.view addConstraint: constraint34];
           
           NSLayoutConstraint *constraint35 = [NSLayoutConstraint constraintWithItem:self.lblAnswer6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint35];
           
           NSLayoutConstraint *constraint36 = [NSLayoutConstraint constraintWithItem:self.lblStatus7 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint36];
           
           NSLayoutConstraint *constraint37 = [NSLayoutConstraint constraintWithItem:self.lblStatus7 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:310];
           [self.view addConstraint: constraint37];
           
           NSLayoutConstraint *constraint38 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint38];
           
           NSLayoutConstraint *constraint39 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:310];
           [self.view addConstraint: constraint39];
           
           NSLayoutConstraint *constraint40 = [NSLayoutConstraint constraintWithItem:self.lblAnswer7 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint40];
           
           NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:self.lblStatus8 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint41];
           
           NSLayoutConstraint *constraint42 = [NSLayoutConstraint constraintWithItem:self.lblStatus8 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:340];
           [self.view addConstraint: constraint42];
           
           NSLayoutConstraint *constraint43 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint43];
           
           NSLayoutConstraint *constraint44 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:340];
           [self.view addConstraint: constraint44];
           
           NSLayoutConstraint *constraint45 = [NSLayoutConstraint constraintWithItem:self.lblAnswer8 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint45];
           
           
           NSLayoutConstraint *constraint46 = [NSLayoutConstraint constraintWithItem:self.lblStatus9 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint46];
           
           NSLayoutConstraint *constraint47 = [NSLayoutConstraint constraintWithItem:self.lblStatus9 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:370];
           [self.view addConstraint: constraint47];
           
           NSLayoutConstraint *constraint48 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint48];
           
           NSLayoutConstraint *constraint49 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:370];
           [self.view addConstraint: constraint49];
           
           NSLayoutConstraint *constraint50 = [NSLayoutConstraint constraintWithItem:self.lblAnswer9 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint50];
           
           NSLayoutConstraint *constraint51 = [NSLayoutConstraint constraintWithItem:self.lblStatus10 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint51];
           
           NSLayoutConstraint *constraint52 = [NSLayoutConstraint constraintWithItem:self.lblStatus10 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
           [self.view addConstraint: constraint52];
           
           NSLayoutConstraint *constraint53 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:125];
           [self.view addConstraint: constraint53];
           
           NSLayoutConstraint *constraint54 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:400];
           [self.view addConstraint: constraint54];
           
           NSLayoutConstraint *constraint55 = [NSLayoutConstraint constraintWithItem:self.lblAnswer10 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:240];
           [self.view addConstraint: constraint55];

           
           NSLayoutConstraint *constraint56 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:120];
           [self.view addConstraint: constraint56];
           
           NSLayoutConstraint *constraint57 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:449];
           [self.view addConstraint: constraint57];
           
           NSLayoutConstraint *constraint58 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:155];
           [self.view addConstraint: constraint58];
           
           NSLayoutConstraint *constraint59 = [NSLayoutConstraint constraintWithItem:self.lblBonusPointsNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:475];
           [self.view addConstraint: constraint59];
           
           NSLayoutConstraint *constraint60 = [NSLayoutConstraint constraintWithItem:self.RoundIndicator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:30];
           [self.view addConstraint: constraint60];
           
           NSLayoutConstraint *constraint61 = [NSLayoutConstraint constraintWithItem:self.RoundIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:530];
           [self.view addConstraint: constraint61];
       }


}

- (void)DisplayGameReview
{
    
    //NSMutableArray *labels;
    NSInteger x1 = 5;
    //NSInteger x2 = 105;
    NSInteger y1 = 60;
    //NSInteger y2 = 60;
    NSInteger x = 1;
    
    numOfCorrect = 0;
    numIncorrect = 0;
    NSString *CORRECT = @"Correct";
    NSInteger intRound = 0;
    NSString *RoundIndicatorMessage;
    
    // We already incremented the round on the GameScreen Controller. Need to decrement it for message diaplay.
    intRound = self.intRound - 1;
    
    //intRound = 10;
    
    // Hide the Bonus Points Label
    //self.lblBonusPointsText.hidden = YES;
    //self.lblBonusPointsNumber.hidden = YES;
    
    //UILabel *songHeaderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(x1,25,50,50)];
    //songHeaderStatusLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:15];
    //songHeaderStatusLabel.text = @"Status";
    //[self.view addSubview:songHeaderStatusLabel];
    
    //UILabel  *songHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, 25, 250, 50)];
    //songHeaderLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:15];
    //songHeaderLabel.text = @"Correct Answer";
    //[self.view addSubview:songHeaderLabel];
    
    for(GameReview* tmpGameReview in self.data)
    {
        
        [tmpGameReview.answerStatus isEqualToString:(CORRECT)] ? numOfCorrect++ : numIncorrect++;
        
        NSString *statusLabelName = @"lblStatus";
        NSString *answerLabelName = @"lblAnswer";
        
        statusLabelName = [statusLabelName stringByAppendingFormat:@"%ld", (long)x];
        UILabel *statusLabel = (UILabel*)[self valueForKey: statusLabelName];
        statusLabel.text = tmpGameReview.answerStatus;
        
        answerLabelName = [answerLabelName stringByAppendingFormat:@"%ld", (long)x];
        UILabel *answerLabel = (UILabel*)[self valueForKey: answerLabelName];
        answerLabel.text = [self removeNewLineCharacter:tmpGameReview.correctAnswer];
        
        //labels = [[NSMutableArray alloc]init];
        
        //UILabel  *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(x1, y1, 50, 50)];
        //statusLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:10];
        //statusLabel.text = tmpGameReview.answerStatus;
        //[self.view addSubview:statusLabel];
        //[labels addObject:statusLabel];
        
        //UILabel *songLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y2, 250, 50)];
        //songLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:10];
        //songLabel.text = [self removeNewLineCharacter:tmpGameReview.correctAnswer];
        //[self.view addSubview:songLabel];
        //[labels addObject:songLabel];
        
        //y1 = y1 + 25;
        //y2 = y2 + 25;
        x++;
        
    }
    
    UILabel  *BonusPoints = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    BonusPoints.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:15];
    BonusPoints.text = @" Bonus Points:";
    BonusPoints.textColor = [UIColor whiteColor];
    
    //self.BonusPoints2.center = CGPointMake(5,y2 + 50);
    
    CGRect myFrame = self.BonusPoints2.frame;
    myFrame.origin.x = x1;
    myFrame.origin.y = y1 + 20;
    self.BonusPoints2.frame = myFrame;
    
    
    //CGRect frame = CGRectMake(25,400,200,50);
    //UIView *popUp = [[UIView alloc]initWithFrame:frame];
    //popUp.backgroundColor = [UIColor redColor] ;
    //[self.view addSubview:popUp];
    //[popUp addSubview:BonusPoints];
    
    //numOfCorrect = 9;
    if(numOfCorrect >= 8)
    {
        //[self showBonusPoints:numCorrect theLabel:BonusPoints];
        //self.BonusPoints2.hidden = false;
        RoundIndicatorMessage = @"Great Job! You have successfully completed Round ";
        RoundIndicatorMessage = [RoundIndicatorMessage stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)intRound]];
        RoundIndicatorMessage = [RoundIndicatorMessage stringByAppendingString:@"."];
        self.lblBonusPointsNumber.hidden = false;
        self.lblBonusPointsText.hidden = false;
        self.RoundIndicator.text = RoundIndicatorMessage;
        self.RoundIndicator.textColor = [UIColor colorWithRed:(153/255.f) green:(202/255.f) blue:(60/255.f) alpha:1.0];
        [self countdownTimer];
        intTimerInterval = 7;
    }
    else
    {
        RoundIndicatorMessage = @"Sorry. You did not complete Round ";
        RoundIndicatorMessage = [RoundIndicatorMessage stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)intRound]];
        RoundIndicatorMessage = [RoundIndicatorMessage stringByAppendingString:@". You must get at least 8 songs correct. Please try again."];
        self.RoundIndicator.text = RoundIndicatorMessage;
        self.RoundIndicator.textColor = [UIColor colorWithRed:(229/255.f) green:(22/255.f) blue:(73/255.f) alpha:1.0];

        intTimerInterval = 7;
        [self clearViewTimer];
    }
    
    
    // Configure the Back Button
    backButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[self.view addSubview:backButton];
    [backButton setTitle:@"Continue" forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton setBackgroundColor:[UIColor grayColor]];
    [backButton addTarget:self action:@selector(DismissView:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(2,6,2,6)];
    [[backButton titleLabel] setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13.0f]];
    CALayer *btnLayerPause = [backButton layer];
    [btnLayerPause setMasksToBounds:YES];
    [btnLayerPause setCornerRadius:5.0f];
    [btnLayerPause setBorderWidth:1.0f];
    [btnLayerPause setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [backButton setFrame:CGRectMake(5, 350, 75, 20)];
    
    
    
}

- (void)countdownTimer
{
    //UILabel  *BonusPoints = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    //BonusPoints.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:15];
    //BonusPoints.text = @"Bonus Points:";
    //BonusPoints.textColor = [UIColor whiteColor];
    //CGRect frame = CGRectMake(25,400,200,50);
    //self.BonusPoints2.hidden = false;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(ExecuteTimer:) userInfo:nil repeats:YES];
    
    
}

- (void)ExecuteTimer:(NSTimer *)theTimer
{
    numBonusPoints = numOfCorrect * BONUS_POINTS_MULTIPLIER;
    
    x+=5;
    //((UILabel *)theTimer.userInfo).text = [NSString stringWithFormat:@"%d", x];
    //((UILabel *)theTimer.userInfo).text = @"In the loop";
    //[self showBonusPoints:numCorrect theLabel:BonusPoints];
    self.lblBonusPointsNumber.text = [NSString stringWithFormat:@"%ld", (long)x];
    
    if(x == numBonusPoints)
    {
        if(timer)
        {
            [timer invalidate];
            timer = nil;
            x = 0;
            
            // Code to automatically push off the current view
            //[self DismissView:self];
            [self clearViewTimer];
        }
    }
}



- (void)clearViewTimer
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:intTimerInterval target:self selector:@selector(ExecuteClearViewTimer:) userInfo:nil repeats:NO];
}

- (void)ExecuteClearViewTimer:(NSTimer *)theTimer2
{
    [self DismissView:self];
    if(timer)
    {
        [timer invalidate];
        timer = nil;
        x = 0;
        
        // Code to automatically push off the current view
        //[self DismissView:self];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)DismissView:(id)sender {
    
    
    //[self dismissViewControllerAnimated:YES completion:Nil];
    [self.delegate GameReviewViewControllerDidFinish:self];
}

-(void)showBonusPoints:(NSInteger *)NumCorrect theLabel:(UILabel *)inLabel;
{
    for (int x=0; x<100000;x++)
    {
        inLabel.text = [NSString stringWithFormat:@"%d", x];
    }
}

- (NSString *)removeNewLineCharacter:(NSString *)inTitle
{
    NSString *title = [inTitle stringByReplacingOccurrencesOfString:@"\n" withString:@" - "];
    return title;
}



//  CODE FOR USING TABLE VIEW



//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}
//
//
// - (NSInteger)numberofSectionsInTableView:(UITableView *)tableview
// {
// return 1;
// }
//
//
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}
//
//
// - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
// {
//   return 5;
// }
// 
// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
//     UILabel *labelSong = nil;
//     UILabel *labelStatus = nil;
//     
//     GameReview *tmpGameReview = [[GameReview alloc]init];
//     tmpGameReview = [self.data objectAtIndex:indexPath.row];
//     
//     NSString *SongName1 = [tmpGameReview correctAnswer];
//     NSString *SongStatus = [tmpGameReview answerStatus];
//     
//     labelSong = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0.0,250.0,15.0)];
//     labelSong.tag = 100;
//     labelSong.font = [UIFont systemFontOfSize:12];
//     //label1.text = [NSString stringWithFormat:@"Index row of cell is %d",indexPath.row];
//     labelSong.text = SongName1;
//     //labelSong.backgroundColor = [UIColor colorWithRed:0.18 green:0.40 blue:0.09 alpha:1.0];
//     
//     labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(0,20,250.0,15.0)];
//     labelStatus.tag = 50;
//     labelStatus.font = [UIFont systemFontOfSize:12];
//     labelStatus.text = SongStatus;
//     //labelStatus.backgroundColor = [UIColor colorWithRed:0.18 green:0.40 blue:0.09 alpha:1.0];
//     
//     
//     tableView.allowsSelection = NO;
// 
//     if(cell == nil)
//     {
//         cell = [[UITableViewCell alloc ]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MainCell"];
//         
//         [cell.contentView addSubview:labelSong];
//         [cell.contentView addSubview:labelStatus];
// 
//     }
// 
//     else
//     {
//        labelSong = [cell.contentView viewWithTag:100];
//        labelStatus = [cell.contentView viewWithTag:50];
//        
//     }
//     
//     
//     
//     cell.selectionStyle = UITableViewCellSelectionStyleNone;
//     //cell.textLabel.text = [NSString stringWithFormat:@"Index row of cell is %d",indexPath.row];
//     //cell.textLabel.text = [NSString stringWithFormat:@"Index row of cell is %d",indexPath.row];
//
// 
// return cell;
//     
// }

@end



