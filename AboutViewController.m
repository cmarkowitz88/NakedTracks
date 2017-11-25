//
//  AboutViewController.m
//  NakedTracks
//
//  Created by rockstar on 4/10/16.
//  Copyright © 2016 NakedTracks Software. All rights reserved.
//

#import "AboutViewController.h"
#import "DeviceType.h"

@interface AboutViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imgViewBkgd;
@property (nonatomic, weak) IBOutlet UITextView *textViewAbout;
@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;

@end

@implementation AboutViewController

@synthesize AboutWebView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString * strAboutText;
    
    [self setConstraints];
    
    self.imgViewBkgd.image = [UIImage imageNamed:@"About_BG_copy.png"];
    
    self.textViewAbout.backgroundColor = [UIColor clearColor];
    self.textViewAbout.textColor = [UIColor whiteColor];
    
    self.aboutLabel.textColor = [UIColor colorWithRed:0.00 green:0.70 blue:0.85 alpha:1.0];
    strAboutText = self.readInAboutText;
    self.textViewAbout.text = strAboutText;

    
    /*  Original Code to use HTML Viewer
    //NSString *aboutPath = [[NSBundle mainBundle] pathForResource:@"NakedTracksAbout" ofType:@"html"];
    NSString *aboutPath = [[NSBundle mainBundle] pathForResource:@"NakedTracksAbout" ofType:@"html"];

    NSURL  *fileUrl = [NSURL fileURLWithPath:aboutPath isDirectory:NO];
    NSURLRequest *myRequest = [[NSURLRequest alloc ]initWithURL:fileUrl];
    
    [AboutWebView loadRequest:myRequest];*/
    
}

- (void)setConstraints
{
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];
    
    self.aboutLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.textViewAbout.translatesAutoresizingMaskIntoConstraints=NO;
    
    if ([currentDevice.deviceType isEqualToString:@"seven"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.aboutLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:93.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.aboutLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:45.0]];
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"plus"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.aboutLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:110.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.aboutLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textViewAbout attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textViewAbout attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:90.0]];
        
        NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.textViewAbout attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-35];
        [self.view addConstraint: constraint28];
        
        NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.textViewAbout attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:618];
        [self.view addConstraint: constraint29];
    }
    
    else if ([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.aboutLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:70.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.aboutLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:35.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textViewAbout attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textViewAbout attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:72.0]];
        
        NSLayoutConstraint *constraint28 = [NSLayoutConstraint constraintWithItem:self.textViewAbout attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-25];
        [self.view addConstraint: constraint28];
        
        NSLayoutConstraint *constraint29 = [NSLayoutConstraint constraintWithItem:self.textViewAbout attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:490];
        [self.view addConstraint: constraint29];
        
    }

}

- (NSString *)readInAboutText
{
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"NakedTracksText" ofType:@"json"];
    NSError *error = nil;
    NSString *strAboutText;
    
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
    
   
    
    
    for(NSDictionary *dic in jsonArray)
    {
        strAboutText = (NSString *) [dic valueForKey:@"about_text"];
    }
    
    
    
    return strAboutText;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UITabBarItem *)tabBarItem
{
    return [[UITabBarItem alloc] initWithTitle:@"About" image:[UIImage imageNamed:@"Navigation_NTIcon copy.png"] tag:0];
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
