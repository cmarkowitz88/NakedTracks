//
//  Song.h
//  NakedTracks
//
//  Created by rockstar on 1/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface Song : NSObject<NSURLConnectionDelegate, NSCoding>

{
    NSMutableData *_responseData;

}


@property (nonatomic)int songId;
@property (nonatomic)NSString *songTitle;
@property (nonatomic)NSString *songDescription;
@property (nonatomic)NSString *artist;
@property (nonatomic)NSString *skillLevel;
@property (nonatomic)NSString *fileLocation;
@property (nonatomic)NSString *imageLocation;
@property (nonatomic)NSString *hint;
@property (nonatomic)NSString *answer1;
@property (nonatomic)NSString *answer2;
@property (nonatomic)NSString *answer3;
@property (nonatomic)NSString *answer4;
@property (nonatomic)NSString *answer5;
@property (nonatomic)NSString *correctAnswer;
@property (nonatomic)NSString *category;
@property (nonatomic)int intCategory;
@property (nonatomic)NSString *featuredInstrument;
@property (nonatomic)int intFeaturedInstrument;
@property (nonatomic)NSString *songSection;
@property (nonatomic)NSDate   *createDate;
@property (nonatomic)double trackLength;

@property (nonatomic, strong) NSURLSession *session;




- (NSMutableArray *)getSongs: (NSString *) SkillLevel;
- (void)fetchSongs;
- (void)fetchSongsASynch;
- (NSMutableArray *)fetchSongsSynch: (int) intSkillLevel arg2:(bool) blnFullVersion;


@end
