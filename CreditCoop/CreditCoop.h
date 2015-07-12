#import "CoreDataStack.h"
#import "CreditCoop+Model.h"

@interface CreditCoop : CoreDataStack

- (void) logout;

- (void) loginWithUserCode:(NSString*)userCode sesame:(NSString*)sesame completion:(void(^)(NSString* error))completion
;

- (COOUser*) user;

@end
