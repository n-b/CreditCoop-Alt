#import "CreditCoop.h"
#import "NSManagedObject+COOMapping.h"
@import UIKit;

#define CREDITCOOP_HOST @"https://mobile.credit-cooperatif.coop/"

typedef NSError*__nullable(^CompletionBlock)(NSDictionary*__nonnull dict);

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

- (void)makeRequest:(NSString*)path_ withArguments:(NSDictionary*)queryParams
         completion:(CompletionBlock)completion_
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
          error = [self handleResultWithData:data response:response error:error completion:completion_];
          [self refreshActivityIndicator];
      }
      ] resume];
    [self refreshActivityIndicator];
}

- (NSError*)handleResultWithData:(NSData *)data_ response:(NSURLResponse *)response_ error:(NSError *)error_ completion:(CompletionBlock)completion_
{
    if(error_) return error_;
    if(data_.length==0) return [NSError errorWithDomain:@"OUCH" code:2 userInfo:nil];
    id dict = [NSJSONSerialization JSONObjectWithData:data_ options:0 error:&error_];
    if(error_) return error_;
    if(dict==nil) return [NSError errorWithDomain:@"OUCH" code:2 userInfo:nil];
    NSArray* errors = dict[@"errors"];
    if(errors.count) return [NSError errorWithDomain:@"OUCH" code:2 userInfo:nil];
    error_ = completion_(dict);
    if(error_) return error_;
    [self save:&error_];
    if(error_) return error_;
    return nil;
}

- (void)notifyError:(NSError*)error_
{
    [[[UIAlertView alloc] initWithTitle:error_.localizedDescription
                                message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void)refreshActivityIndicator
{
    [_urlSession getAllTasksWithCompletionHandler:^(NSArray* tasks) {
        UIApplication.sharedApplication.networkActivityIndicatorVisible = tasks.count>0;
    }];
}

- (void)loginWithUserCode:(NSString*)userCode_ sesame:(NSString*)sesame_ completion:(void(^)(BOOL success))completion_
{
    [self makeRequest:@"banque/mob/json/user/sesamAuthenticate.action"
        withArguments:@{@"userCode":userCode_,
                        @"sesam":sesame_}
           completion:^NSError*__nullable(NSDictionary*__nonnull dict)
    {
         id userDict = dict[@"beans"][@"user"];
         if(userDict==nil) {
             return [NSError errorWithDomain:@"OUCH" code:2 userInfo:nil];
         }
         
         [self willChangeValueForKey:@"user"];
         
         COOUser * user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.moc];
         [user coo_importValues:userDict];
         
         id accounts = userDict[@"accountList"];
         for (id accountDict in accounts) {
             COOAccount * account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.moc];
             [account coo_importValues:accountDict];
             account.user = user;
             [self refreshAccount:account];
         }
         [self save:NULL];
         [self didChangeValueForKey:@"user"];
         return nil;
     }];
}

- (void)refreshAccount:(COOAccount*)account_
{
    [self makeRequest:@"banque/mob/json/account/detail.action"
        withArguments:@{@"accountNumber":account_.number,
                        @"beginIndex":@"0", @"endIndex":@"250"}
           completion:^NSError*__nullable(NSDictionary*__nonnull dict)
     {
               if(![dict[@"beans"][@"operationList"] isEqual:dict[@"beans"][@"creditOperationList"]]) {
                   return [NSError errorWithDomain:@"OUCH" code:3 userInfo:nil];
               }
               id operations = dict[@"beans"][@"operationList"];
               for (id operationDict in operations) {
                   COOOperation * operation = [NSEntityDescription insertNewObjectForEntityForName:@"Operation" inManagedObjectContext:self.moc];
                   [operation coo_importValues:operationDict];
                   operation.account = account_;
               }
               return nil;
           }];
}

- (COOUser*)user
{
    NSFetchRequest * userRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    return [self.moc executeFetchRequest:userRequest error:NULL].lastObject;
}

@end
