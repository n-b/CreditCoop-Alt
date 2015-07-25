#import "CreditCoop+ViewModels.h"
#import "CreditCoop.h"
@import UIKit;

@implementation CreditCoop (ViewModels)
+ (NSString*)stringFromDate:(NSDate*)date_ {
    NSDateFormatter * df = NSDateFormatter.new;
    df.timeStyle = NSDateFormatterNoStyle;
    df.dateStyle = NSDateFormatterMediumStyle;
    return [df stringFromDate:date_];
}
+ (NSString*)stringFromAmount:(NSNumber*)number_ {
    NSNumberFormatter * nf = NSNumberFormatter.new;
    nf.numberStyle = NSNumberFormatterCurrencyStyle;
    nf.currencyCode = @"EUR";
    return [nf stringFromNumber:number_];
}
+ (UIColor*)colorFromAmount:(NSNumber*)number_
{
    return ([number_ compare:@0]==NSOrderedAscending
            ? [UIColor colorWithHue:0 saturation:.8 brightness:.6 alpha:1]
            : [UIColor colorWithHue:.3 saturation:.8 brightness:.6 alpha:1]);
}
@end

@implementation COOAccount (ViewModel)
- (NSDictionary*)viewModel
{
    return @{@"title":self.label,
             @"subtitle":self.number,
             @"amount":[CreditCoop stringFromAmount:self.balance],
             @"date":[CreditCoop stringFromDate:self.balanceDate],
             @"amountColor":[CreditCoop colorFromAmount:self.balance]};
}
@end

@implementation COOOperation (ViewModel)
- (NSDictionary*)viewModel
{
    NSString * title = [self.attributes.cleanName capitalizedStringWithLocale:NSLocale.currentLocale]?:self.label1;
    NSMutableString * subtitle = self.attributes.type.mutableCopy;
    if(self.attributes.lastDigits) {
        [subtitle appendFormat:@" n° %@",self.attributes.lastDigits];
    }
    if(self.attributes.actualDate) {
        [subtitle appendFormat:@" le %@",self.attributes.actualDate];
    }
    if(self.attributes.originalAmount) {
        [subtitle appendFormat:@" (%@ %@%@)",self.attributes.originalAmount, self.attributes.originalCurrency, self.attributes.originalCountry];
    }
    
    
    return @{@"title":title,
             @"subtitle":subtitle.length?subtitle:self.label2,
             @"amount":[CreditCoop stringFromAmount:self.amount],
             @"date":[CreditCoop stringFromDate:self.date],
             @"amountColor":[CreditCoop colorFromAmount:self.amount]};
}
@end

@implementation COODay (ViewModel)
- (NSDictionary*)viewModel
{
    return @{@"title":[CreditCoop stringFromDate:self.date],
             @"amount":[CreditCoop stringFromAmount:self.balance]};
}
@end
