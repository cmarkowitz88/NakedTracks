//
//  NakedTracksViewController.h
//  NakedTracks
//
//  Created by rockstar on 1/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "song.h"




@interface NakedTracksViewController : UIViewController
{
   
    
    NSTimer *timer;
     
}

 @property (nonatomic) int propHasInternetConnection;
 @property (nonatomic) int propGameReset;
 @property (nonatomic) int propGameOver;

- (IBAction)ShowHint:(id)sender;
- (void)displaySong:(Song*)inSong;
- (void)updateCounter:(NSTimer *)theTimer;
- (void)countdownTimer;

@end
