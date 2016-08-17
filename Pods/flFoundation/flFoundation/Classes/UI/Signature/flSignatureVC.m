//
//  flSignatureVC.m
//  Dining
//
//  Created by Nattapon Nimakul on 10/1/55 BE.
//  Appsolute Soft Co., Ltd.
//  Copyright (c) 2555 nattapon@appsolutesoft.com. All rights reserved.

//

#import "flSignatureVC.h"
#import <QuartzCore/QuartzCore.h>

@interface flSignatureVC () {
    CGPoint loc1;
}

@end

@implementation flSignatureVC


#pragma mark - Lazy Instantiation
- (SignatureController*)controller {
    if (!_controller) {
        _controller = [SignatureController new];
    }
    return _controller;
}

#pragma mark - Live Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Public Method
- (NSArray*)textSetOfPoints {
    return [self.controller flipY:self.signView.setOfPoints inRect:self.signView.frame option:@"TEXT"];
}

- (UIImage*)signatureInWhiteBackground {
    return [self.signView drawInWhiteBackground];
}

#pragma mark - Event Handling
- (IBAction)hitCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SignDidHitCancel:)]) {
        [self.delegate SignDidHitCancel:self];
    }
}

- (IBAction)hitConfirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SignDitHitConfirm:)]) {
        [self.delegate SignDitHitConfirm:self];
    }
}

- (IBAction)hitClear:(id)sender {
    [self.signView clearCurrentSign];
    [self.signView setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(SignDitHitClear:)]) {
        [self.delegate SignDitHitClear:self];
    }
}

@end
