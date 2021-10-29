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

#import "ABECFilterParsers.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACIO.h"
#import "Visafe-Swift.h"

/////////////////////////////////////////////////////////////////////
#pragma mark -  JSON Parsers implementation
/////////////////////////////////////////////////////////////////////

@interface ABECFilterMetadata : ASDFilterMetadata

@end

@implementation ABECFilterMetadata

#pragma mark Supporting set object from dictionary

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"timeUpdated"]) {
        self.updateDateString = [self dateStringConvertFrom:value];
        self.updateDate = [NSDate dateWithISO8601String:self.updateDateString];
        if (! self.updateDate) {
            // If can't convert, set update date to current datetime
            self.updateDate = [NSDate date];
            self.updateDateString = [[NSDate date] iso8601String];
        }
        
        // last_check_time creating
        self.checkDate = [NSDate date];
        self.checkDateString = [[NSDate date] iso8601String];
        //--
        
    }
    else if ([key isEqualToString:@"description"]){
        
        self.descr = value;
    }
    else if ([key isEqualToString:@"languages"]){
        
        self.langs = value;
    }
    else if ([key isEqualToString:@"languages"]){
    }
    else
        [super setValue:value forKey:key];
}

- (NSString *)dateStringConvertFrom:(NSString *)string {
    
    NSUInteger delimeter = string.length - 5;
    return [NSString stringWithFormat:@"%@.000%@:%@",[string substringToIndex:delimeter] , [string substringWithRange:NSMakeRange(delimeter, 3)], [string substringFromIndex:(delimeter + 3)]];
    
}

@end
@interface ABECFilterGroup : ASDFilterGroup
@end
@implementation ABECFilterGroup

#pragma mark Supporting set object from dictionary

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"groupName"]) {
        
        self.name = value;
    }
    else
        [super setValue:value forKey:key];
}

@end

@implementation JSONMetadataParser{
    
    NSMutableArray <ASDFilterMetadata *> *_filterMetadataList;
    NSMutableArray <ASDFilterGroup *> *_groupList;
    
    NSDictionary<NSString*, NSNumber*> *_tagTypes;
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        _filterMetadataList = [NSMutableArray array];
        _groupList = [NSMutableArray array];
        _tagTypes = @{@"purpose": @(ASDFilterTagTypePurpose),
                      @"lang": @(ASDFilterTagTypeLang),
                      @"reference": @(ASDFilterTagTypeReference),
                      @"recommended": @(ASDFilterTagTypeRecommended),
                      @"platform": @(ASDFilterTagTypePlatform),
                      @"problematic": @(ASDFilterTagTypeProblematic),
                      @"obsolete":@(ASDFilterTagTypeObsolete),
                      @"platform":@(ASDFilterTagTypePlatform)
                      };
    }
    
    return self;
}

- (NSArray <ASDFilterMetadata *> *)filterMetadataList {
    
    return _filterMetadataList;
}

- (NSArray <ASDFilterGroup *> *)groupList {
    
    return _groupList;
}

- (BOOL)parseWithData:(NSData *)data{
    
    NSError *error = nil;
    NSDictionary *metaDict =
    [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        
        DDLogError(
                   @"(ABECFilterParsers) Error when parsing groups/filters metadata JSON:\n%@",
                   [error localizedDescription]);
        DDLogErrorTrace();
        return NO;
    }
    
    if (!metaDict) {
        
        return NO;
    }
    
    if (!([metaDict isKindOfClass:[NSDictionary class]] && metaDict[@"filters"] && metaDict[@"groups"] && metaDict[@"tags"])) {
        
        DDLogError(@"(ABECFilterParsers) Error when parsing groups/filters metadata "
                   @"JSON:\nReturned object is not valid dictionary.");
        DDLogErrorTrace();
        return NO;
    }
    
    NSMutableDictionary<NSNumber*, ASDFilterTagMeta*>* tagMetas = [NSMutableDictionary new];
    for (NSDictionary * item in metaDict[@"tags"]) {
        NSNumber* tagId = item[@"tagId"];
        NSString* keyword = item[@"keyword"];
        NSArray *params = [keyword componentsSeparatedByString:@":"];
        
        if(!(tagId && [tagId isKindOfClass:NSNumber.class] && params.count))
            continue;
        
        ASDFilterTagMeta* tag = [ASDFilterTagMeta new];
        tag.tagId = tagId.intValue;
        tag.type = _tagTypes[params[0]].intValue;
        
        if(params.count == 2) {
            tag.name = params[1];
        }
        else {
            tag.name = params[0];
        }
        
        tagMetas[tagId] = tag;
    }
    
    for (NSDictionary *item in metaDict[@"filters"]) {
        
        ASDFilterMetadata *meta = [ABECFilterMetadata new];
        [meta setValuesForKeysWithDictionary:item];
        NSMutableArray<ASDFilterTagMeta*>* tags = [NSMutableArray new];
        for(NSNumber* tagId in item[@"tags"]) {
            ASDFilterTagMeta* tagMeta = tagMetas[tagId];
            if(tagMeta) {
                [tags addObject:tagMeta];
            }
        }
        
        meta.tags = tags;
        
        [_filterMetadataList addObject:meta];
    }
    
    for (NSDictionary *item in metaDict[@"groups"]) {
        
        ASDFilterGroup *group = [ABECFilterGroup new];
        
        [group setValuesForKeysWithDictionary:item];
        
        [_groupList addObject:group];
    }
    
    return YES;
}

@end

@implementation JSONI18nParser{
    
    NSMutableDictionary <NSNumber *, NSDictionary <NSString *, ASDFilterLocalization *> *> *_filtersI18nDict;
    NSMutableDictionary <NSNumber *, NSDictionary <NSString *, ASDFilterGroupLocalization *> *> *_groupsI18nDict;
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        _filtersI18nDict = [NSMutableDictionary dictionary];
        _groupsI18nDict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (ASDFiltersI18n *)filtersI18n {
    
    return [[ASDFiltersI18n alloc] initWithDictionary:_filtersI18nDict];
}
- (ASDGroupsI18n *)groupsI18n {
    
    return [[ASDGroupsI18n alloc] initWithDictionary:_groupsI18nDict];
}

- (BOOL)parseWithData:(NSData *)data{
    NSError *error = nil;
    NSDictionary *dataDict =
    [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        
        DDLogError(
                   @"(ABECFilterParsers) Error when parsing i18n JSON:\n%@",
                   [error localizedDescription]);
        DDLogErrorTrace();
        return NO;
    }
    
    if (!dataDict) {
        
        return NO;
    }
    
    if (!([dataDict isKindOfClass:[NSDictionary class]] && dataDict[@"groups"] && dataDict[@"filters"])) {
        
        DDLogError(@"(ABECFilterParsers) Error when parsing groups/filters i18n JSON:\nReturned object is not valid dictionary.");
        DDLogErrorTrace();
        return NO;
    }
    
    NSDictionary *filters = dataDict[@"filters"];
    ASSIGN_WEAK(self);
    [filters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        ASSIGN_STRONG(self);
        NSNumber *filterId = @([key intValue]);
        NSDictionary <NSString *, NSDictionary *>*langs = obj;
        
        NSMutableDictionary <NSString *, ASDFilterLocalization *> *targetLangs = [NSMutableDictionary dictionaryWithCapacity:langs.count];
        [langs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSString* langCode = [[key lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            ASDFilterLocalization *localization = [ASDFilterLocalization new];
            localization.filterId = filterId;
            localization.lang = [self canonicalLangFromString:langCode];
            localization.name = obj[@"name"];
            localization.descr = obj[@"description"];
            
            targetLangs[localization.lang] = localization;
        }];
        
        USE_STRONG(self)->_filtersI18nDict[filterId] = [targetLangs copy];
    }];
    
    NSDictionary *groups = dataDict[@"groups"];
    [groups enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        ASSIGN_STRONG(self);
        NSNumber *groupId = @([key intValue]);
        NSDictionary <NSString *, NSDictionary *>*langs = obj;
        
        NSMutableDictionary <NSString *, ASDFilterGroupLocalization *> *targetLangs = [NSMutableDictionary dictionaryWithCapacity:langs.count];
        [langs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSString* langCode = [[key lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            ASDFilterGroupLocalization *localization = [ASDFilterGroupLocalization new];
            localization.groupId = groupId;
            localization.lang = [self canonicalLangFromString:langCode];
            localization.name = obj[@"name"];
            
            targetLangs[localization.lang] = localization;
        }];
        
        USE_STRONG(self)->_groupsI18nDict[groupId] = [targetLangs copy];
    }];
    
    return YES;
}

- (NSString *)canonicalLangFromString:(NSString *)string {
    
    return [NSLocale canonicalLanguageIdentifierFromString:string];
}
@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  Plain Text Parsers implementation
/////////////////////////////////////////////////////////////////////

@implementation PlainFilterParser{
    
    ASDFilter *filter;
}

@synthesize filterId;

- (BOOL)parseWithData:(NSData *)data {

    filter = [ASDFilter new];
    filter.filterId = self.filterId;
    
    NSInputStream *stream = [NSInputStream inputStreamWithData:data];
    [stream open];
    
    NSString *line;
    NSMutableArray<NSString*>* ruleStrings = [NSMutableArray new];
    while ((line = [ACIOUtils readLine:(id<ACIOUtilReadProtocol>)stream
                              encoding:NSUTF8StringEncoding])) {
        [ruleStrings addObject:line];
    }
    [stream close];
    
    AffinityRulesParser* rulesParser = [AffinityRulesParser new];
    filter.rules = [rulesParser parseStrings:ruleStrings filterId: self.filterId];
    
    return YES;
}

- (ASDFilter *)filter{
    
    return filter;
}

@end
