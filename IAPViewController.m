//
//  IAPViewController.m
//  NakedTracks
//
//  Created by rockstar on 6/24/17.
//  Copyright © 2017 NakedTracks Software. All rights reserved.
//

#import "IAPViewController.h"
#import "DeviceType.h"
#import "MainMenuViewController.h"
#import "Constants.h"

@interface IAPViewController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property SKProductsRequest *request;
@property NSArray *products;
@property (nonatomic,weak) IBOutlet UILabel *iapProductName;
@property (nonatomic,weak) IBOutlet UIButton *buyButton;
@property (nonatomic,weak) IBOutlet UIButton *cancelButton;
@property (nonatomic,weak) IBOutlet UIButton *restoreButton;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UIImageView *logoImage;
@property (nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,weak) IBOutlet UIImageView *bkgdImage;
@property (nonatomic,weak) IBOutlet UILabel *headerLabel;


@end

@implementation IAPViewController

NSMutableArray *productIdentifiers;
SKProductsRequest *request;
int hasProducts = 0;
NSString *strProductId;
SKProduct *validProduct;
bool blnPurchasedProduct;
NSString *strIAPProductDescription;
NSString *strCaller;
bool blnShowFullScreen;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        //[self getProducts];
    
        //[self validateProductIdentifiers:productIdentifiers];
    
        //[[SKPaymentQueue defaultQueue] addTransactionObserver: self];
    }
    
    // RESET In App Purchase Flag to False
    //blnPurchasedProduct = NO;
    
    //[[NSUserDefaults standardUserDefaults] setBool:blnPurchasedProduct forKey:@"purchaseFullVersion"];
    
    //use NSUserDefaults so that you can load whether or not they bought it
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return self;
}

- (void)viewDidLoad
{
        
    strCaller = self.strCaller;
    
    [self getProducts];
    
    [self validateProductIdentifiers:productIdentifiers];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver: self];
    
    [self getIAPProductDescription];
    
    [self setContraints];

}

- (void)getIAPProductDescription
{
    // This is the text description label that is used on the In App Purchase Screen. This is not stored in the iTunes Connect Store
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"IAPDescription" withExtension:@"plist"];
    NSDictionary *tmp = [[NSDictionary alloc ] initWithContentsOfURL:url];
    strIAPProductDescription = tmp[@"IAPDescriptionText"];
}

- (void)setContraints
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    DeviceType *currentDevice = [[DeviceType alloc]init];
    [currentDevice getDeviceType];
    
    // If strCaller is not set and is nil it's being called from the main play screen and we want to show the game play theme
    if (!strCaller)
    {
        self.logoImage.image = [UIImage imageNamed:@"LogoLaunchSmall.png"];
        self.bkgdImage.image = [UIImage imageNamed:@"About_BG_copy.png"];
        self.cancelButton.hidden = TRUE;
        blnShowFullScreen = FALSE;
    }
    else
    {
        self.logoImage.image = [UIImage imageNamed:@"LogoLaunch.png"];
        blnShowFullScreen = TRUE;
    }
    
    self.logoImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.iapProductName.translatesAutoresizingMaskIntoConstraints = NO;
    self.priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.buyButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.bkgdImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.restoreButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.adjustsFontSizeToFitWidth = NO;
    
    self.iapProductName.numberOfLines = 0;
    self.iapProductName.lineBreakMode = NSLineBreakByWordWrapping;
    self.iapProductName.adjustsFontSizeToFitWidth = NO;
    
    self.buyButton.layer.borderWidth = 2.0f;
    self.buyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.cancelButton.layer.borderWidth = 2.0f;
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.restoreButton.layer.borderWidth = 2.0f;
    self.restoreButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    // Get the description text from the Property List
    self.descriptionLabel.text = strIAPProductDescription;
    
    if([currentDevice.deviceType isEqualToString:@"seven"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:375.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:677.0]];
        
        if (blnShowFullScreen)
        {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:60.0]];
    
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:30.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:75.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:590.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:220.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
            
            self.headerLabel.hidden = true;
        }
        else
        {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:90.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:40.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:75.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:520.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:220.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
            
        }
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:220.0]];
        
         [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:340.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:280.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:310.0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:345.0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:75.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:450.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:220.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:75.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:520.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:220.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
        
        
    }
    
    else if([currentDevice.deviceType isEqualToString:@"plus"])
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:414.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:736.0]];
        
        if (blnShowFullScreen)
        {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:80.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:35.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:93.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:605.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:220.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45.0]];
            
            self.headerLabel.hidden = true;
        }
        else
        {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:46.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:93.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:530.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:220.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45.0]];
            
        }

        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:235.0]];
        
          [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:380.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:265.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:315.0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:380.0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:93.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:465.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:220.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:93.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:535.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:220.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45.0]];
    }
    
    else if([currentDevice.deviceType isEqualToString:@"6,7,zoom"])
    {
        self.logoImage.image = [UIImage imageNamed:@"LogoLaunchSmaller.png"];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:screenWidth]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bkgdImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:screenHeight]];
        
    if (blnShowFullScreen) // Selected Purchase Full Version from the Welcome Screen
        {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:30.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:60.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:510.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:130.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:160.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:210.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:300.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:60.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:360.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:60.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:435.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
            
            self.headerLabel.hidden = true;
        }
        else // Selected Purchase Full Version from Game Play screen
        {
            NSInteger infFontSize1 = 16;
            
            [[self iapProductName] setFont:[UIFont systemFontOfSize:infFontSize1]];

            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:100.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:75.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:90.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:34.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iapProductName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:160.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:190.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:225.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:300.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:60.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:380.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buyButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:60.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:440.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.restoreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
            
            //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:60.0]];
            
           //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:435.0]];
            
            //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0]];
            
            //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
        }

        
    }

}

- (void)getProducts
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Products" withExtension:@"plist"];
    productIdentifiers = [NSMutableArray arrayWithContentsOfURL:url];
}

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    
    // Keep a strong reference to the request.
    self.request = productsRequest;
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    
    if(self.products.count > 0)
    {
        hasProducts = 1;
    }
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
    }
    
    [self displayStoreUI]; // Custom method
}

- (void) displayStoreUI
{
    if(hasProducts)
    {
        for(SKProduct *product in self.products)
            
        {
            validProduct = product;
            //NSString *strId = product.productIdentifier;
            NSString *strTitle = product.localizedTitle;
            strProductId = product.productIdentifier;
        
            
            float Price = product.price.floatValue;
            
            self.iapProductName.text = strTitle;
            //self.iapProductName.text = [strTitle stringByAppendingString:@" Full Version"];
            self.priceLabel.text = [NSString  stringWithFormat:@"$%.2f", Price ];
        }
    }
}


-(IBAction) purchaseProduct:(id)sender
{
    NSLog(@"Let's purchase this thing");
    
    if([ SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:strProductId]];
        productsRequest.delegate = self;
        [self purchase:validProduct];
    }
    else
    {
        NSLog(@"User cannot purchase");
    }
}

-(IBAction)restore:(id)sender
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            //if you have more than one in-app purchase product,
            //you restore the correct product for the identifier.
            //For example, you could use
            //if(productID == kRemoveAdsProductIdentifier)
            //to get the product identifier for the
            //restored purchases, you can use
            //
            //NSString *productID = transaction.payment.productIdentifier;
            //[self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }   
}

-(IBAction)cancel:(id)sender
{
    if([strCaller isEqualToString:@"AlertController"])
    {
        // Set variable to flag that the user came from the Alert and need to purchase the product
        blnTryingToCheat = true;
    }
    
    MainMenuViewController *mainMenuVC = [[MainMenuViewController alloc]init];
    [self presentViewController:mainMenuVC animated:YES completion:nil];

}

- (void)purchase:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *transaction in transactions)
    {
        //if you have multiple in app purchases in your app,
        //you can get the product identifier of this transaction
        //by using transaction.payment.productIdentifier
        //
        //then, check the identifier against the product IDs
        //that you have defined to check which product the user
        //just purchased
        
        switch(transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
                
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self purchasedFullVersion]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
                
            case SKPaymentTransactionStateDeferred:
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [self purchasedFullVersion];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment
                    
        } // End Switch
                
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        break;
        }
    }
}

- (void)purchasedFullVersion
{
    blnPurchasedProduct = YES;
    
    [[NSUserDefaults standardUserDefaults] setBool:blnPurchasedProduct forKey:@"purchaseFullVersion"];
    
    //use NSUserDefaults so that you can load whether or not they bought it
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
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
