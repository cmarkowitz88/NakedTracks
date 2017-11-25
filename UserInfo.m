//
//  UserInfo.m
//  NakedTracks
//
//  Created by rockstar on 10/10/16.
//  Copyright © 2016 NakedTracks Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@implementation UserInfo

-(instancetype)initUserProfile
{
    //[self getUserInfo];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.dblScore forKey:@"dblScore"];
    [aCoder encodeInteger:self.intRound forKey:@"intRound"];
    [aCoder encodeInteger:self.intSkillLevel forKey:@"intSkillLevel"];
    [aCoder encodeInteger:self.intGlobalSongPointer forKey:@"intGlobalSongPointer"];
    [aCoder encodeInteger:self.intCurrentSongIndex forKey:@"intCurrentSongIndex"];
    [aCoder encodeInteger:self.intNumCorrect forKey:@"intNumCorrect"];
    [aCoder encodeInteger:self.intStreak forKey:@"intStreak"];
}

-(NSString *)userInfoArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"userInfo.archive"];
}

-(BOOL)saveUserInfo
{
    NSString *path = [self userInfoArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self toFile:path];
}

-(UserInfo *)getUserInfo
{
    UserInfo *info = [[UserInfo alloc]init];
    
    
    NSString *path = [self userInfoArchivePath];
    info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return info;
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self)
    {
        self.dblScore = [aDecoder decodeDoubleForKey:@"dblScore"];
        self.intRound = [aDecoder decodeIntForKey:@"intRound"];
        self.intSkillLevel = [aDecoder decodeIntForKey:@"intSkillLevel"];
        self.intGlobalSongPointer = [aDecoder decodeIntForKey:@"intGlobalSongPointer"];
        self.intCurrentSongIndex = [aDecoder decodeIntForKey:@"intCurrentSongIndex"];
        self.intNumCorrect = [aDecoder decodeIntForKey:@"intNumCorrect"];
        self.intStreak = [aDecoder decodeIntForKey:@"intStreak"];
    }
    
    return self;
}


@end
