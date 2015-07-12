#import "NSManagedObject+COOMapping.h"
#import "CreditCoop+Model.h"

#define SIMPLEMAPPING(attributename) (^(NSManagedObject* object, id value){[object setValue:value forKey:(attributename)];})

@interface NSManagedObject (COOMapping)
+ (NSDictionary*)coomapping;
@end

@implementation NSManagedObject (COOImporting)
- (void)coo_importValues:(NSDictionary*)values_
{
    for (NSString * key in values_) { [self coo_importValue:values_[key] forKey:key]; }
}
- (void)coo_importValue:(id)value_ forKey:(NSString*)key_
{
    void (^handler)(NSManagedObject* object, id value) = self.class.coomapping[key_];
    if(handler) handler(self, value_);
}
@end

@implementation COOUser (COOMapping)
+ (NSDictionary*)coomapping
{
    return @{ @"mail" : SIMPLEMAPPING(@"email"),
              @"label" : SIMPLEMAPPING(@"label"),
              @"lastConnectionDate" : SIMPLEMAPPING(@"lastConnectionDate")};
}
@end

@implementation COOAccount (COOMapping)
+ (NSDictionary*)coomapping
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
