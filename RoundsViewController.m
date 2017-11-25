//
//  RoundsViewController.m
//  NakedTracks
//
//  Created by rockstar on 3/20/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import "RoundsViewController.h"

@interface RoundsViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imgViewLevel;
@property (nonatomic, weak) IBOutlet UIButton *btnLevel;


@end

@implementation RoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imgViewLevel.image = [UIImage imageNamed:@"Level1.jpg"];
    self.btnLevel.layer.borderWidth = 2.0f;
    self.btnLevel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
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

@end
