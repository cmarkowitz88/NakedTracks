//
//  AboutViewController.h
//  NakedTracks
//
//  Created by rockstar on 4/10/16.
//  Copyright © 2016 NakedTracks Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *AboutWebView;

- (NSString *)readInAboutText;

@end


