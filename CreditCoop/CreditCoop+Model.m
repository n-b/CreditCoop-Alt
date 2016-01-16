#import "CreditCoop+Model.h"

@implementation COOUser
@dynamic email, label, lastConnectionDate, accounts;
@end

@implementation COOAccount
@dynamic balance, balanceDate, category, label, number, operations, user;
@end

@implementation COOOperation
@dynamic amount, date, label1, label2, visibility, account, attributes, day;
@end

@implementation COOOperationAttributes
@dynamic actualDate, cleanName, lastDigits, originalAmount, originalCountry, originalCurrency, type, operation;
@end

@implementation COODay
@dynamic date, operations, balance, periodicSpending, periodicCash;
@end
