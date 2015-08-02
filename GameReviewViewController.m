//
//  GameReviewViewController.m
//  NakedTracks
//
//  Created by rockstar on 7/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "GameReviewViewController.h"
#import "Song.h"

@interface GameReviewViewController ()

@end

@implementation GameReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    Song *tmpSong = [[Song alloc]init];
    tmpSong = [self.data objectAtIndex:0];
    NSString *SongName1 = [tmpSong correctAnswer];
    self.Song1.text = SongName1;
  
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)DismissView:(id)sender {
    
    
    //[self dismissViewControllerAnimated:YES completion:Nil];
    [self.delegate GameReviewViewControllerDidFinish:self];
}
@end
