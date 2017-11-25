//
//  GameReview.h
//  NakedTracks
//
//  Created by rockstar on 8/3/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameReview : NSObject <NSCoding>

@property (nonatomic)NSString *correctAnswer;
@property (nonatomic)NSString *answerStatus;
@property (nonatomic)NSString *skillLevel;

-(void)encodeWithCoder:(NSCoder*)inCoder;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(NSString *)gameReviewInfoArchivePath;
-(BOOL)saveGameReviewInfo: (NSMutableArray *)currentGameReview;
-(NSMutableArray *)getSavedGameReviewInfo;



@end
