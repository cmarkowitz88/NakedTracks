//
//  UserInfo.h
//  NakedTracks
//
//  Created by rockstar on 10/10/16.
//  Copyright © 2016 NakedTracks Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfo : NSObject<NSCoding>

@property (nonatomic)double dblScore;
@property (nonatomic)int intSkillLevel;
@property (nonatomic)int intRound;
@property (nonatomic)int intGlobalSongPointer;
@property (nonatomic)int intCurrentSongIndex;
@property (nonatomic)int intNumCorrect;
@property (nonatomic)int intStreak;

-(instancetype)initUserProfile;
-(BOOL)saveUserInfo;
-(UserInfo *)getUserInfo;

@end
