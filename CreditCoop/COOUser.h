#import <CoreData/CoreData.h>

@interface COOUser : NSManagedObject {}
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* lastConnectionDate;
@property (nonatomic, strong) NSOrderedSet *accounts;
@end
