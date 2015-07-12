//
//  NSManagedObject+COOMapping.m
//  CreditCoop
//
//  Created by Nicolas on 02/12/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "NSManagedObject+COOMapping.h"
#import "CreditCoop+Model.h"

@implementation COOUser (COOMapping)
+ (NSDictionary*) coomapping
{
    return @{
    @"mail" : @"email",
    @"label" : @"label",
    @"lastConnectionDate" : @"lastConnectionDate"};
}
@end


@implementation COOAccount (COOMapping)
+ (NSDictionary*) coomapping
{
    return @{
    @"accountNumber" : @"number",
    @"balance" : @"balance",
    @"balanceDate" : @"balanceDate",
    @"category" : @"category",
    @"label" : @"label",
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
    @"operationAmountSign" : @"amount",
    @"operationDate" : [NSString stringWithFormat:@"%@:%@",@"OperationDate",@"date"],
    @"operationLabel1" : @"label1",
    @"operationLabel2" : @"label2",
    };
}
@end
