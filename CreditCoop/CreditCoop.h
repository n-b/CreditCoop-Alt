//
//  CreditCoop.h
//  CreditCoop
//
//  Created by Nicolas on 02/12/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "CoreDataManager.h"
#import "CreditCoop.mogenerated.h"
@interface CreditCoop : CoreDataManager

- (void) logout;

- (void) loginWithUserCode:(NSString*)userCode sesame:(NSString*)sesame completion:(void(^)(NSString* error))completion
;

- (COOUser*) user;

@end
