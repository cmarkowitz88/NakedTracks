//
//  Song.m
//  NakedTracks
//
//  Created by rockstar on 1/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "Song.h"

@implementation Song

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

-(NSMutableArray *)getSongs:skillLevel
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"songlist" ofType:@"json"];
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

- (void)fetchSongs
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    NSString *requestString = @"http://ec2-52-23-158-122.compute-1.amazonaws.com/api/songs?level=1";
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Finished");
        NSLog(@"%@", jsonArray);
        NSMutableArray *songArray = [[NSMutableArray alloc]init];
        
        
        for(NSDictionary *dic in jsonArray)
        {
            //QuizViewController *quizVC = [[QuizViewController alloc]init];
            Song *songs = [[Song alloc]init];
            
            songs.songId = (int) [[dic valueForKey:@"Id"]intValue];
            songs.songTitle = (NSString *) [dic valueForKey:@"SongTitle"];
            songs.songDescription = (NSString *) [dic valueForKey:@"SongDescription"];
            songs.artist = (NSString *) [dic valueForKey:@"Artist"];
            songs.skillLevel = (NSString *) [dic valueForKey:@"SkillLevel"];
            songs.fileLocation = (NSString *) [dic valueForKey:@"FileLocation"];
            songs.hint = (NSString *) [dic valueForKey:@"hint"];
            songs.correctAnswer = (NSString *) [dic valueForKey:@"CorrectAnswer"];
            songs.category = (NSString *) [dic valueForKey:@"category"];
            songs.featuredInstrument = (NSString *) [dic valueForKey:@"featured_instrument"];
            songs.songSection = (NSString *) [dic valueForKey:@"song_section"];
            songs.trackLength = (double) [[dic valueForKey:@"TrackLength"]doubleValue];
            
            [songArray addObject:songs];
            
        }

        
    }
                                      
    ];
    
    [dataTask resume];
}

- (void)fetchSongsSynch
{
    NSString *requestString = @"http://ec2-52-23-158-122.compute-1.amazonaws.com/api/songs?level=1";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                          completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
     
     if (data.length > 0 && connectionError == nil)
     {
         NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         NSMutableArray *songArray = [[NSMutableArray alloc]init];
         
         
         for(NSDictionary *dic in jsonArray)
         {
             //QuizViewController *quizVC = [[QuizViewController alloc]init];
             Song *songs = [[Song alloc]init];
             
             songs.songId = (int) [[dic valueForKey:@"Id"]intValue];
             songs.songTitle = (NSString *) [dic valueForKey:@"SongTitle"];
             songs.songDescription = (NSString *) [dic valueForKey:@"SongDescription"];
             songs.artist = (NSString *) [dic valueForKey:@"Artist"];
             songs.skillLevel = (NSString *) [dic valueForKey:@"SkillLevel"];
             songs.fileLocation = (NSString *) [dic valueForKey:@"FileLocation"];
             songs.hint = (NSString *) [dic valueForKey:@"hint"];
             songs.correctAnswer = (NSString *) [dic valueForKey:@"CorrectAnswer"];
             songs.category = (NSString *) [dic valueForKey:@"category"];
             songs.featuredInstrument = (NSString *) [dic valueForKey:@"featured_instrument"];
             songs.songSection = (NSString *) [dic valueForKey:@"song_section"];
             songs.trackLength = (double) [[dic valueForKey:@"TrackLength"]doubleValue];
             
             [songArray addObject:songs];
             
         }

     }
     
  }];
}

- (void)FetchSongsASynch
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-52-23-158-122.compute-1.amazonaws.com/api/songs?level=1"]];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (data.length > 0 && error == nil)
    {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableArray *songArray = [[NSMutableArray alloc]init];
        
        
        for(NSDictionary *dic in jsonArray)
        {
            
            Song *songs = [[Song alloc]init];
            
            songs.songId = (int) [[dic valueForKey:@"Id"]intValue];
            songs.songTitle = (NSString *) [dic valueForKey:@"SongTitle"];
            songs.songDescription = (NSString *) [dic valueForKey:@"SongDescription"];
            songs.artist = (NSString *) [dic valueForKey:@"Artist"];
            songs.skillLevel = (NSString *) [dic valueForKey:@"SkillLevel"];
            songs.fileLocation = (NSString *) [dic valueForKey:@"FileLocation"];
            songs.hint = (NSString *) [dic valueForKey:@"hint"];
            songs.correctAnswer = (NSString *) [dic valueForKey:@"CorrectAnswer"];
            songs.category = (NSString *) [dic valueForKey:@"category"];
            songs.featuredInstrument = (NSString *) [dic valueForKey:@"featured_instrument"];
            songs.songSection = (NSString *) [dic valueForKey:@"song_section"];
            songs.trackLength = (double) [[dic valueForKey:@"TrackLength"]doubleValue];
            
            [songArray addObject:songs];
            
        }
        
    }

}

@end
