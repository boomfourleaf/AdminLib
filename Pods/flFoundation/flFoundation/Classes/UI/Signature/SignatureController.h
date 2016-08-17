//
//  SignatureController.h
//  Dining
//
//  Created by Nattapon Nimakul on 10/4/55 BE.
//  Appsolute Soft Co., Ltd.
//  Copyright (c) 2555 nattapon@appsolutesoft.com. All rights reserved.

//

#import <Foundation/Foundation.h>

@interface SignatureController : NSObject

- (NSArray *)flipY:(NSArray*)setOfPoints inRect:(CGRect)rect option:(NSString*)option;
- (NSArray *)flipY:(NSArray*)setOfPoints inRect:(CGRect)rect;

@end
