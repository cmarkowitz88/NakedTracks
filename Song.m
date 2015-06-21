//
//  Song.m
//  NakedTracks
//
//  Created by rockstar on 1/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "Song.h"

@implementation Song

-(NSMutableArray *)getSongs
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"songlist" ofType:@"json"];
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filepath options:NSDataReadingMappedIfSafe error:&error];
    if(JSONData == nil)
    {
        // Handle Error
    }
    
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    NSDictionary *songDict = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (jsonArray == nil)
    {
        // Handle Error
    }
    
    NSMutableArray *songArray = [[NSMutableArray alloc]init];
    
    
    for(NSDictionary *dic in jsonArray)
    {
        //QuizViewController *quizVC = [[QuizViewController alloc]init];
        Song *songs = [[Song alloc]init];
        
        songs.songId = (int) [[dic valueForKey:@"song_id"]intValue];
        songs.songTitle = (NSString *) [dic valueForKey:@"song_title"];
        songs.songDescription = (NSString *) [dic valueForKey:@"song_description"];
        songs.artist = (NSString *) [dic valueForKey:@"artist"];
        songs.skillLevel = (NSString *) [dic valueForKey:@"skill_level"];
        songs.fileLocation = (NSString *) [dic valueForKey:@"file_location"];
        songs.imageLocation = (NSString *) [dic valueForKey:@"image_location"];
        songs.hint = (NSString *) [dic valueForKey:@"hint"];
        songs.answer1 = (NSString *) [dic valueForKey:@"answer_1"];
        songs.answer2 = (NSString *) [dic valueForKey:@"answer_2"];
        songs.answer3 = (NSString *) [dic valueForKey:@"answer_3"];
        songs.answer4 = (NSString *) [dic valueForKey:@"answer_4"];
        songs.answer5 = (NSString *) [dic valueForKey:@"answer_5"];
        songs.correctAnswer = (NSString *) [dic valueForKey:@"correct_answer"];
        songs.category = (NSString *) [dic valueForKey:@"category"];
        songs.featuredInstrument = (NSString *) [dic valueForKey:@"featured_instrument"];
        songs.songSection = (NSString *) [dic valueForKey:@"song_section"];
        songs.createDate = (NSDate *) [dic valueForKey:@"date_created"];
        songs.trackLength = (double) [[dic valueForKey:@"track_length"]doubleValue];
        
        [songArray addObject:songs];
        
    }
    
    
    //id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    //NSLog(@"%@", songDict);
    
    return songArray;
    
}

@end
