//
//  NSString+Option.m
//  Dining
//
//  Created by Nattapon Nimakul on 9/2/56 BE.
//  Copyright (c) 2556 nattapon@appsolutesoft.com. All rights reserved.
//

#import "NSString+Option.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Option)

#pragma mark - Hash
- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

#pragma mark - Number Operation
- (BOOL)isInteger {
    if ([self isEqualToString:@"0"]) {
        return YES;
    } else if ([self integerValue] > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Text Size
- (CGSize) sizeForFont:(UIFont*)font fraemSize:(CGSize)frameSize {
    if ([self isEqualToString:@""])
        return CGSizeZero;

    CGSize textSize = [self boundingRectWithSize:frameSize
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil].size;
    return textSize;
}

- (CGFloat) heightForFont:(UIFont*)font width:(CGFloat)width {
    return [self sizeForFont:font fraemSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

- (CGFloat) heightForFont:(UIFont*)font width:(CGFloat)width lineBreak:(NSLineBreakMode)lineBreakMode {
    return [self heightForFont:font width:width];
}

#pragma mark - Text Size Ceil
- (CGSize) sizeForFontCeil:(UIFont*)font frameSize:(CGSize)frameSize {
    CGSize textSize = [self sizeForFont:font fraemSize:frameSize];
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

- (CGFloat) heightForFontCeil:(UIFont*)font width:(CGFloat)width {
    return ceil([self heightForFont:font width:width]);
}


#pragma mark - Text String Operation
- (NSString *)firstCapital {
    if ([self length] >= 1) {
        NSString *firstCapChar = [[self substringToIndex:1] capitalizedString];
        NSString *cappedString = [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
        
        return cappedString;
    }
    return self;
}

- (NSString *)addSuffix:(NSString*)suffix withExtension:(NSString*)targetExtension {
    // Path
    NSString* fileName = [[self lastPathComponent] stringByDeletingPathExtension];
    NSString *path = [self stringByDeletingLastPathComponent];
    NSString *extension = (nil != targetExtension) ? targetExtension : [self pathExtension];
    
    NSString *newFileName = [fileName stringByAppendingFormat:@"%@.%@", suffix, extension];
    NSString *newPath = [path stringByAppendingPathComponent:newFileName];
    
    return newPath;
}

- (NSString *)addSuffix:(NSString*)suffix {
    return [self addSuffix:suffix withExtension:nil];
}


- (NSString*)subString:(NSInteger)start end:(NSInteger)end {
    return [self substringWithRange:NSMakeRange(start, end)];
}

- (NSString*)removeString:(NSString*)str {
    return [self stringByReplacingOccurrencesOfString:str withString:@""];
}

#pragma mark - Draw in Rect
- (void)drawinRect:(CGRect)rect withFont:(UIFont *)font
     lineBreakMode:(NSLineBreakMode)lineBreakMode
         alignment:(NSTextAlignment)alignment {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    
//    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle, NSBackgroundColorAttributeName:[UIColor redColor]};
        NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
    
    [self drawInRect:rect withAttributes:attributes];
}

- (void)drawinRect:(CGRect)rect withFont:(UIFont *)font alignment:(NSTextAlignment)alignment {
    [self drawinRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:alignment];
}

- (void)drawinRect:(CGRect)rect withFont:(UIFont *)font {
    [self drawinRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}

#pragma Mark Draw at Point
- (void)drawatPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font
      lineBreakMode:(NSLineBreakMode)lineBreakMode
          alignment:(NSTextAlignment)alignment {
    
    [self drawinRect:CGRectMake(point.x, point.y, width, CGFLOAT_MAX) withFont:font lineBreakMode:lineBreakMode alignment:alignment];
}

- (void)drawatPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font
          alignment:(NSTextAlignment)alignment {
    
    [self drawatPoint:point forWidth:width withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:alignment];
}

- (void)drawatPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font {
    
    [self drawatPoint:point forWidth:width withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
}

#pragma mark - Regular Expression
- (BOOL)checkReg:(NSString*)reg {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:self
                                      options:0
                                        range:NSMakeRange(0, [self length])];
    
    // get key string
    if ([matches count] >= 1){
        return YES;
    }
    
    return NO;
}

- (NSString*)getReg:(NSString*)reg {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:self
                                      options:0
                                        range:NSMakeRange(0, [self length])];
    
    // get key string
    if ([matches count] >= 1){
        NSRange valueRange = [matches[0] rangeAtIndex:1];
        
        return [self substringWithRange:valueRange];

    }
    
    return nil;
}

@end
