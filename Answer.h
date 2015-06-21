//
//  Answer.h
//  NakedTracks
//
//  Created by rockstar on 4/8/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Answer : NSObject

@property (nonatomic)int answerId;
@property (nonatomic)NSString *skillLevel;
@property (nonatomic)NSString *answerName;
@property (nonatomic)NSString *Category;
@property (nonatomic)NSString *featuredInstrument;
@property (nonatomic)NSString *songSection;

- (NSMutableArray *)getAnswers;

@end
