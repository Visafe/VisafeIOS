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

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

/////////////////////////////////////////////////////////////////////
#pragma mark - ACSSystemUtils
/////////////////////////////////////////////////////////////////////

/**
    Contains utilities for wrapping unix functions.
 */
@interface ACSSystemUtils : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
#pragma mark Only iOS code here
/////////////////////////////////////////////////////////////////////
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS

/**
 Display simple alert with one button (Ok)
 */
+ (void)showSimpleAlertForController:(nonnull UIViewController *)controller withTitle:(nullable NSString *)title message:(nullable NSString *)message;

/**
 Display simple alert with one button (Ok) with completionHandler
 */
+ (void)showSimpleAlertForController:(nonnull UIViewController *)controller withTitle:(nullable NSString *)title message:(nullable NSString *)message completion:(nullable void (^)(void))completion;

/////////////////////////////////////////////////////////////////////
#pragma mark Only OS X code here
/////////////////////////////////////////////////////////////////////
#elif TARGET_OS_MAC


/**
    Checks that current process have root privileges.
 */
+ (BOOL)rootPrivileges;

/**
    Launches command line utility.
    @param utilPath Full path of cli utility. You MUST specify full path.
    @param arguments array with NSString objects, may be nil.
    @param outputData returning parameter. Set to NULL if we do not need it.
 */
+ (int)cliUtil:(nonnull NSString *)utilPath arguments:(nullable NSArray *)arguments outputData:(NSData * _Nullable * _Nullable )outputData;

/**
    Launches command line utility.
    @param utilPath Full path of cli utility. You MUST specify full path.
    @param arguments array with NSString objects, may be nil.
    @param output returning parameter. Set to NULL if we do not need it.
 */
+ (int)cliUtil:(nonnull NSString *)utilPath arguments:(nullable NSArray *)arguments output:(NSString * _Nullable * _Nonnull)output;

/////////////////////////////////////////////////////////////////////
#pragma mark Common code here
/////////////////////////////////////////////////////////////////////
#endif

/**
    Returns UUID (GUID).
 */
+ (nonnull NSString *)createUUID;

/**
 Execute block on main queue synchronously.

 @param block Block of a code.
 */
+ (void)callOnMainQueue:(nonnull dispatch_block_t)block;

@end
