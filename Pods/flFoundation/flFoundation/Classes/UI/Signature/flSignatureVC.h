//
//  flSignatureVC.h
//  Dining
//
//  Created by Nattapon Nimakul on 10/1/55 BE.
//  Appsolute Soft Co., Ltd.
//  Copyright (c) 2555 nattapon@appsolutesoft.com. All rights reserved.

//

#import <UIKit/UIKit.h>
#import "flSignatureSignView.h"
#import "SignatureController.h"

@class flSignatureVC;

@protocol flSignatureVCDelegate <NSObject>

- (void)SignDidHitCancel:(flSignatureVC*)vc;
- (void)SignDitHitClear:(flSignatureVC*)vc;
- (void)SignDitHitConfirm:(flSignatureVC*)vc;

@end

@interface flSignatureVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *workSpaceView;
@property (weak, nonatomic) IBOutlet flSignatureSignView *signView;
@property (nonatomic, assign) id<flSignatureVCDelegate> delegate;
@property (nonatomic, strong) SignatureController *controller;

- (IBAction)hitCancel:(id)sender;
- (IBAction)hitConfirm:(id)sender;
- (IBAction)hitClear:(id)sender;

- (NSArray*)textSetOfPoints;
- (UIImage*)signatureInWhiteBackground;

@end
