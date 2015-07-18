#import "CreditCoop.h"
#import "NSManagedObject+COOMapping.h"
@import UIKit;

#define CREDITCOOP_HOST @"https://mobile.credit-cooperatif.coop/"

typedef NSError*(^ParsingBlock)(NSDictionary*__nonnull dict);
typedef void(^CompletionBlock)(NSError*__nullable error);

@implementation CreditCoop
{
    NSURLSession * _urlSession;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;
        sessionConfig.HTTPShouldSetCookies = YES;
        sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
        sessionConfig.HTTPAdditionalHeaders = @{@"User-Agent": @"Moz"};
        _urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    }
    return self;
}

- (void)logout
{
    [self willChangeValueForKey:@"user"];
    COOUser * user = [self user];
    if(user)
        [self.moc deleteObject:user]; // cascades to accounts and operations
    [self save:NULL];
    [self didChangeValueForKey:@"user"];
    [_urlSession.configuration.HTTPCookieStorage removeCookiesSinceDate:NSDate.distantPast];
}

- (void)makeRequest:(NSString*__nonnull)path_
      withArguments:(NSDictionary*__nonnull)queryParams
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
    [[_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          error = [self handleResultWithData:data response:response error:error parsing:parsing_];
          [self refreshActivityIndicator];
          dispatch_async(dispatch_get_main_queue(), ^{ completion_(error); });
      }
      ] resume];
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
    [_urlSession getAllTasksWithCompletionHandler:^(NSArray* tasks) {
        UIApplication.sharedApplication.networkActivityIndicatorVisible = tasks.count>0;
    }];
}

- (void)loginWithUserCode:(NSString* __nonnull)userCode_
                   sesame:(NSString* __nonnull)sesame_
               completion:(CompletionBlock __nonnull)completion_
{
    [self makeRequest:@"banque/mob/json/user/sesamAuthenticate.action"
        withArguments:@{@"userCode":userCode_,
                        @"sesam":sesame_}
              parsing:^NSError *(NSDictionary * __nonnull dict) {
                  id userDict = dict[@"beans"][@"user"];
                  if(userDict==nil) {
                      return [NSError errorWithDomain:@"COO" code:4 userInfo:nil];
                  }
                  
                  [self willChangeValueForKey:@"user"];
                  
                  COOUser * user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.moc];
                  [user coo_importValues:userDict];
                  
                  id accounts = userDict[@"accountList"];
                  for (id accountDict in accounts) {
                      COOAccount * account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.moc];
                      [account coo_importValues:accountDict];
                      account.user = user;
                  }
                  [self save:NULL];
                  [self didChangeValueForKey:@"user"];
                  return nil;
              }
           completion:completion_];
}

- (void)refreshAccount:(COOAccount* __nonnull)account_ completion:(CompletionBlock __nonnull)completion_;
{
    [self makeRequest:@"banque/mob/json/account/detail.action"
        withArguments:@{@"accountNumber":account_.number,
                        @"beginIndex":@"0", @"endIndex":@"250"}
              parsing:^NSError*(NSDictionary * __nonnull dict) {
                  if(![dict[@"beans"][@"operationList"] isEqual:dict[@"beans"][@"creditOperationList"]]) {
                      return [NSError errorWithDomain:@"COO" code:5 userInfo:nil];
                  }
                  id operations = dict[@"beans"][@"operationList"];
                  for (id operationDict in operations) {
                      COOOperation * operation = [NSEntityDescription insertNewObjectForEntityForName:@"Operation" inManagedObjectContext:self.moc];
                      [operation coo_importValues:operationDict];
                      operation.account = account_;
                  }
                  return nil;
              }
           completion:completion_];
}

- (void)refreshAllAccounts:(CompletionBlock __nonnull)completion_
{
    for (COOAccount* account in self.user.accounts) {
        [self refreshAccount:account completion:completion_];
    }
}

- (COOUser*)user
{
    NSFetchRequest * userRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    return [self.moc executeFetchRequest:userRequest error:NULL].lastObject;
}

@end
