#import "CoreDataStack.h"
#import "CreditCoop+Model.h"


typedef void(^CompletionBlock)(NSError*__nullable error);

@interface CreditCoop : CoreDataStack

- (void)logout;
- (void)loginWithUserCode:(NSString* __nonnull)userCode_ sesame:(NSString* __nonnull)sesame_ completion:(CompletionBlock __nonnull)completion_;

typedef NS_ENUM(NSInteger, CreditCoopLoginStatus)
{
    CreditCoopLoginStatusNone,
    CreditCoopLoginStatusInProgress,
    CreditCoopLoginStatusLogged,
};
@property CreditCoopLoginStatus loginStatus;

- (COOUser* __nullable) user;

- (void)refreshAccount:(COOAccount* __nonnull)account_ completion:(CompletionBlock __nonnull)completion_;
- (void)refreshAllAccounts:(CompletionBlock __nonnull)completion_;


@end
