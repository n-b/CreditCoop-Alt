#import "NSManagedObject+COOMapping.h"
#import "CreditCoop+Model.h"

@implementation NSManagedObject (Importing)
- (void) importValues:(NSDictionary*)values_
{
    for (NSString * key in values_) { [self importValue:values_[key] forKey:key]; }
}

- (void) importValue:(id)value_ forKey:(NSString*)key_
{
    void (^handler)(NSManagedObject* object, id value) = self.class.coomapping[key_];
    if(handler) handler(self, value_);
}
@end
#define SIMPLEMAPPING(attributename) (^(NSManagedObject* object, id value){[object setValue:value forKey:(attributename)];})

@implementation COOUser (COOMapping)
+ (NSDictionary*) coomapping
{
    return @{ @"mail" : SIMPLEMAPPING(@"email"),
              @"label" : SIMPLEMAPPING(@"label"),
              @"lastConnectionDate" : SIMPLEMAPPING(@"lastConnectionDate")};
}
@end

@implementation COOAccount (COOMapping)

+ (NSDictionary*) coomapping
{
    return @{@"accountNumber" : SIMPLEMAPPING(@"number"),
             @"balance" : SIMPLEMAPPING(@"balance"),
             @"balanceDate" : SIMPLEMAPPING(@"balanceDate"),
             @"category" : SIMPLEMAPPING(@"category"),
             @"label" : SIMPLEMAPPING(@"label"),
             };
}

@end

@implementation COOOperation (COOMapping)
+ (NSDictionary*) coomapping
{
    return @{@"operationAmountSign" : SIMPLEMAPPING(@"amount"),
              @"operationLabel1" : SIMPLEMAPPING(@"label1"),
              @"operationLabel2" : SIMPLEMAPPING(@"label2"),
              @"operationDate" : ^(NSManagedObject* object, id value){
                  static NSDateFormatter * formatter;
                  static dispatch_once_t onceToken;
                  dispatch_once(&onceToken, ^{
                      formatter = [NSDateFormatter new];
                      formatter.dateFormat = @"dd.MM.yy";
                      formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr"];
                  });
                  [object setValue:[formatter dateFromString:value] forKey:@"date"];
              }
             };
}
@end
