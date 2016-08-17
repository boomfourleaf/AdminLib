//
//  flSignatureSignView
//  signature
//
//  Created by Nattapon Nimakul on 9/27/55 BE.
//  Copyright (c) 2555 Nattapon Nimakul. All rights reserved.
//

#import "flSignatureSignView.h"

@implementation flSignatureSignView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.backgroundColor = [UIColor blackColor];
        self.setOfPoints = [NSMutableArray new];

    }
    return self;
}
//
//#pragma mark - Lazy Instantiation
//- (SignatureController*)controller {
//    if (!_controller) {
//        _controller = [SignatureController new];
//    }
//    return _controller;
//}

-(void)drawSiganture:(BOOL)isWhiteDot {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, ((isWhiteDot) ? [UIColor whiteColor] : [UIColor blackColor]).CGColor);
    CGContextSetLineWidth(context, 6.0);
    //
    UIImage *image = [UIImage imageNamed:isWhiteDot ? @"MainSignaturewhitedot.png" : @"MainSignatureblackdot.png"];
    for (NSArray *points in self.setOfPoints) {
        if ([points count] > 0) {
            CGContextMoveToPoint(context, [points[0] CGPointValue].x, [points[0] CGPointValue].y);
        }
        for (NSValue *point in points) {
            CGContextAddLineToPoint(context, [point CGPointValue].x, [point CGPointValue].y);
            
            CGPoint thisPoint = [point CGPointValue];
            CGContextDrawImage(context, CGRectMake(thisPoint.x-3.5, thisPoint.y-3.5, 7, 7), image.CGImage);
        }
        CGContextStrokePath(context);
    }
}

-(void)drawRect:(CGRect)inRect{
    [self drawSiganture:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    [self.setOfPoints addObject:[@[] mutableCopy]];
    [[self.setOfPoints lastObject] addObject:[NSValue valueWithCGPoint:point]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self setNeedsDisplay];
    [[self.setOfPoints lastObject] addObject:[NSValue valueWithCGPoint:point]];
    //    TTDINFO(@"setOfPoints %@", self.setOfPoints);
    [self updateGrpah];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self setNeedsDisplay];
    
    [[self.setOfPoints lastObject] addObject:[NSValue valueWithCGPoint:point]];
    
    [self updateGrpah];
}

- (void)updateGrpah {
    
    
//    TTDINFO(@"setOfPoints %@", self.setOfPoints);
//    TTDINFO(@"flip %@", [self.controller flipY:self.setOfPoints inRect:self.frame]);
//    [flLiveData setObj:[self convertToDegree] forKey:@"graphPlots"];
//    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"Finished Hand Writing"
//     object:nil];
    
    
    
}

#pragma mark - Public Method
- (void)clearCurrentSign {
    [self updateGrpah];
    
    [self.setOfPoints removeAllObjects];
}

- (UIImage*)drawInWhiteBackground {
    UIImage *output;
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, 1.0);
        
        [self drawSiganture:NO];
        
        output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return output;
}

@end
