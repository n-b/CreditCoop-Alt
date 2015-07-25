#import "CreditCoop+ViewModels.h"
#import "CreditCoop.h"
#import "CreditCoop+Values.h"
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
    return @{@"title":self.label1,
             @"subtitle":self.label2.length?self.label2:@"-",
             @"amount":[CreditCoop stringFromAmount:self.amount],
             @"date":[CreditCoop stringFromDate:self.date],
             @"amountColor":[CreditCoop colorFromAmount:self.amount]};
}
- (NSString*)dayDescription
{
    return [NSString stringWithFormat:@"%@ %@",
            [CreditCoop stringFromDate:self.date],
            [CreditCoop stringFromAmount:[self.account balanceAt:self.date]]];
}
@end