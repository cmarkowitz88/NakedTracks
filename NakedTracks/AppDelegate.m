//
//  AppDelegate.m
//  NakedTracks
//
//  Created by rockstar on 1/31/15.
//  Copyright (c) 2015 NakedTracks Software. All rights reserved.
//

#import "AppDelegate.h"
#import "NakedTracksViewController.h"
#import "NakedTracksMainView.h"
#import <AWSCORE/awscore.h>
#import <AWSS3/AWSS3.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

AVAudioPlayer *avSound;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc]init];
    self.window.rootViewController = nakedVC;
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]initWithRegionType:AWSRegionUSEast1 identityPoolId:@"us-east-1:896a2892-7e49-4a1f-b8d8-254b57b457bd"];
    
    AWSServiceConfiguration *configuration  = [[AWSServiceConfiguration alloc]initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Allright_Now_Gtr_Chorus.wav"];
    NSURL *downloadingFileUrl = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    downloadRequest.bucket = @"nakedtracks.audio";
    downloadRequest.key = @"Allright_Now_Gtr_Chorus.wav";
    downloadRequest.downloadingFileURL = downloadingFileUrl;
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    NSLog(@"Download started, please wait...");
    
    [[transferManager download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                           withBlock:^id(BFTask *task){
                                                               if (task.error != nil) {
                                                                   NSLog(@"%s %@","Error downloading :", downloadRequest.key);
                                                               }
                                                               else {
                                                                   NSLog(@"download completed");
                                                                   
                                                               }
                                                               return nil;
                                                           }];
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //NSString *folderAndFile = downloadRequest.downloadingFileURL;
    //NSString *audioFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingString:folderAndFile];
    
    
    //NSURL *soundUrl = [[NSBundle mainBundle]URLForResource:downloadingFilePath withExtension:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:downloadingFilePath ];
    avSound = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    [avSound prepareToPlay];
    [avSound play];
    
    
    
    
    //CGRect firstFrame = self.window.bounds;
    //NakedTracksViewController *nakedVC = [[NakedTracksViewController alloc] initWithFrame:firstFrame];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
