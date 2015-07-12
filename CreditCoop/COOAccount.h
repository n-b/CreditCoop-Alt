#import <CoreData/CoreData.h>
#import "COOUser.h"

@interface COOAccount : NSManagedObject
@property (nonatomic, strong) NSDecimalNumber* balance;
@property (nonatomic, strong) NSString* balanceDate;
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* number;
@property (nonatomic, strong) NSOrderedSet *operations;
@property (nonatomic, strong) COOUser *user;
@end
