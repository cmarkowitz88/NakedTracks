//
//  Config.m
//  NakedTracks
//
//  Created by rockstar on 9/10/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import "Config.h"

@implementation Config

-(NSString *)getKeyValue:(NSString *)keyName
{
    NSString *strKeyValue;
    NSMutableString *BaseUrl;
    NSString *strParams;
    
    //http://ec2-52-23-158-122.compute-1.amazonaws.com/api/config?inKey=websiteaddress
    BaseUrl = [NSMutableString stringWithString:@"http://ec2-52-23-158-122.compute-1.amazonaws.com/api/config?inKey="];
    
    strParams = [NSString stringWithFormat:@"%@",keyName];
    [BaseUrl appendString:strParams];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseUrl]];
    urlRequest.timeoutInterval = 10.0;
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (data.length > 0 && error == nil)
    {
        NSDictionary *configObj = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                    error:NULL];
        
        strKeyValue = [configObj objectForKey:@"KeyValue"];
        
    }


    
    return strKeyValue;
    
}

@end
