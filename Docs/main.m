//
//  main.m
//  creditcooptool
//
//  Created by Nicolas on 02/12/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CREDITCOOP_HOST @"https://mobile.credit-cooperatif.coop/"

NSDictionary * DetailsOfAccount(NSString* accoundNumber)
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CREDITCOOP_HOST"banque/mob/json/account/detail.action"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"Moz" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:[[NSString stringWithFormat:@"accountNumber=%@&socCode=06&balanceDate=13%%2F11%%2F2012+00%%3A00&beginIndex=0&endIndex=250",accoundNumber] dataUsingEncoding:NSUTF8StringEncoding]];

    NSHTTPURLResponse * response;
    NSError * error;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSLog(@"  %@ operations", dict[@"beans"][@"totalListNumber"]);

    assert([dict[@"beans"][@"operationList"] isEqual:dict[@"beans"][@"creditOperationList"]]);
    id operations = dict[@"beans"][@"operationList"];
    for (id operation in operations) {
        NSLog(@"   %@ : %@ \"%@\" : %@",operation[@"operationDate"],operation[@"operationLabel1"],operation[@"operationLabel2"],operation[@"operationAmountSign"]);
    }
    return nil;
}


NSDictionary * LoginToCreditCooperatif(NSString* userCode, NSString* sesame)
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CREDITCOOP_HOST"banque/mob/json/user/sesamAuthenticate.action"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"Moz" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:[[NSString stringWithFormat:@"userCode=%@&sesam=%@",userCode,sesame] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse * response;
    NSError * error;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    id user = dict[@"beans"][@"user"];
    id accounts = user[@"accountList"];
    NSLog(@"Hello %@",user[@"label"]);
    NSLog(@"%d accounts : ",(int)[accounts count]);
    for (id account in accounts) {
        NSLog(@"%@ %@ (%@) : %@",account[@"category"], account[@"accountNumber"], account[@"balanceDate"], account[@"balance"]);
        DetailsOfAccount(account[@"accountNumber"]);
    }
    
    return nil;
}


int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        LoginToCreditCooperatif(@"<login>", @"<pass>");
        
    }
    return 0;
}

