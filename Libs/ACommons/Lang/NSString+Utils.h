/**
    This file is part of Visafe for iOS (https://github.com/VisafeTeam/VisafeForiOS).
    Copyright © Visafe Software Limited. All rights reserved.

    Visafe for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Visafe for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Visafe for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Foundation/Foundation.h>

@interface NSString (Utils)

//////////////////////////////////////////////////////////////
#pragma mark - Utilities
//////////////////////////////////////////////////////////////

/** 
 Gets encoding from the encoding name. If not found - returns default
*/
+ (NSStringEncoding)encodingFromString:(nonnull NSString *)encodingName default:(NSStringEncoding)defaultEncoding;


//////////////////////////////////////////////////////////////
#pragma mark - C# and other sugar
//////////////////////////////////////////////////////////////
+ (BOOL)isNullOrEmpty:(nullable NSString *)str;
+ (BOOL)isNullOrWhiteSpace:(nullable NSString *)str;
+ (nullable NSString *)stringByTrim:(nullable NSString *)str;

/// Returns NSString object, which contains hex representation of data.
+ (nonnull NSString * )hexStringFromData:(nonnull NSData *)data;

- (nonnull NSString *)replace:(nonnull NSString *)from to:(nonnull NSString *)to;

/** 
 @return index of string into receiver, or -1 if not found
*/
- (NSInteger)indexOf:(nonnull NSString *)string fromIndex:(NSUInteger)index;
/**
 @return index of string into receiver, or -1 if not found
 */
- (NSInteger)indexOf:(nonnull NSString *)string;

/** Returns a string array that contains the substrings in this string that are delimited by elements of a specified string array. Parameters specify the maximum number of substrings to return and whether to return empty array elements.

 @param strings The separator array. An array of strings that delimit the substrings in this string, an empty array that contains no delimiters, or nil.

 @param count The maximum number of substrings to return.

 @param omitEmpty Set YES to omit empty array elements from the array returned.
 
 */
- (nonnull NSArray *)splitByArray:(nonnull NSArray *)strings count:(NSUInteger)count omitEmpty:(BOOL)omitEmpty;

- (BOOL)contains:(nullable NSString *)str;

- (BOOL)contains:(nullable NSString *)str caseSensitive:(BOOL)sensitive;

- (BOOL)asciiContains:(nullable NSString *)string ignoreCase:(BOOL)ignoreCase;


/**
 Splits string in ascii mode by the delimiter, ignoring escaped delimiters (and empty parts).
 
 @return List with string parts, where escaped characters became unescaped.
 
 Exemples:
 
 NSArray *test = @[];
 XCTAssert([[@"    " asciiSplitByDelimiter:' ' escapeCharacter:'\\'] isEqual:@[]]);
 test = @[@" "];
 XCTAssert([test isEqualToArray:[@"\\     " asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
 test = @[@"str", @"str"];
 XCTAssert([test isEqualToArray:[@"str str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
 test = @[@"str", @"str"];
 XCTAssert([test isEqualToArray:[@" str str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
 test = @[@"str str"];
 XCTAssert([test isEqualToArray:[@"str\\ str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
 test = @[@"str,", @" ", @"\\st,r"];
 XCTAssert([test isEqualToArray:[@"str\\,, ,\\st\\,r" asciiSplitByDelimiter:',' escapeCharacter:'\\']]);
 
 */
- (nullable NSArray *)asciiSplitByDelimiter:(char)delimiter escapeCharacter:(char)escapeCharacter;

/**
 *  Find any string from string array as substring in receiver.
 *
 *  @param strings An array of strings that finding in this string, an empty array that contains no strings, or nil.
 *
 *  @return YES if receiver contains any string from string array, otherwise NO.
 */
- (BOOL)containsAny:(nonnull NSArray *)strings;

/**
 *  Find any string from string array as substring in receiver.
 *
 *  @param strings An array of strings that finding in this string, an empty array that contains no strings, or nil.
 *
 *  @return Range of first occurence of any string from string array, otherwise range where range.location equals NSNotFound.
 */
- (NSRange)rangeOfAny:(nonnull NSArray *)strings;

/**
    Find any string from string array as substring in receiver.
 
    @param strings An array of strings that finding in this string, an empty array that contains no strings, or nil.
    @param startIndex Index, from it will be performed search.
 
    @return Range of first occurence of any string from string array, otherwise range where range.location equals NSNotFound.
 */
- (NSRange)rangeOfAny:(nonnull NSArray *)strings from:(NSUInteger)startIndex;

/// Searches a source string for substrings delimited by a start and end string.
/// Example [@"<a>123</a>" substringsBetween:@"<a>" and:@"</a>" ignoreCase:YES] --> @[@"123"]
/// @return All matching substrings in an list
- (nonnull NSArray *)substringsBetween:(nonnull NSString *)start and:(nonnull NSString *)end ignoreCase:(BOOL)ignoreCase;
/// Searches a source string for substrings delimited by a start and end string.
/// Example [@"<a>123</a>" substringsBetween:@"<a>" and:@"</a>"] --> @[@"123"]
/// @return All matching substrings in an list
- (nonnull NSArray *)substringsBetween:(nonnull NSString *)start and:(nonnull NSString *)end;

/// Gets MD5 digest, max string length 4GB.
- (nonnull NSString *)md5Digest;

/// Gets SHA256 digest, max string length 4GB.
- (nonnull NSString *)sha256Digest;

/// returns count of occurances of substring in string
- (NSUInteger) countOccurencesOfString:(nonnull NSString*)string;

/// Repeat a String repeat times to form a new String, with a String separator injected each time.
+ (nonnull NSString*) repeat:(nonnull NSString*)string separator:(nonnull NSString*) separator repeat:(NSInteger)repeat;

/// converts html string to attributed string
- (nullable NSMutableAttributedString*) attributedStringFromHtml;

@end

/**
 just returns its input but is annotated to return a localized string
 */
__attribute__((annotate("returns_localized_nsstring")))
static inline NSString* _Nonnull LocalizationNotNeeded(NSString* _Nonnull s) {
    return s;
}

/**
 returns localized string by key. If string not found in preffered language, rerurns english string -
 NSLocalizedString() returns key in this case
 */
NSString* _Nonnull ACLocalizedString(NSString* _Nullable key, NSString* _Nullable comment);

