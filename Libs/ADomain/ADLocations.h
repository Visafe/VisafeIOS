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
#pragma mark -  ADLocations Constants
/////////////////////////////////////////////////////////////////////

extern const NSString *ADLDefaultApplicationBundleIdentifier;

/////////////////////////////////////////////////////////////////////
#pragma mark -  ADLocations
/////////////////////////////////////////////////////////////////////

/**
    Class retrieves locations on application resources.
 */
@interface ADLocations : NSObject

/// Returns NSURL of application data directory (creates it if it does not
/// exist) or nil if error occurs.
+ (NSURL *)productDataDirectory;


@end
