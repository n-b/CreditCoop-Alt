#import "CreditCoop+Values.h"

@implementation COOAccount (Values)
- (NSDecimalNumber*) balanceAt:(NSDate*)date_
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Operation"];
    request.resultType = NSDictionaryResultType;
    request.predicate = [NSPredicate predicateWithFormat:@"account == %@ && date > %@",self,date_];
    NSExpressionDescription * expressionDesc = [NSExpressionDescription new];
    expressionDesc.name = @"sumAmounts";
    expressionDesc.expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForKeyPath:@"amount"]]];
    expressionDesc.expressionResultType = NSDecimalAttributeType;
    request.propertiesToFetch = @[expressionDesc];
    NSError * error;
    NSArray * result = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSDecimalNumber * sumAmounts = [result.firstObject objectForKey:@"sumAmounts"];
    return [self.balance decimalNumberBySubtracting:sumAmounts];
}
@end
