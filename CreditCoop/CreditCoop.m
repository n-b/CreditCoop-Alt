#import "CreditCoop.h"
#import "NSManagedObject+COOMapping.h"

#define CREDITCOOP_HOST @"https://mobile.credit-cooperatif.coop/"

@implementation CreditCoop

- (void) logout
{
    [self willChangeValueForKey:@"user"];
    COOUser * user = [self user];
    if(user)
        [self.moc deleteObject:user];
    [self save:NULL];
    [self didChangeValueForKey:@"user"];
}

- (void) loginWithUserCode:(NSString*)userCode sesame:(NSString*)sesame completion:(void(^)(NSString* error))completion
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CREDITCOOP_HOST"banque/mob/json/user/sesamAuthenticate.action"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"Moz" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:[[NSString stringWithFormat:@"userCode=%@&sesam=%@",userCode,sesame] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *r, NSData *data, NSError *error)
     {
         if(error) {
             completion([error localizedDescription]);
             return;
         }
         id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         id errors = dict[@"errors"];
         id userDict = dict[@"beans"][@"user"];
         if(userDict==nil || [errors count]>0) {
             if([errors count])
                 completion(errors[0]);
             else
                 completion(@"Login Failed");
             return;
         }
         
         [self willChangeValueForKey:@"user"];
         
         COOUser * user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.moc];
         [user setValuesForKeysWithDictionary:userDict withMappingDictionary:[COOUser coomapping]];
         
         id accounts = userDict[@"accountList"];
         for (id accountDict in accounts) {
             COOAccount * account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.moc];
             [account setValuesForKeysWithDictionary:accountDict withMappingDictionary:[COOAccount coomapping]];
             account.user = user;
             [self refreshAccount:account];
         }
         [self save:NULL];
         [self didChangeValueForKey:@"user"];

         completion(nil);
     }];
}

- (void) refreshAccount:(COOAccount*)account
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CREDITCOOP_HOST"banque/mob/json/account/detail.action"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"Moz" forHTTPHeaderField:@"User-Agent"];
    // socCode & balanceDate params seem useless.
    // beginIndex and endIndex work, but the webservice will not go further back than the 250 most recent operations.
    [request setHTTPBody:[[NSString stringWithFormat:@"accountNumber=%@&beginIndex=0&endIndex=250",account.number]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *r, NSData *data, NSError *error)
     {
         id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

         
         assert([dict[@"beans"][@"operationList"] isEqual:dict[@"beans"][@"creditOperationList"]]);
         id operations = dict[@"beans"][@"operationList"];
         for (id operationDict in operations) {
             COOOperation * operation = [NSEntityDescription insertNewObjectForEntityForName:@"Operation" inManagedObjectContext:self.moc];
             [operation setValuesForKeysWithDictionary:operationDict withMappingDictionary:[COOOperation coomapping]];
             operation.account = account;
         }
         [self save:NULL];
     }];
}

- (COOUser*) user
{
    NSFetchRequest * userRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    return [[self.moc executeFetchRequest:userRequest error:NULL] lastObject];
}

@end
