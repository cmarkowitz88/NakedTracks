//
//  NakedTracksMainView.m
//  NakedTracks
//
//  Created by rockstar on 2/15/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "NakedTracksMainView.h"
#import "NakedTracksViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "Song.h"

@interface NakedTracksMainView()

@property (nonatomic) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;


@end

@implementation NakedTracksMainView

AVAudioPlayer *avSound;
NSString *correctAnswer;
NSString *fileName;
NSDate *start;
int score;
int songCount;
double trackLength;
NSMutableArray *songList;
NSMutableArray *selectedSongs;

UIButton *playSong;
UIButton *answerBtn1;
UIButton *answerBtn2;
UIButton *answerBtn3;
UIButton *answerBtn4;
UIButton *answerBtn5;

@end
