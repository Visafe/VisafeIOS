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
#import "APDnsServerAddress.h"

/**
 Tag that server object contains only description properties, 
 it has no remote DNS servers. It is fake server.
 */
extern NSString * _Nonnull APDnsServerTagLocal;

/**
 Visafe dns uuid
 */
extern NSString * _Nonnull APDnsServerUUIDVisafe;

/**
 Visafe family dns uuid
 */
extern NSString * _Nonnull APDnsServerUUIDVisafeFamily;

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsServerObject

/**
 Representation object for custom DNS server.
 */
@interface APDnsServerObject  : ACObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id _Nullable)initWithUUID:(NSString * _Nonnull)uuid
                        name:(NSString * _Nonnull)serverName
                 description:(NSString * _Nonnull)serverDescription
                 ipAddresses:(NSString * _Nonnull)ipAddresses;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

/**
 Title of the object
 */
@property (nonnull) NSString *serverName;
/**
 Description of the object
 */
@property (nonnull) NSString *serverDescription;
/**
 If set to YES, then this server is not predefined and it may be edited or removed.
 */
@property BOOL editable;
/**
 Array, which contains ipV4 addresses in form of strings.
 */
@property (nonnull, nonatomic) NSArray <APDnsServerAddress *> *ipv4Addresses;
/**
 Array, which contains ipV6 addresses in form of strings.
 */
@property (nonnull, nonatomic) NSArray <APDnsServerAddress *> *ipv6Addresses;

/**
 Field, which may contain special labels about server, for example APDnsServerTagLocal.
 */
@property (nullable) NSString *tag;

/**
 Field, which contains unique id
 */
@property (nullable, readonly) NSString *uuid;

@property (nonatomic, nullable) NSNumber* isDnsCrypt;

@property (nonatomic, nullable) NSString* dnsCryptId;
@property (nonatomic, nullable) NSString* dnsCryptLocation;
@property (nonatomic, nullable) NSString* dnsCryptCoordinates;
@property (nonatomic, nullable) NSString* dnsCryptURL;
@property (nonatomic, nullable) NSString* dnsCryptVersion;
@property (nonatomic, nullable) NSString* dnsCryptDNSSECValidation;
@property (nonatomic, nullable) NSString* dnsCryptNoLogs;
@property (nonatomic, nullable) NSString* dnsCryptNamecoin;
@property (nonatomic, nullable) NSString* dnsCryptResolverAddress;
@property (nonatomic, nullable) NSString* dnsCryptProviderName;
@property (nonatomic, nullable) NSString* dnsCryptProviderPublicKey;
@property (nonatomic, nullable) NSString* dnsCryptProviderPublicKeyTXTRecord;

/**
 Returns list of all IPs (ipV4 and ipV6) separated by '\n'.

 @return IPs addresses or empty string.
 */
- (NSString * _Nonnull)ipAddressesAsString;
/**
 Parses input string and fills appropriate properties (`ipv4Addresses`, `ipv6Addresses`).
 
 @param ipAddresses String for parsing.
 */
- (void)setIpAddressesFromString:(NSString  * _Nonnull)ipAddresses;

/**
 compare the equivalence of the settings
 */
- (BOOL) settingsEqual:(APDnsServerObject* _Nonnull) server;

@end
