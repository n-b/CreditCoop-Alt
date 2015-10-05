#import "NSManagedObject+COOMapping.h"
#import "CreditCoop+Model.h"

typedef void (^MappingHandler)(NSManagedObject*, id);
typedef NSDictionary<NSString *,MappingHandler> MappingDictionary;

MappingHandler COOSimpleMapping(NSString* attributename_) {
    return ^(NSManagedObject* object, id value){[object setValue:value forKey:(attributename_)];};
}

@interface NSManagedObject (COOMapping)
+ (MappingDictionary *)coomapping;
@end

@implementation NSManagedObject (COOImporting)
- (void)coo_importValues:(NSDictionary*)values_
{
    for (NSString * key in values_) { [self coo_importValue:values_[key] forKey:key]; }
}
- (void)coo_importValue:(id)value_ forKey:(NSString*)key_
{
    MappingHandler handler = self.class.coomapping[key_];
    if(handler) handler(self, value_);
}
@end

@implementation COOUser (COOMapping)
+ (MappingDictionary *)coomapping
{
    return @{ @"mail" : COOSimpleMapping(@"email"),
              @"label" : COOSimpleMapping(@"label"),
              @"lastConnectionDate" : COOSimpleMapping(@"lastConnectionDate")};
}
@end

@implementation COOAccount (COOMapping)
+ (MappingDictionary *)coomapping
{
    return @{@"accountNumber" : COOSimpleMapping(@"number"),
             @"balance" : COOSimpleMapping(@"balance"),
             @"balanceDate" : ^(NSManagedObject* object, id value){
                 static NSDateFormatter * formatter;
                 static dispatch_once_t onceToken;
                 dispatch_once(&onceToken, ^{
                     formatter = [NSDateFormatter new];
                     formatter.dateFormat = @"dd/MM/yy HH:mm";
                 });
                 [object setValue:[formatter dateFromString:value] forKey:@"balanceDate"];
             },
             @"category" : COOSimpleMapping(@"category"),
             @"label" : COOSimpleMapping(@"label"),
             };
}
@end

@implementation COOOperation (COOMapping)
+ (MappingDictionary *) coomapping
{
    return @{@"operationAmountSign" : COOSimpleMapping(@"amount"),
             @"operationLabel1" : COOSimpleMapping(@"label1"),
             @"operationLabel2" : COOSimpleMapping(@"label2"),
             @"operationDate" : ^(NSManagedObject* object, id value){
                 static NSDateFormatter * formatter;
                 static dispatch_once_t onceToken;
                 dispatch_once(&onceToken, ^{
                     formatter = [NSDateFormatter new];
                     formatter.dateFormat = @"dd.MM.yy";
                 });
                 [object setValue:[formatter dateFromString:value] forKey:@"date"];
             }
             };
}
@end
