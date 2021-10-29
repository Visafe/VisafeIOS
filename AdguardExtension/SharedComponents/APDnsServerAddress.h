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

#pragma mark - APDnsServerAddress

/**
 APDnsServerAddress represent dns adress
 */

#import "ACObject.h"

@interface APDnsServerAddress : ACObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (instancetype _Nullable) initWithIp:(NSString* _Nonnull)ip port:(NSString* _Nullable)port;

+ (instancetype _Nonnull) addressWithIp:(NSString* _Nonnull) ip port:(NSString* _Nullable) port;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

@property (nonnull) NSString* ip;
@property (nullable) NSString* port;
@property (nonnull, readonly) NSString* upstream;

@end
