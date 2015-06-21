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

- (void)displaySong:(Song*)inSong;
- (void)updateCounter:(NSTimer *)theTimer;
- (void)countdownTimer;

@end
