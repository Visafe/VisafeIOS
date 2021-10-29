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

#include <ifaddrs.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - ACNIPUtils

/**
 utilities for get availible network interfaces
 
 */
@interface ACNIPUtils  : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

+ (BOOL) isIpv6Available;
+ (BOOL) isIpv4Available;
+ (void) enumerateNetworkInterfacesWithProcessingBlock:(void (^)(struct ifaddrs *addr, BOOL *stop))processingBlock;
+ (void) enumerateSystemDnsWithProcessingBlock:(void (^)(NSString *ip, NSString* port, BOOL ipv4, BOOL *stop))processingBlock;
+ (NSData*) ipv4StringToData: (NSString*)ipv4String;
+ (NSData*) ipv6StringToData: (NSString*)ipv6String;
+ (NSString*) ipv6DataToString: (NSData*) ipv6Data;
+ (NSString*) ipv4DataToString: (NSData*) ipv4Data;

@end



