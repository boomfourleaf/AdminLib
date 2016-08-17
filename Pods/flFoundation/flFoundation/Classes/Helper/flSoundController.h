//
//  flSoundController.h
//  Dining
//
//  Created by Nattapon Nimakul on 7/15/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface flSoundController : NSObject

+(flSoundController*)sharedService;
- (void)playAlertSound;

@end
