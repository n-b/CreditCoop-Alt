#import "CreditCoop+Days.h"

@implementation COOAccount (Days)
- (void)makeDays
{
    NSOrderedSet * days = [self.operations valueForKey:@"date"];

    for (NSDate * date in days) {
        NSOrderedSet * subsequentOperations = [self.operations filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"date > %@",date]];
        NSDecimalNumber * balanceAtDay = [self.balance decimalNumberBySubtracting:[subsequentOperations valueForKeyPath:@"@sum.amount"]];
        NSSet * operationsAtDay = [self.operations filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"date == %@",date]].set;
        
        COODay * day = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
        day.date = date;
        day.balance = balanceAtDay;
        day.operations = operationsAtDay;
    }
}
@end
