//
//  GameReviewViewController.h
//  NakedTracks
//
//  Created by rockstar on 7/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import <UIKit/UIKit.h>

// Forwared Reference
@class GameReviewViewController;

@protocol GameReviewViewControllerDelegate <NSObject>

-(void)GameReviewViewControllerDidFinish:(GameReviewViewController *)Vc;

@end



@interface GameReviewViewController : UIViewController

- (IBAction)DismissView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Song1;

@property (weak, nonatomic) id<GameReviewViewControllerDelegate> delegate;
@property (nonatomic, retain)NSMutableArray *data;

@end


