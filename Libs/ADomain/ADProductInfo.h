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

/////////////////////////////////////////////////////////////////////
#pragma mark -  ADProductInfo
/////////////////////////////////////////////////////////////////////

@protocol ADProductInfoProtocol

/// Returns Product Version.
- (NSString *)version;

/// Returns Product Version with build number. e.g. 1.2.2(88)
- (NSString *)versionWithBuildNumber;

/// Returns Product Version With Build Number for logs. e.g. 1.2.2.88.DEBUG
- (NSString *)buildVersion;

/// Returns build number
- (NSString *)buildNumber;

/// Returns Localized Product Name.
- (NSString *)name;

/// Returns string that represents User-Agent HTTP Header.
- (NSString *)userAgentString;

/// Returns Application ID for local machine.
- (NSString *)applicationID;

@end

/// Provides product information
@interface ADProductInfo : NSObject<ADProductInfoProtocol>

@end
