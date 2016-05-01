#import "CreditCoop+Requests.h"
@import ObjectiveC;
@import UIKit;

#define CREDITCOOP_HOST @"https://mobile.credit-cooperatif.coop/"

@implementation CreditCoop (Requests)

- (NSURLSession *)urlSession
{
    NSURLSession * session = objc_getAssociatedObject(self, _cmd);
    if(!session) {
        NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;
        sessionConfig.HTTPShouldSetCookies = YES;
        sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
        sessionConfig.HTTPAdditionalHeaders = @{@"User-Agent": @"Moz"};
        session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        objc_setAssociatedObject(self, _cmd, session, OBJC_ASSOCIATION_RETAIN);
    }
    return session;
}

- (void)makeRequest:(NSString*__nonnull)path_
      withArguments:(NSDictionary<NSString*,NSString*>*__nonnull)queryParams
            parsing:(ParsingBlock __nonnull)parsing_
         completion:(CompletionBlock __nonnull)completion_
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[CREDITCOOP_HOST stringByAppendingString:path_]]];
    request.HTTPMethod = @"POST";
    NSMutableArray * queryItems = [NSMutableArray new];
    for (NSString * param in queryParams) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:param value:queryParams[param]]];
    }
    NSURLComponents * comps = [NSURLComponents new];
    comps.queryItems = queryItems;
    request.HTTPBody = [comps.query dataUsingEncoding:NSUTF8StringEncoding];
    [[self.urlSession dataTaskWithRequest:request
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *networkError) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSError * error = [self handleResultWithData:data response:response error:networkError parsing:parsing_];
                                [self refreshActivityIndicator];
                                completion_(error);
                            });
                        }] resume];
    [self refreshActivityIndicator];
}

- (NSError* __nullable)handleResultWithData:(NSData* __nullable)data_
                                   response:(NSURLResponse* __nullable)response_
                                      error:(NSError* __nullable)error_
                                    parsing:(ParsingBlock __nonnull)parsing_
{
    if(error_) return error_;
    if(data_.length==0) return [NSError errorWithDomain:@"COO" code:1 userInfo:nil];
    id dict = [NSJSONSerialization JSONObjectWithData:data_ options:0 error:&error_];
    if(dict==nil && error_.domain == NSCocoaErrorDomain && error_.code == NSPropertyListReadCorruptError) {
        error_ = nil;
        NSString * text = [[NSString alloc] initWithData:data_ encoding:NSISOLatin1StringEncoding];
        NSData * goodData = [text dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:goodData options:0 error:&error_];
    }
    if(error_) return error_;
    if(dict==nil) return [NSError errorWithDomain:@"COO" code:2 userInfo:nil];
    NSArray* errors = dict[@"errors"];
    // "error.authenticationFail" in the array
    if(errors.count) return [NSError errorWithDomain:@"COO" code:3 userInfo:@{NSLocalizedDescriptionKey:@"Login failed"}];
    error_ = parsing_(dict);
    if(error_) return error_;
    [self save:&error_];
    if(error_) return error_;
    return nil;
}

- (void)refreshActivityIndicator
{
    [self.urlSession getAllTasksWithCompletionHandler:^(NSArray* tasks) {
        UIApplication.sharedApplication.networkActivityIndicatorVisible = tasks.count>0;
    }];
}

- (void)clearCookies
{
    [self.urlSession.configuration.HTTPCookieStorage removeCookiesSinceDate:NSDate.distantPast];
}

@end
