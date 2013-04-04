//
//  NSManagedObject+COOMapping.m
//  CreditCoop
//
//  Created by Nicolas on 02/12/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "NSManagedObject+COOMapping.h"
#import "CreditCoop.mogenerated.h"
#import "NSValueTransformer+TransformerKit.h"

@implementation COOUser (COOMapping)
+ (NSDictionary*) coomapping
{
    return @{
    @"mail" : COOUserAttributes.email,
    @"label" : COOUserAttributes.label,
    @"lastConnectionDate" : COOUserAttributes.lastConnectionDate};
}
@end


@implementation COOAccount (COOMapping)
+ (NSDictionary*) coomapping
{
    return @{
    @"accountNumber" : COOAccountAttributes.number,
    @"balance" : COOAccountAttributes.balance,
    @"balanceDate" : COOAccountAttributes.balanceDate,
    @"category" : COOAccountAttributes.category,
    @"label" : COOAccountAttributes.label,
    };
}
@end


@implementation COOOperation (COOMapping)
+ (NSDictionary*) coomapping
{
    static dispatch_once_t onceToken;
    static NSDateFormatter * formatter;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"dd.MM.yy";
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr"];
        [NSValueTransformer registerValueTransformerWithName:@"OperationDate" transformedValueClass:[NSDate class]
                          returningTransformedValueWithBlock:^NSDate*(NSString* value) {
                              if([value isKindOfClass:[NSString class]])
                              {
                                  return [formatter dateFromString:value];
                              }
                              return nil;
                          }];

    });
    return @{
    @"operationAmountSign" : COOOperationAttributes.amount,
    @"operationDate" : [NSString stringWithFormat:@"%@:%@",@"OperationDate",COOOperationAttributes.date],
    @"operationLabel1" : COOOperationAttributes.label1,
    @"operationLabel2" : COOOperationAttributes.label2,
    };
}
@end
