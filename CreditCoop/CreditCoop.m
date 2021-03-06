//
//  CreditCoop.m
//  CreditCoop
//
//  Created by Nicolas on 02/12/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

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
         
         COOUser * user = [COOUser insertInManagedObjectContext:self.moc];
         [user setValuesForKeysWithDictionary:userDict withMappingDictionary:[COOUser coomapping]];
         
         id accounts = userDict[@"accountList"];
         for (id accountDict in accounts) {
             COOAccount * account = [COOAccount insertInManagedObjectContext:self.moc];
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
    [request setHTTPBody:[[NSString stringWithFormat:@"accountNumber=%@&socCode=06&balanceDate=13%%2F11%%2F2012+00%%3A00&beginIndex=0&endIndex=250",account.number]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *r, NSData *data, NSError *error)
     {
         id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

         
         assert([dict[@"beans"][@"operationList"] isEqual:dict[@"beans"][@"creditOperationList"]]);
         id operations = dict[@"beans"][@"operationList"];
         for (id operationDict in operations) {
             COOOperation * operation = [COOOperation insertInManagedObjectContext:self.moc];
             [operation setValuesForKeysWithDictionary:operationDict withMappingDictionary:[COOOperation coomapping]];
             operation.account = account;
         }
         [self save:NULL];
     }];
}

- (COOUser*) user
{
    NSFetchRequest * userRequest = [NSFetchRequest fetchRequestWithEntityName:[COOUser entityName]];
    return [[self.moc executeFetchRequest:userRequest error:NULL] lastObject];
}

@end
