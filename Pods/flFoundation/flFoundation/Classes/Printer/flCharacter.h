//
//  flCharacter.h
//  ePOSPrintSample
//
//  Created by Nattapon Nimakul on 7/19/2557 BE.
//
//

#import <Foundation/Foundation.h>

@interface flCharacter : NSObject

#pragma mark - Character Manipulate
+ (NSCharacterSet*)vowelUpLevel1CharacterSet;
+ (NSCharacterSet*)vowelUpLevel2CharacterSet;
+ (NSCharacterSet*)vowelDownLevel1CharacterSet;

#pragma mark - String Manipulate
+ (NSDictionary *)stringVowelParse:(NSString*)text;
+ (NSArray<NSString*> *)stringSplit:(NSString*)text byLength:(NSInteger)length;
+ (NSArray<NSString*>*)stringSplitByNewLine:(NSString*)text;
+ (NSInteger)stringLength:(NSString*)text;

@end
