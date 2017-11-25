//
//  GameScreenViewController.h
//  NakedTracks
//
//  Created by rockstar on 4/6/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameScreenViewController : UIViewController

@property (nonatomic) int propHasInternetConnection;
@property (nonatomic) int propGameReset;
@property (nonatomic) int propGameOver;


- (void)setUIConstraints;

@end
