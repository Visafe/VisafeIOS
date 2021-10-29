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
#import "Visafe-Swift.h"
#import "APDnsLogTable.h"

@implementation APDnsLogTable

@synthesize rowid;

- (instancetype)initWithTimestamp:(NSTimeInterval)timestamp record:(DnsLogRecord *)record {
    self = [super init];
    self.timeStamp = timestamp;
    self.record = record;
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString: @"record"] && value == nil) {
        self.record = [[DnsLogRecord alloc] initWithDomain:@"" date:[NSDate date] elapsed:0 type:@"" answer:@"" server:@"" upstreamAddr:@"" bytesSent:0 bytesReceived:0 status:DnsLogRecordStatusProcessed userStatus:DnsLogRecordUserStatusNone blockRules:nil matchedFilterIds:nil originalAnswer:nil answerStatus:nil];
    }
    else [super setValue:value forKey:key];
}

@end
