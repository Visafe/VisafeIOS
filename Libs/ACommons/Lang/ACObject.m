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

#import <objc/runtime.h>
#import "NSString+Utils.h"
#import "ACObject.h"
#import "DDLogMacros.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACIO.h"


/////////////////////////////////////////////////////////////////////
#pragma mark - ACDObject
/////////////////////////////////////////////////////////////////////

static NSDictionary *_propertyNamesForClasses;
static dispatch_queue_t workingQueue;

@implementation ACObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

+(void)initialize{
    
    @autoreleasepool {
        
        if (!workingQueue) {
            workingQueue = dispatch_queue_create("ACObject", nil);
        }
        
        dispatch_sync(workingQueue, ^{
            
            if (!_propertyNamesForClasses)
                _propertyNamesForClasses = [NSDictionary dictionary];
            
            // obtainning typies of object properties
            unsigned int count = 0;
            objc_property_t *properties = class_copyPropertyList( self, &count );
            
            NSMutableArray *pNames = [NSMutableArray array];
            NSString *propertyName;
            NSString *propertyType;
            NSArray *pType;
            for (NSUInteger i = 0; i <count; i++) {
                
                pType = [[NSString stringWithUTF8String:property_getAttributes(properties[i])] componentsSeparatedByString:@","];
                if (pType.count) {

                    propertyType = [[pType firstObject] substringFromIndex:1];
                    propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
                    NSUInteger len = pType.count;
                    len = [[pType lastObject] hasPrefix:@"V"] ? len - 2 : len - 1;
                    pType = [pType subarrayWithRange:NSMakeRange(1, len)];
                    if (![@"W|R|P" containsAny:pType] &&
                        ([@"c|i|s|l|q|C|I|S|L|f|d" contains:propertyType] || [propertyType hasPrefix:@"@"])) {
                        
                        [pNames addObject:propertyName];
                        
                    }
                }
            }
            
            if (pNames.count) {
                
                NSString *className = NSStringFromClass(self);
                NSMutableSet *propertyNames = _propertyNamesForClasses[className];
                
                if (!propertyNames) {
                    NSMutableDictionary *newPropertyNamesForClasses = [NSMutableDictionary dictionaryWithDictionary:_propertyNamesForClasses];
                    propertyNames = [NSMutableSet set];
                    newPropertyNamesForClasses[className] = propertyNames;
                    
                    // _propertyNamesForClasses field can be read in another thread
                    // we use immutable dictianary to prevent crashes
                    _propertyNamesForClasses = [newPropertyNamesForClasses copy];
                }
                
                [propertyNames addObjectsFromArray:pNames];
                
                // add properties from super classes
                Class superClass = self;
                NSSet *pSet;
                while ([(superClass = [superClass superclass]) isSubclassOfClass:[ACObject class]]) {
                    
                    className = NSStringFromClass(superClass);
                    pSet = _propertyNamesForClasses[className];
                    if (pSet)
                        [propertyNames unionSet:pSet];
                }
            }
            
            if ( properties != NULL )
                free( properties );
        });
    }
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{

    self = [super init];
    if (self) {
        @autoreleasepool {
            
            NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionary];
            id obj;
            for (NSString *key in [self propertyNames]) {
                @try {
                    obj = [aDecoder decodeObjectForKey:key];
                    if (obj)
                        propertiesDict[key] = obj;
                } @catch (NSException *exception) {
                    DDLogError(@"An error occurred, while decoding object (initWithCoder initializer,  ACObject class), exception : %@", exception);
                }
                
            }
            if ([propertiesDict count])
                [self setValuesForKeysWithDictionary:propertiesDict];
        }
    }
    
    return self;
}


+ (NSArray *)propertyNamesArray{
    
    return [[self new] propertyNames];
}

// We lie here
+ (BOOL)supportsSecureCoding {
    return YES;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)coder
{
//    [super encodeWithCoder:coder];
    
    NSDictionary *propertiesDict = [self dictionaryWithValuesForKeys:[self propertyNames]];
    for (NSString *key in [propertiesDict allKeys]) {
        
        [coder encodeObject:propertiesDict[key] forKey:key];
    }
}

- (id)copyWithZone:(NSZone *)zone{
    
    id newObj = [[[self class] allocWithZone:zone] init];
    if (newObj) {
        
        NSDictionary *propertyValues = [self dictionaryWithValuesForKeys:[self propertyNames]];
        if (propertyValues.count)
            [newObj setValuesForKeysWithDictionary:propertyValues];
    }
    
    return newObj;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods

- (NSArray *)propertyNames {
    
    NSMutableArray *properties = [NSMutableArray array];
    
    dispatch_sync(workingQueue, ^{
        
        id currentClass = [self class];
        while (currentClass != [ACObject class]) {
            [properties addObjectsFromArray:[_propertyNamesForClasses[NSStringFromClass(currentClass)] allObjects]];
            currentClass = [currentClass superclass];
        }
    });
    
    return properties;
}
@end
