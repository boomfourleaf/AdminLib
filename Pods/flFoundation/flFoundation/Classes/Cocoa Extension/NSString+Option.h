//
//  NSString+Option.h
//  Dining
//
//  Created by Nattapon Nimakul on 9/2/56 BE.
//  Copyright (c) 2556 nattapon@appsolutesoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Option)

#pragma mark - Hash
- (NSString *)MD5;

#pragma mark - Number Operation
- (BOOL)isInteger;

#pragma mark - Text Size
- (CGSize) sizeForFont:(UIFont*)font fraemSize:(CGSize)frameSize;
- (CGFloat) heightForFont:(UIFont*)font width:(CGFloat)width;
- (CGFloat) heightForFont:(UIFont*)font width:(CGFloat)width lineBreak:(NSLineBreakMode)lineBreakMode __attribute__((deprecated)); // Deprecated use - [NSString heightForFont:width:] instead

#pragma mark - Text Size Ceil
- (CGSize) sizeForFontCeil:(UIFont*)font frameSize:(CGSize)frameSize;
- (CGFloat) heightForFontCeil:(UIFont*)font width:(CGFloat)width;

#pragma mark - Text String Operation
- (NSString *)firstCapital;
- (NSString *)addSuffix:(NSString*)suffix withExtension:(NSString*)targetExtension;
- (NSString *)addSuffix:(NSString*)suffix;
- (NSString*)subString:(NSInteger)start end:(NSInteger)end;
- (NSString*)removeString:(NSString*)str;

#pragma mark - Draw in Rect
- (void)drawinRect:(CGRect)rect withFont:(UIFont *)font
     lineBreakMode:(NSLineBreakMode)lineBreakMode
         alignment:(NSTextAlignment)alignment;
- (void)drawinRect:(CGRect)rect withFont:(UIFont *)font alignment:(NSTextAlignment)alignment;
- (void)drawinRect:(CGRect)rect withFont:(UIFont *)font;

#pragma Mark Draw at Point
- (void)drawatPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font
      lineBreakMode:(NSLineBreakMode)lineBreakMode
          alignment:(NSTextAlignment)alignment;
- (void)drawatPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font
          alignment:(NSTextAlignment)alignment;
- (void)drawatPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font;

#pragma mark - Regular Expression
- (BOOL)checkReg:(NSString*)reg;
- (NSString*)getReg:(NSString*)reg;

@end
