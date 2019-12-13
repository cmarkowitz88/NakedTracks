//
//  Answer.m
//  NakedTracks
//
//  Created by rockstar on 4/8/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "Answer.h"

@implementation Answer

-(NSMutableArray *)getAnswers
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"answerlist" ofType:@"json"];
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filepath options:NSDataReadingMappedIfSafe error:&error];
    if(JSONData == nil)
    {
        // Handle Error
    }
    
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (jsonArray == nil)
    {
        // Handle Error
    }
    
    NSMutableArray *answerArray = [[NSMutableArray alloc]init];
    
    
    for(NSDictionary *dic in jsonArray)
    {
        
        Answer *answer = [[Answer alloc]init];
        
        answer.answerId = (int) [[dic valueForKey:@"answer_id"]intValue];
        answer.skillLevel = (NSString *)[dic valueForKey:@"skill_level"];
        answer.answerName = (NSString *)[dic valueForKey:@"answer_name"];
        answer.Category = (NSString *)[dic valueForKey:@"answer_category"];
        answer.featuredInstrument = (NSString *)[dic valueForKey:@"featured_instrument"];
        answer.intFeaturedInstrument = (int) [[dic valueForKey:@"featured_instrument"]intValue];
        answer.songSection = (NSString *)[dic valueForKey:@"song_section"];
        answer.songSection = (NSString *)[dic valueForKey:@"date_created"];
        
        [answerArray addObject:answer];
        
    }
    
        return answerArray;
    
}

-(NSMutableArray *)FetchAnswersSync
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-54-173-1-47.compute-1.amazonaws.com/api/answers?level=1"]];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSMutableArray *answerArray = [[NSMutableArray alloc]init];
    urlRequest.timeoutInterval = 10.0;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (data.length > 0 && error == nil)
    {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        for(NSDictionary *dic in jsonArray)
        {
            if([dic valueForKey:@"Id"] != [NSNull null])
            {
                Answer *answer = [[Answer alloc]init];
                
                answer.answerId = (int) [[dic valueForKey:@"Id"]intValue];
                answer.skillLevel = (NSString *)[dic valueForKey:@"SkillLevel"];
                answer.answerName = (NSString *)[dic valueForKey:@"AnswerName"];
                answer.Category = (NSString *)[dic valueForKey:@"Category"];
                //answer.featuredInstrument = (NSString *)[dic valueForKey:@"FeaturedInstrument"];
                answer.intFeaturedInstrument = (int) [[dic valueForKey:@"FeaturedInstrument"]intValue];
                
                [answerArray addObject:answer];
                
                
            }
        }
        
    }
    
    return answerArray;

}


@end
