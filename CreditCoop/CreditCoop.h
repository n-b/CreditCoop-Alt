#import "CoreDataStack.h"
#import "CreditCoop+Model.h"


typedef void(^CompletionBlock)(NSError*__nullable error);

@interface CreditCoop : CoreDataStack

- (void)logout;
- (void)loginWithUserCode:(NSString* __nonnull)userCode_ sesame:(NSString* __nonnull)sesame_ completion:(CompletionBlock __nonnull)completion_;
- (void)refreshAccount:(COOAccount* __nonnull)account_ completion:(CompletionBlock __nonnull)completion_;
- (void)refreshAllAccounts:(CompletionBlock __nonnull)completion_;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) COOUser* __nullable user;

@end
