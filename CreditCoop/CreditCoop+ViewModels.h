#import "CreditCoop+Model.h"

@interface COOAccount (ViewModel)
- (NSDictionary*)viewModel;
@end

@interface COOOperation (ViewModel)
- (NSDictionary*)viewModel;
- (NSString*)dayDescription;
@end
