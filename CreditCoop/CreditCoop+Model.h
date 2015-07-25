#import <CoreData/CoreData.h>

@class COOUser, COOAccount, COOOperation;

@interface COOUser : NSManagedObject
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* lastConnectionDate;
@property (nonatomic, strong) NSOrderedSet<COOAccount*> *accounts;
@end

@interface COOAccount : NSManagedObject
@property (nonatomic, strong) NSDecimalNumber* balance;
@property (nonatomic, strong) NSDate* balanceDate;
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* number;
@property (nonatomic, strong) NSOrderedSet<COOOperation*> *operations;
@property (nonatomic, strong) COOUser *user;
@end

@interface COOOperation : NSManagedObject
@property (nonatomic, strong) NSDecimalNumber* amount;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* label1;
@property (nonatomic, strong) NSString* label2;
@property (nonatomic, strong) COOAccount *account;
@end
