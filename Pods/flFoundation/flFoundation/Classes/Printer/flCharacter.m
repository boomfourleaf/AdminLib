//
//  flCharacter.m
//  ePOSPrintSample
//
//  Created by Nattapon Nimakul on 7/19/2557 BE.
//
//

#import "flCharacter.h"

@implementation flCharacter

#pragma mark - Character Manipulate
+ (NSCharacterSet*)vowelUpLevel1CharacterSet {
    // ั  ี  ิ  ื  ึ  ํ  ์
    return [NSCharacterSet characterSetWithCharactersInString:@"ัีิืึํ์"];
}

+ (NSCharacterSet*)vowelUpLevel2CharacterSet {
    // ่  ้  ๊  ็  ๋ 
    return [NSCharacterSet characterSetWithCharactersInString:@"่้๊็๋"];
}

+ (NSCharacterSet*)vowelDownLevel1CharacterSet {
    // ุ  ู  
    return [NSCharacterSet characterSetWithCharactersInString:@"ุู"];
}

#pragma mark - String Manipulate
+ (NSDictionary *)stringVowelParse:(NSString*)text {
    NSString *baseLine = @"";
    NSString *vowelUp1 = @"";
    NSString *vowelUp2 = @"";
    NSString *vowelDown1 = @"";
    BOOL hasUp1 = YES;
    BOOL hasUp2 = YES;
    BOOL hasDown1 = YES;
    for (NSInteger i = 0; i < [text length]; i++) {
        unichar character = [text characterAtIndex:i];
        
        if ( [[flCharacter vowelUpLevel1CharacterSet] characterIsMember:character] ) {
            vowelUp1 = [vowelUp1 stringByAppendingString:[text substringWithRange:NSMakeRange(i, 1)]];
            hasUp1 = YES;
            
        } else if ( [[flCharacter vowelUpLevel2CharacterSet] characterIsMember:character] ) {
            vowelUp2 = [vowelUp2 stringByAppendingString:[text substringWithRange:NSMakeRange(i, 1)]];
            hasUp2 = YES;
            
        } else if ( [[flCharacter vowelDownLevel1CharacterSet] characterIsMember:character] ) {
            vowelDown1 = [vowelDown1 stringByAppendingString:[text substringWithRange:NSMakeRange(i, 1)]];
            hasDown1 = YES;
            
        // Alphabet
        } else {
            // Auto correction display
            // Change alphabet ำ  to  า and ํ for better display
            if (0 != [baseLine length] && [[NSCharacterSet characterSetWithCharactersInString:@"ำ"] characterIsMember:character]) {
                vowelUp1 = [vowelUp1 stringByAppendingString:@"ํ"];
                hasUp1 = YES;
                baseLine = [baseLine stringByAppendingString:@"า"];

            // Normal character
            } else {
                baseLine = [baseLine stringByAppendingString:[text substringWithRange:NSMakeRange(i, 1)]];
            }

            if (NO == hasUp1)
                vowelUp1 = [vowelUp1 stringByAppendingString:@" "];
            
            if (NO == hasUp2)
                vowelUp2 = [vowelUp2 stringByAppendingString:@" "];
            
            if (NO == hasDown1)
                vowelDown1 = [vowelDown1 stringByAppendingString:@" "];
            
            // Clear
            hasUp1 = NO;
            hasUp2 = NO;
            hasDown1 = NO;
        }
    }// Move VowelUp2 to VowelUp1 if possible
    if ([vowelUp1 isEqualToString:@""]) {
        vowelUp1 = vowelUp2;
        vowelUp2 = @"";
    }
    if (NO == [vowelUp1 isEqualToString:@""] && NO == [vowelUp2 isEqualToString:@""]) {
        for (NSInteger i = 0; i < [vowelUp2 length]; i++) {
            if (i >= [vowelUp1 length]) {
                vowelUp1 = [vowelUp1 stringByAppendingString:[vowelUp2 substringWithRange:NSMakeRange(i, [vowelUp2 length] - i)]];
                break;
            }
            
            NSString *charUp1 = [vowelUp1 substringWithRange:NSMakeRange(i, 1)];
            NSString *charUp2 = [vowelUp2 substringWithRange:NSMakeRange(i, 1)];
            if ([charUp1 isEqualToString:@" "] && NO == [charUp2 isEqualToString:@" "]) {
                vowelUp1 = [NSString stringWithFormat:@"%@%@%@", [vowelUp1 substringWithRange:NSMakeRange(0, i)], charUp2, [vowelUp1 substringWithRange:NSMakeRange(i+1, [vowelUp1 length] - i - 1)]];
                
                vowelUp2 = [NSString stringWithFormat:@"%@%@%@", [vowelUp2 substringWithRange:NSMakeRange(0, i)], @" ", [vowelUp2 substringWithRange:NSMakeRange(i+1, [vowelUp2 length] - i - 1)]];
            }
        }
    }

    // Change to empty string for only space vowels
    if ([[vowelUp1 stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
        vowelUp1 = @"";

    if ([[vowelUp2 stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
        vowelUp2 = @"";

    if ([[vowelDown1 stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
        vowelDown1 = @"";
    
    return @{@"base": baseLine, @"vowel_up1": vowelUp1, @"vowel_up2": vowelUp2, @"vowel_down1": vowelDown1};
}

+ (NSArray<NSString*> *)stringSplit:(NSString*)text byLength:(NSInteger)length {
    NSMutableArray<NSString*>  *output = [NSMutableArray<NSString*> new];
    NSString *current = @"";
    NSInteger currentCount = 0;
    
    for (NSInteger i = 0; i < [text length]; i++) {
        unichar character = [text characterAtIndex:i];
        
        if ( [[flCharacter vowelUpLevel1CharacterSet] characterIsMember:character] ) {
            current = [current stringByAppendingString:[text substringWithRange:NSMakeRange(i, 1)]];
            
        } else if ( [[flCharacter vowelUpLevel2CharacterSet] characterIsMember:character] ) {
            current = [current stringByAppendingString:[text substringWithRange:NSMakeRange(i, 1)]];
            
        } else if ( [[flCharacter vowelDownLevel1CharacterSet] characterIsMember:character] ) {
            current = [current stringByAppendingString:[text substringWithRange:NSMakeRange(i, 1)]];
            
            // Alphabet
        } else {
            if (length == currentCount) {
                [output addObject:current];
                current = @"";
                currentCount = 0;
            }
            current = [current stringByAppendingString:[text substringWithRange:NSMakeRange(i, 1)]];
            currentCount += 1;
        }
    }
    if (NO == [current isEqualToString:@""]) {
        [output addObject:current];
    }
    return [output copy];
}

+ (NSArray<NSString*> *)stringSplitByNewLine:(NSString*)text {
    NSArray<NSString*> *output = [text componentsSeparatedByString:@"\r\n"];
    if (1 == [output count]) {
        output = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }

    return output;
}

+ (NSInteger)stringLength:(NSString*)text {
    NSInteger currentCount = 0;
    
    for (NSInteger i = 0; i < [text length]; i++) {
        unichar character = [text characterAtIndex:i];
        
        if ( [[flCharacter vowelUpLevel1CharacterSet] characterIsMember:character] ) {
            
        } else if ( [[flCharacter vowelUpLevel2CharacterSet] characterIsMember:character] ) {
            
        } else if ( [[flCharacter vowelDownLevel1CharacterSet] characterIsMember:character] ) {
            
        // Alphabet
        } else {
            currentCount += 1;
        }
    }
    return currentCount;
}

@end
