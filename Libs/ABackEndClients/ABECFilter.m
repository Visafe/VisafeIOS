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

#import <objc/runtime.h>
#import "ACommons/ACLang.h"
#import "ABECFilter.h"
#import "ABECConstants.h"
#import "ASDFilterObjects.h"
#import "ABECRequest.h"
#import "ABECFilterParsers.h"
#import "ADProductInfo.h"
#import "ADLocales.h"

@implementation ABECFilterClientMetadata
@end
@implementation ABECFilterClientLocalization
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - NSURLSessionTask category (add representation object)


@interface NSURLSessionTask (internal)
@property (nonatomic, strong) id representationObject;
@end

@implementation NSURLSessionTask (internal)

@dynamic representationObject;

- (void)setRepresentationObject:(id)object {
    objc_setAssociatedObject(self, @selector(representationObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)representationObject {
    return objc_getAssociatedObject(self, @selector(representationObject));
}
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClient


NSString *ABECFilterError = @"ABECFilterError";


NSString *FilterUrlStart = ABEC_FILTER_URL_BASE @"filters/";
NSString *FilterUrlEnd = @"_optimized.txt";

NSString *FilterMetadataUrl = ABEC_FILTER_URL_BASE @"filters.js";
NSString *FilterI18nUrl = ABEC_FILTER_URL_BASE @"filters_i18n.js";

NSString *VERSION_PARAM = @"v";
NSString *USER_ID_PARAM = @"cid";
NSString *SYSTEM_LANGUAGE_PARAM = @"lang";
NSString *PRODUCT_TYPE_PARAM = @"id";

#ifdef PRO
NSString *PRODUCT_TYPE = @"ios_pro";
#else
NSString *PRODUCT_TYPE = @"ios";
#endif


@implementation ABECFilterClient {
    
    BOOL _asyncInit;
    BOOL _background;
    NSURLSession *_backgroundSession;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

static ABECFilterClient *ABECFilterSingleton;

+ (ABECFilterClient *)singleton{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ABECFilterSingleton = [ABECFilterClient alloc];
        ABECFilterSingleton = [ABECFilterSingleton init];
    });
    
    return ABECFilterSingleton;
    
}

- (id)init {
    
    if (self != ABECFilterSingleton) {
        return nil;
    }
    self = [super init];
    if (self) {
        
        _asyncInit = NO;
        _background = NO;
    }
    
    return self;
}

+ (NSString *)reachabilityHost{
    
    return [[NSURL URLWithString:ABEC_FILTER_URL_BASE] host];
;
}


/////////////////////////////////////////////////////////////////////
#pragma mark  Properties and public methods

- (NSError *)filtersRequestWithFilterIds:(NSArray <NSNumber *>*)filterIds {
    
    @synchronized (ABECFilterSingleton) {
        
        NSError *error = [self checkConditionForAsync];
        if (error) {
            return error;
        }
        
        for (NSNumber *filterId in filterIds) {
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", FilterUrlStart, filterId, FilterUrlEnd]];
            NSURLRequest *sURLRequest = [[ABECRequest
                                        getRequestForURL:url
                                        parameters:nil] copy];
            
            NSURLSessionDownloadTask *currentTask = [_backgroundSession downloadTaskWithRequest:sURLRequest];
            [currentTask resume];
        }
        
        DDLogDebugTrace();
        DDLogDebug(@"filters requested");
        
        return nil;
    }
   
}

- (NSError *)metadataRequest {
    
    @synchronized (ABECFilterSingleton) {
        
        NSError *error = [self checkConditionForAsync];
        if (error) {
            return error;
        }
        
        NSURLRequest *sURLRequest = [[self createMetadataRequest] copy];
        
        NSURLSessionDownloadTask *currentTask = [_backgroundSession downloadTaskWithRequest:sURLRequest];
        [currentTask resume];

        DDLogDebugTrace();
        DDLogDebug(@"metadata requested");
        
        return nil;
    }
}

- (NSError *)i18nRequest {
    
    @synchronized (ABECFilterSingleton) {
        
        NSError *error = [self checkConditionForAsync];
        if (error) {
            return error;
        }
        
        NSURLRequest *sURLRequest = [[ABECRequest getRequestForURL:[NSURL URLWithString:FilterI18nUrl] parameters:nil] copy];
        
        NSURLSessionDownloadTask *currentTask = [_backgroundSession downloadTaskWithRequest:sURLRequest];
        [currentTask resume];
        
        DDLogDebugTrace();
        DDLogDebug(@"i18n requested");
        return nil;
    }
}

- (ASDFilter *)filterWithFilterId:(NSNumber *)filterId{
    @autoreleasepool {
        
        if (!filterId) {
            return nil;
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", FilterUrlStart, filterId, FilterUrlEnd]];
        ABECRequest *sURLRequest = [ABECRequest
                                    getRequestForURL:url
                                    parameters:nil];
        
        PlainFilterParser *parser = [PlainFilterParser new];
        
        parser.filterId = filterId;
        
        parser = (PlainFilterParser *)[self loadEntityWithRequest:sURLRequest parser:parser];
        
        return [parser filter];
    }
}

- (ABECFilterClientMetadata *)loadMetadataWithTimeoutInterval:(NSNumber*)timeoutInterval{
    @autoreleasepool {
        
        ABECRequest *sURLRequest = [self createMetadataRequest];
        if(timeoutInterval){
            sURLRequest.timeoutInterval = [timeoutInterval doubleValue];
        }
        
        JSONMetadataParser *parser = [JSONMetadataParser new];
        
        parser = (JSONMetadataParser *)[self loadEntityWithRequest:sURLRequest parser:parser];
        
        if (parser == nil) {
            return  nil;
        }
        
        ABECFilterClientMetadata *result = [ABECFilterClientMetadata new];
        result.filters = [parser filterMetadataList];
        result.groups = [parser groupList];
        return result;
    }
}

- (ABECFilterClientLocalization *)loadI18nWithTimeoutInterval:(NSNumber *)timeoutInterval {
    @autoreleasepool {
        
        ABECRequest *sURLRequest = [ABECRequest getRequestForURL:[NSURL URLWithString:FilterI18nUrl] parameters:nil];
        if(timeoutInterval){
            sURLRequest.timeoutInterval = [timeoutInterval doubleValue];
        }
        
        JSONI18nParser *parser = [JSONI18nParser new];
        
        parser = (JSONI18nParser *)[self loadEntityWithRequest:sURLRequest parser:parser];
        
        if (parser == nil) {
            return  nil;
        }
        
        ABECFilterClientLocalization *result = [ABECFilterClientLocalization new];
        result.filters = [parser filtersI18n];
        result.groups = [parser groupsI18n];
        return result;
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Async support methods
- (void)resetSession:(NSString *)sessionId
       updateTimeout:(NSTimeInterval)updateTimeout
            delegate:(id<ABECFilterAsyncDelegateProtocol>)delegate
     completionBlock:(void (^)(BOOL updateInProgress))block {
    
    @synchronized(ABECFilterSingleton) {
        
        DDLogDebug(@"(ABECFilterClient) setupWithSessionId:");

        self.delegate = delegate;
        if (! _backgroundSession) {
            
            _backgroundSession = [self backgroundSession:sessionId updateTimeout:updateTimeout sessionDelegate:self];
            _asyncInit = YES;
        }
        [_backgroundSession getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {

#ifdef DEBUG
            DDLogDebugTrace();
            DDLogDebug(@"Task count: %tu", tasks.count);
            NSArray *stateName = @[    @"Running",                     /* The task is currently being serviced by the session */
                                       @"Suspended",
                                       @"Canceling",               /* The task has been told to cancel.  The session will receive a URLSession:task:didCompleteWithError: message. */
                                       @"Completed"                   /* The task has completed and the session will receive no more delegate notifications */
                                       ];
            for (NSURLSessionTask *item in tasks) {
                
                DDLogDebug(@"Task \"%@\" status: %@", item.originalRequest.URL, stateName[item.state]);
                [item cancel];
            }
#endif
            if (block) {
                block(false);
            }
        }];
    }
}

- (void)handleBackgroundWithSessionId:(NSString *)sessionId
                        updateTimeout:(NSTimeInterval)updateTimeout
                             delegate:(id<ABECFilterAsyncDelegateProtocol>)delegate {
    DDLogDebug(@"(ABECFilterClient) handleBackgroundWithSessionId:delegate: %@", delegate);
    
    @synchronized(ABECFilterSingleton) {
        self.delegate = delegate;
        if (! _backgroundSession) {
            _backgroundSession = [self backgroundSession:sessionId updateTimeout:updateTimeout sessionDelegate:self];
        }
        _asyncInit = YES;
        _background = YES;
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Download session delegate methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL {
    
    DDLogInfo(@"(ABECFilterClient) URLSession:downloadTask:didFinishDownloadingToURL:. Request URL: %@", [[downloadTask originalRequest] URL]);
    [self processDownloadTask:downloadTask didFinishDownloadURL:downloadURL];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    DDLogInfo(@"(ABECFilterClient) URLSession:task:didCompleteWithError: %@. Request URL: %@", error, [[task originalRequest] URL]);
    [self processDownloadTask:(NSURLSessionDownloadTask *)task completeWithError:error];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
    DDLogInfo(@"(ABECFilterClient) URLSessionDidFinishEventsForBackgroundURLSession:");
    
    [self.delegate filterClientFinishedDownloading:self error:nil];
}

#pragma clang diagnostic pop

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    
    DDLogInfo(@"(ABECFilterClient) URLSession:didBecomeInvalidWithError: %@", error);
    
      [self.delegate filterClientFinishedDownloading:self error:error];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

/**
 Loads entity from back-end server.
 
 @param request Request, which contains parameters and url for getting entity.
 @param parser Parser for converting data, which loaded from back-end, into object.
 @return Returns parser object, which contains entity(ies) object(s), or nil if error occures.
 */
- (id<ParserProtocol>)loadEntityWithRequest:(__unsafe_unretained ABECRequest *)request parser:(__unsafe_unretained id<ParserProtocol>)parser {
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    // here we check for any returned NSError from the server, "and" we also check for any http response errors
    if (error != nil){
        DDLogError(@"Error loading data from \"%@\":%@", request, [error localizedDescription]);
        DDLogErrorTrace();
    }
    else {
        // check for any response errors
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] == 200) {
            
            if (![parser parseWithData:data]) {
                
                DDLogError(@"Error when loading loading data from \"%@\". Can't parse data.", request);
                DDLogErrorTrace();
                return nil;
            }
            
            return parser;
        }
        else {
            
            DDLogError(@"Http Error when loading data from \"%@\". Http Status:%li", request, [httpResponse statusCode]);
            DDLogErrorTrace();
        }
    }
    
    return nil;
}

#pragma clang diagnostic pop

/**
 Getting background session for downloading tasks.

 @return Background session.
 */
- (NSURLSession *)backgroundSession:(NSString *)sessionId updateTimeout:(NSTimeInterval)updateTimeout sessionDelegate:(id)sessionDelegate
{
    
    if ([NSString isNullOrEmpty:sessionId] || ! updateTimeout) {
        return nil;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sessionId];
    configuration.networkServiceType = NSURLNetworkServiceTypeBackground;
    configuration.timeoutIntervalForRequest = ABEC_BACKEND_READ_TIMEOUT;
    configuration.timeoutIntervalForResource = updateTimeout;
    
    return [NSURLSession sessionWithConfiguration:configuration delegate:sessionDelegate delegateQueue:nil];
}

- (NSError *)checkConditionForAsync {
    if (! _asyncInit) {
        DDLogError(@"(ABECFilterClient) Async operations can't be performed. You need setup it before.");
        DDLogErrorTrace();
        return [NSError errorWithDomain:ABECFilterError code:ABECFILTER_ERROR_ASYNC_NOTINIT userInfo:nil];
    }
    
    return nil;
}

- (void)processDownloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadURL:(NSURL *)downloadURL {
    
    @synchronized(ABECFilterSingleton) {
        
        NSURL *requestUrl = [[downloadTask originalRequest] URL];
        if ([[requestUrl absoluteString] hasPrefix:FilterMetadataUrl]) {
            
            // was metadata request
            
            DDLogInfo(@"(ABECFilterClient) finishDownload: METADATA");
            
            NSData *data = [NSData dataWithContentsOfURL:downloadURL];
            if (data) {
                
                JSONMetadataParser *parser = [JSONMetadataParser new];
                
                if (![parser parseWithData:data]) {
                    
                    DDLogError(@"Error when loading metadata data. Can't parse data.");
                    DDLogErrorTrace();
                    return;
                }
                
                ABECFilterClientMetadata *metadata = [ABECFilterClientMetadata new];
                metadata.filters = [parser filterMetadataList];
                metadata.groups = [parser groupList];
                
                downloadTask.representationObject = metadata;
            }
        }
        else if ([[requestUrl absoluteString] hasPrefix:FilterI18nUrl]) {
            
            // was i18n request
            
            DDLogInfo(@"(ABECFilterClient) finishDownload: I18N");
            
            NSData *data = [NSData dataWithContentsOfURL:downloadURL];
            if (data) {
                
                JSONI18nParser *parser = [JSONI18nParser new];
                
                if (![parser parseWithData:data]) {
                    
                    DDLogError(@"Error when loading i18n data. Can't parse data.");
                    DDLogErrorTrace();
                    return;
                }
                
                ABECFilterClientLocalization *i18n = [ABECFilterClientLocalization new];
                i18n.filters = [parser filtersI18n];
                i18n.groups = [parser groupsI18n];
                
                downloadTask.representationObject = i18n;
            }
        }
        else if ([[requestUrl absoluteString] hasPrefix:FilterUrlStart]) {
            
            //was filter request
            
            DDLogInfo(@"(ABECFilterClient) finishDownload: Filter");
            
            NSNumber *filterId = [self filterIdFromRequestUrl:requestUrl];
            if (!filterId) {
                return;
            }
            
            NSData *data = [NSData dataWithContentsOfURL:downloadURL];
            if (data) {
                
                PlainFilterParser *parser = [PlainFilterParser new];
                
                parser.filterId = filterId;
                
                if (![parser parseWithData:data]) {
                    
                    DDLogError(@"Error when loading filter data. Can't parse data.");
                    DDLogErrorTrace();
                    return;
                }
                
                downloadTask.representationObject = [parser filter];
            }
        }
    }
}

- (void)processDownloadTask:(NSURLSessionDownloadTask *)downloadTask completeWithError:(NSError *)error {
    
    @synchronized(ABECFilterSingleton) {
        
        NSURL *requestUrl = [[downloadTask originalRequest] URL];
        if ([[requestUrl absoluteString] hasPrefix:FilterMetadataUrl]) {
            
            // was metadata request
            
            DDLogInfo(@"(ABECFilterClient) complete: METADATA");
            
            if (error) {
                DDLogError(@"(ABECFilterClient) ASync. Error loading metadata info:%@", [error localizedDescription]);
                DDLogErrorTrace();
            }
            // call from task completed
            
            [self.delegate filterClient:self metadata:downloadTask.representationObject];
        }
        else if ([[requestUrl absoluteString] hasPrefix:FilterI18nUrl]) {
            
            // was i18n request
            
            DDLogInfo(@"(ABECFilterClient) complete: I18N");
            
            if (error) {
                DDLogError(@"(ABECFilterClient) ASync. Error loading i18n info:%@", [error localizedDescription]);
                DDLogErrorTrace();
            }
            
            [self.delegate filterClient:self localizations:downloadTask.representationObject];
            
        }
        else if ([[requestUrl absoluteString] hasPrefix:FilterUrlStart]) {
            
            //was filter request
            
            DDLogInfo(@"(ABECFilterClient) complete: Filter");
            
            if (error) {
                DDLogError(@"(ABECFilterClient) ASync. Error loading filter data:%@", [error localizedDescription]);
                DDLogErrorTrace();
            }
            
            ASDFilter *filter = downloadTask.representationObject;
            if ([self.delegate filterClient:self filterId:filter.filterId  filter:filter] && !_background) {
                
                [self.delegate filterClientFinishedDownloading:self error:nil];
            }
        }
    }
}

- (NSNumber *)filterIdFromRequestUrl:(NSURL *)requestUrl {
    
    NSString *value = requestUrl.absoluteString;
    
    if (value.length > FilterUrlStart.length) {
        
        value = [value substringFromIndex:FilterUrlStart.length];
        if (value.length > FilterUrlEnd.length) {
            
            value = [value substringToIndex:(value.length - FilterUrlEnd.length)];
            
            return @([value integerValue]);
        }
    }
    
    return nil;
 }

- (ABECRequest*) createMetadataRequest {
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    
    params[VERSION_PARAM] = [[ADProductInfo new] version];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
    params[USER_ID_PARAM] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
#endif
    
    params[PRODUCT_TYPE_PARAM] = PRODUCT_TYPE;
    params[SYSTEM_LANGUAGE_PARAM] = [NSString stringWithFormat:@"%@-%@", [ADLocales lang], [ADLocales region]];
    
    ABECRequest *request = [ABECRequest getRequestForURL:[NSURL URLWithString:FilterMetadataUrl] parameters:params];
    
    return request;
}

@end
