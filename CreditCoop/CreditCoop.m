#import "CreditCoop.h"
#import "NSManagedObject+COOMapping.h"
#import "CreditCoop+Requests.h"
#import "CreditCoop+Magic.h"
#import "CreditCoop+Days.h"

@implementation CreditCoop

- (void)logout
{
    [self willChangeValueForKey:@"user"];
    COOUser * user = [self user];
    if(user)
        [self.moc deleteObject:user]; // cascades to accounts and operations
    [self save:NULL];
    [self didChangeValueForKey:@"user"];
    [self clearCookies];    
}

- (void)loginWithUserCode:(NSString* __nonnull)userCode_
                   sesame:(NSString* __nonnull)sesame_
               completion:(CompletionBlock __nonnull)completion_
{
    [self makeRequest:@"banque/mob2/json/user/sesamAuthenticate.action"
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
    [self makeRequest:@"banque/mob2/json/account/detail.action"
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
                      [operation makeAttributes];
                  }
                  [account_ makeDays];

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
