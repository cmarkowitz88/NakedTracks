//
//  Config.h
//  NakedTracks
//
//  Created by rockstar on 9/10/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

@property NSString *keyName;
@property NSString *keyValue;

-(NSString *) getKeyValue: (NSString *) keyName;

@end
