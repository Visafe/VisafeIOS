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
#import "ACLLogger.h"
#import "ACLFileLogger.h"

int ddLogLevel = DDLogLevelVerbose;

@interface ACLoggerFormatter : DDLogFileFormatterDefault {
    NSDateFormatter *_dateFormatter;
}
    
@end

@implementation ACLoggerFormatter

- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super initWithDateFormatter:dateFormatter];
    _dateFormatter = dateFormatter;
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *dateAndTime = [_dateFormatter stringFromDate:(logMessage->_timestamp)];
    
    NSString* thread = logMessage->_queueLabel ?  [NSString stringWithFormat:@"[%@(%@)]", logMessage->_threadID, logMessage->_queueLabel] :
    [NSString stringWithFormat:@"[%@]", logMessage->_threadID];
    return [NSString stringWithFormat:@"%@ %@  %@", dateAndTime, thread, logMessage->_message];
}

@end

@implementation ACLLogger

static ACLLogger *singletonLogger;

- (id)init{
    
    if (self != singletonLogger)
        return nil;
        
    self = [super init];
    if (self)
    {
        _initialized = NO;
        ddLogLevel = ACLLDefaultLevel;
    }
    
    return self;

}


+ (ACLLogger *)singleton{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singletonLogger = [ACLLogger alloc];
        singletonLogger = [singletonLogger init];
    });
    
    return singletonLogger;
    
}
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS

- (void)initLogger:(NSURL *)folderURL{
    
    if (!_initialized) {
        
        DDLogFileManagerDefault *defaultLogFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[folderURL path]];
        
        _fileLogger = [[ACLFileLogger alloc] initWithLogFileManager:defaultLogFileManager];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        _fileLogger.maximumFileSize = ACL_MAX_LOG_FILE_SIZE;
        NSDateFormatter * dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
        _fileLogger.logFormatter = [[ACLoggerFormatter alloc] initWithDateFormatter: dateFormatter];
        
        [DDLog addLogger:_fileLogger];
#ifdef DEBUG
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDLog addLogger:[DDOSLogger sharedInstance]];
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 20;
#endif
        
        _initialized = YES;
    }
}

#endif

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

- (void)setLogLevel:(ACLLogLevelType)logLevel{
    
    [self willChangeValueForKey:@"logLevel"];
    [self.fileLogger rollLogFileWithCompletionBlock:^{
        ddLogLevel = logLevel;
        [self didChangeValueForKey:@"logLevel"];
    }];
}

- (ACLLogLevelType)logLevel{
    
    switch (ddLogLevel) {
        case ACLLDefaultLevel:
            return ACLLDefaultLevel;
            break;
            
        case ACLLDebugLevel:
            return ACLLDebugLevel;
            break;
            
        default:
            return ACLLDefaultLevel;
            break;
    }
}

- (void)flush{
    
    [DDLog flushLog];
}

@end
