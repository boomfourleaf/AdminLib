//
//  flSoundController.m
//  Dining
//
//  Created by Nattapon Nimakul on 7/15/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

#import "flSoundController.h"
#include <AudioToolbox/AudioToolbox.h>

@interface flSoundController() {
    
//	CFURLRef		soundFileURLRef;
//	SystemSoundID	soundFileObject;
    
}

@property (nonatomic, readwrite)	CFURLRef		soundFileURLRef;
@property (nonatomic, readonly)	SystemSoundID	soundFileObject;

@end

@implementation flSoundController {
    dispatch_queue_t _syncQueue;
}

- (id)init {
    self = [super init];
    if (self) {
        _syncQueue = dispatch_queue_create("flSoundControllerQueue", 0);
    }
    
    return self;
}

#pragma mark -
#pragma mark - Share Service Object
+(flSoundController*)sharedService {
    static flSoundController *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
	return share;
}

#pragma mark - Lazy Initial
- (void)playAlertSound {
    dispatch_sync(_syncQueue, ^{
        if (!_soundFileObject) {
            // Create the URL for the source audio file. The URLForResource:withExtension: method is
            //    new in iOS 4.0.
            NSURL *sweetAlert   = [[NSBundle mainBundle] URLForResource: @"SweetAlertSound4"
                                                          withExtension: @"wav"];
            
            // Store the URL as a CFURLRef instance
            self.soundFileURLRef = (__bridge CFURLRef) sweetAlert;
            
            // Create a system sound object representing the sound file.
            AudioServicesCreateSystemSoundID (
                                              
                                              _soundFileURLRef,
                                              &_soundFileObject
                                              );
            NSLog(@"regis alert sound");
        }
	});
    AudioServicesPlaySystemSound (_soundFileObject);
}

@end
