#import "CoreDataStack.h"
#import "CreditCoop+Model.h"

@interface CreditCoop : CoreDataStack

- (void)logout;
- (void)loginWithUserCode:(NSString*)userCode_ sesame:(NSString*)sesame_ completion:(void(^)(NSString* error))completion_;
- (void)refreshAccount:(COOAccount*)account_;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) COOUser *user;

@end
