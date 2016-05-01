#import "CreditCoop.h"

typedef NSError*__nullable(^ParsingBlock)(NSDictionary*__nonnull dict);

@interface CreditCoop (Requests)

- (void)makeRequest:(NSString*__nonnull)path_
      withArguments:(NSDictionary<NSString*,NSString*>*__nonnull)queryParams
            parsing:(ParsingBlock __nonnull)parsing_
         completion:(CompletionBlock __nonnull)completion_;

- (void)clearCookies;
@end
