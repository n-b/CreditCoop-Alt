#import "CreditCoop+Days.h"

@implementation COOAccount (Days)
- (void)makeDays
{
    NSOrderedSet * days = [self.operations valueForKey:@"date"];

    for (NSDate * date in days) {
        COODay * day = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
        day.date = date;

        NSOrderedSet * subsequentOperations = [self.operations filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"date > %@",date]];
        day.balance = [self.balance decimalNumberBySubtracting:[subsequentOperations valueForKeyPath:@"@sum.amount"]];

        day.operations = [self.operations filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"date == %@",date]].set;
        
        NSDate * thirtyDaysBefore = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:-30 toDate:date options:0];
        NSOrderedSet * cardOperationsIn30Days = [self.operations filteredOrderedSetUsingPredicate:
                                                 [NSPredicate predicateWithFormat:@"attributes.type = %@ && date <= %@ && date > %@",
                                                  @"carte", date, thirtyDaysBefore]];
        day.periodicSpending = [cardOperationsIn30Days valueForKeyPath:@"@sum.amount"];
        
        NSDate * sevenDaysBefore = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:-30 toDate:date options:0];
        NSOrderedSet * cashOperationsIn7Days = [self.operations filteredOrderedSetUsingPredicate:
                                                [NSPredicate predicateWithFormat:@"attributes.type = %@ && date <= %@ && date > %@",
                                                 @"retrait", date, sevenDaysBefore]];
        day.periodicCash = [cashOperationsIn7Days valueForKeyPath:@"@sum.amount"];
    }
}
@end
