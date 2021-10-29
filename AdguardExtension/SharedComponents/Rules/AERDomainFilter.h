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
#import "ACommons/ACNetwork.h"
#import "AERDomainFilterRule.h"

/// Filters URLs
@interface AERDomainFilter  : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark -  Init and Class methods
/////////////////////////////////////////////////////////////////////

/// Main Create Method (constructor)
+ (AERDomainFilter *)filter;

/////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and public methods
/////////////////////////////////////////////////////////////////////

@property (readonly, nonatomic) NSUInteger rulesCount;

/// Adds rule to Domain Filter
- (void)addRule:(__unsafe_unretained AERDomainFilterRule *)rule;

/**
 @param domain Domain name
 @return Returns YES if request is filtered
 */
- (BOOL)filteredDomain:(NSString *)domain;
    
@end
