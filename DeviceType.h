//
//  DeviceType.h
//  NakedTracks
//
//  Created by rockstar on 4/23/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface DeviceType : NSObject

@property (nonatomic, weak) NSString *deviceType;
@property  NSInteger screenWidth;
@property  NSInteger  screenHeight;

- (void)getDeviceType;
- (void)buildTabBar:(NSInteger)Params;
- (bool)getIapPurchaseValue;
- (void)gameReset;
- (NSString *)FormatScore:(NSInteger)inScore;


@end
