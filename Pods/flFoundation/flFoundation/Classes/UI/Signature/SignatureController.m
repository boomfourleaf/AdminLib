//
//  SignatureController.m
//  Dining
//
//  Created by Nattapon Nimakul on 10/4/55 BE.
//  Appsolute Soft Co., Ltd.
//  Copyright (c) 2555 nattapon@appsolutesoft.com. All rights reserved.

//

#import "SignatureController.h"

#define radiansToDegrees(radians) (radians * 180 / M_PI)

@implementation SignatureController

- (CGFloat)getDegree:(CGPoint)point from:(CGPoint)beginPoint {
    CGFloat degree = 0;
    if (point.x - beginPoint.x != 0) {
        CGFloat dX = point.x - beginPoint.x;
        CGFloat dY = point.y - beginPoint.y;
        
        degree = radiansToDegrees(atan2f(dY, dX));
        
        // Convert (0->180, -180->0) ==> (0->360)
        if (degree < 0) {
            
        }
    }
    return degree;
}

-(NSArray*)convertPointsToDegrees:(NSArray*)points begin:(CGPoint)beginPoint {
    NSMutableArray *degrees = [NSMutableArray new];
    
    for (NSValue *valuePoint in points) {
        CGPoint point = [valuePoint CGPointValue];
        
        // filter divided by zero
        if (point.x == beginPoint.x)
            continue;
        
        CGFloat degree = -[self getDegree:point from:beginPoint];
        //        TTDINFO(@"%@ %@ => %f", NSStringFromCGPoint(beginPoint), NSStringFromCGPoint(point), degree);
        [degrees addObject:@(degree)];
    }
    return degrees;
}

- (NSArray *)convertToDegree:(NSArray*)setOfPoints {
    if ([setOfPoints count] == 0 || [setOfPoints[0] count] < 2 )
        return nil;
    
    NSMutableArray *setOfDegrees = [NSMutableArray new];
    CGPoint beginPoint = [setOfPoints[0][0] CGPointValue];
    
    for (NSArray *points in setOfPoints) {
        
        NSMutableArray *output = [NSMutableArray new];
        NSInteger i = 0;
        for (NSNumber *degree in [self convertPointsToDegrees:points begin:beginPoint]) {
            [output addObject:[NSValue valueWithCGPoint:CGPointMake(i, [degree floatValue])]];
            i++;
        }
        
        [setOfDegrees addObject:output];
    }
    
    return [setOfDegrees copy];
}

- (NSArray *)flipY:(NSArray*)setOfPoints inRect:(CGRect)rect option:(NSString*)option {
    @try {
        NSMutableArray *outPoints = [NSMutableArray new];
        
        for (NSArray *points in setOfPoints) {
            [outPoints addObject:[NSMutableArray new]];
            for (NSValue *valPoint in points) {
                CGPoint point = [valPoint CGPointValue];
                
                if ([option isEqualToString:@"CGPOINT"]) {
                    [[outPoints lastObject] addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, rect.size.height - point.y)]];
                    
                } else if ([option isEqualToString:@"TEXT"]) {
                    [[outPoints lastObject] addObject:[NSString stringWithFormat:@"(%f,%f)", point.x, rect.size.height - point.y]];
                    
                }
            }
        }
        
        return [outPoints copy];
    }
    @catch (NSException *exception) {
        NSLog(@"error %@", [exception reason]);
    }
    return nil;
}

- (NSArray *)flipY:(NSArray*)setOfPoints inRect:(CGRect)rect {
    return [self flipY:setOfPoints inRect:rect option:@"CGPOINT"];
}


@end
