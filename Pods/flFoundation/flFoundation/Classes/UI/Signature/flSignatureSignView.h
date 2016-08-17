//
//  flSignatureSignView
//  signature
//
//  Created by Nattapon Nimakul on 9/27/55 BE.
//  Copyright (c) 2555 Nattapon Nimakul. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SignatureController.h"

@interface flSignatureSignView : UIView {
}

@property(nonatomic, strong) NSMutableArray *setOfPoints;
//@property (nonatomic, strong) SignatureController *controller;

- (void)clearCurrentSign;
- (UIImage*)drawInWhiteBackground;

@end
