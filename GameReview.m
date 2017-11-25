//
//  GameReview.m
//  NakedTracks
//
//  Created by rockstar on 8/3/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "GameReview.h"

@implementation GameReview

-(instancetype)init
{
    self = [super init];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.correctAnswer forKey:@"correctAnswer"];
    [aCoder encodeObject:self.answerStatus forKey:@"answerStatus"];
    [aCoder encodeObject:self.skillLevel forKey:@"skillLevel"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self)
    {
        self.correctAnswer = [aDecoder decodeObjectForKey:@"correctAnswer"];
        self.answerStatus = [aDecoder decodeObjectForKey:@"answerStatus"];
        self.skillLevel = [aDecoder decodeObjectForKey:@"skillLevel"];
        
    }
    
    return self;
}

-(NSString *)gameReviewInfoArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"gameReview.archive"];
}


-(BOOL)saveGameReviewInfo: (NSMutableArray*)currentGameReview
{
    NSString *path = [self gameReviewInfoArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:currentGameReview toFile:path];
}

-(NSMutableArray *)getSavedGameReviewInfo
{
    NSMutableArray *savedUserInfo;
    
    NSString *path = [self gameReviewInfoArchivePath];
    savedUserInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return savedUserInfo;
    
    
}



@end
