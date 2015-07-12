#import "CoreDataManager.h"
#import "CreditCoop+Model.h"

@interface CreditCoop : CoreDataManager

- (void) logout;

- (void) loginWithUserCode:(NSString*)userCode sesame:(NSString*)sesame completion:(void(^)(NSString* error))completion
;

- (COOUser*) user;

@end
