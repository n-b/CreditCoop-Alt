#import "CreditCoop+Model.h"

@implementation COOUser
@dynamic email, label, lastConnectionDate, accounts;
@end

@implementation COOAccount
@dynamic balance, balanceDate, category, label, number, operations, user;
@end

@implementation COOOperation
@dynamic amount, date, label1, label2, account, day;
@end

@implementation COODay
@dynamic balance, date, operations;
@end
