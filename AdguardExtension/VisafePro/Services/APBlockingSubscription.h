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

#import "ACObject.h"
#import "AERDomainFilterRule.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - APBlockingSubscription

/**
 Class, which provides information about subscriptions.
 */
@interface APBlockingSubscription : ACObject<NSCoding>

/**
unique subscription identifier
 */
@property (nonatomic) NSString* uuid;

/**
 subscription name
 */
@property (nonatomic) NSString* name;

/**
 subscription description
 */
@property (nonatomic) NSString* subscriptionDescription;

/**
 subscription update date
 */
@property (nonatomic) NSDate* updateDate;

/**
 url for downloading rules
 */
@property (nonatomic) NSString* url;

/**
 sum of rules and hosts counts
 */
@property (nonatomic) NSInteger rulesCount;

/**
 array of rules strings
 */
@property (nonatomic) NSArray<NSString*> *rules;

/**
 hosts dictionary
 */
@property (nonatomic) NSDictionary<NSString*, NSString*> *hosts;

/**
 returns meta info for subscription without rules end hosts.
 */
- (instancetype) meta;

@end
