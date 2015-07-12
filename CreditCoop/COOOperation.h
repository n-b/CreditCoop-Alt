#import <CoreData/CoreData.h>
#import "COOAccount.h"

@interface COOOperation : NSManagedObject
@property (nonatomic, strong) NSDecimalNumber* amount;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* label1;
@property (nonatomic, strong) NSString* label2;
@property (nonatomic, strong) COOAccount *account;
@end
