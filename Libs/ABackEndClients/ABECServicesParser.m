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


#import "ABECServicesParser.h"

#import "ACommons/ACLang.h"

@implementation ABECServicesParser

- (BOOL)parseData:(NSData *)data {
    
    NSError *error = nil;
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        
        DDLogError(
                   @"(ABECTrackersParser) Error when parsing trackers JSON:\n%@",
                   [error localizedDescription]);
        DDLogErrorTrace();
        return NO;
    }
    
    if (!root) {
        
        return NO;
    }
    
    if (!([root isKindOfClass:[NSDictionary class]])) {
        
        DDLogError(@"(ABECTrackersParser) Error when parsing trackers metadata "
                   @"JSON:\nReturned object is not valid dictionary.");
        DDLogErrorTrace();
        return NO;
    }
    
    NSMutableDictionary* trackers = [NSMutableDictionary new];
    
    for (NSDictionary *item in root[@"trackers"]) {
        
        NSString *name = item[@"name"];
        NSString *description = item[@"description"];
        NSArray *categories = item[@"categories"];
        NSArray *domains = item[@"domains"];
        NSArray *notes = item[@"notes"];
        
        for (NSString* domain in domains) {
            
            ABECService* service = trackers[domain] ? : [ABECService new];
            
            service.name = name;
            service.serviceDescription = description;
            
            NSArray* serviceCategories = service.categories ?: [NSArray new];
            serviceCategories = [serviceCategories arrayByAddingObjectsFromArray:categories];
            service.categories = serviceCategories;
            
            NSArray* serviceNotes = service.notes ?: [NSArray new];
            serviceNotes = [serviceNotes arrayByAddingObjectsFromArray:notes];
            service.notes = serviceNotes;
            
            trackers[domain] = service;
        }
    }
    
    self.hosts = trackers.copy;
    
    return YES;
}

@end
