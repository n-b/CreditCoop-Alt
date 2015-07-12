//
//  NSManagedObject+COOMapping.m
//  CreditCoop
//
//  Created by Nicolas on 02/12/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "NSManagedObject+COOMapping.h"
#import "CreditCoop.mogenerated.h"

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


@interface COOOperationDateTransformer : NSValueTransformer
@end
@implementation COOOperationDateTransformer
+ (Class) transformedValueClass { return [NSDate class]; }

- (id) transformedValue:(id)value
{
    if(![value isKindOfClass:[NSString class]])
        return nil;
    static NSDateFormatter * formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"dd.MM.yy";
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr"];
    });
    return [formatter dateFromString:value];
}
@end

@implementation COOOperation (COOMapping)
+ (NSDictionary*) coomapping
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSValueTransformer setValueTransformer:[COOOperationDateTransformer new] forName:@"OperationDate"];
    });
    return @{
    @"operationAmountSign" : COOOperationAttributes.amount,
    @"operationDate" : [NSString stringWithFormat:@"%@:%@",@"OperationDate",COOOperationAttributes.date],
    @"operationLabel1" : COOOperationAttributes.label1,
    @"operationLabel2" : COOOperationAttributes.label2,
    };
}
@end
