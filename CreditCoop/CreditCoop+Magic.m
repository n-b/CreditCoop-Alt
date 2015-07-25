#import "CreditCoop+Magic.h"

@implementation COOOperation (Magic)
- (void)makeAttributes {
    NSString * type;
    /*
     carte,
     retrait,
     cheque,
     virement,
     prélèvement,
     frais,
     autre
     */
    NSString * actualDate; // retrait et carte
    NSString * lastDigits; // retrait et carte
    NSString * cleanName;  // any known type

    
    NSScanner * label1Scanner = [NSScanner scannerWithString:self.label1];
    if([label1Scanner scanString:@"CARTE " intoString:nil]) {
        type = @"carte";
        [label1Scanner scanUpToString:@" " intoString:&actualDate]; [label1Scanner scanString:@" " intoString:nil];
        [label1Scanner scanUpToString:@" " intoString:&lastDigits];
        [label1Scanner scanString:@" " intoString:nil];
        cleanName = [label1Scanner.string substringFromIndex:label1Scanner.scanLocation];
    } else if ([label1Scanner scanString:@"RETRAIT DAB " intoString:nil]) {
        type = @"retrait";
        NSString * day, *month;
        [label1Scanner scanUpToString:@"-" intoString:&day]; [label1Scanner scanString:@"-" intoString:nil];
        [label1Scanner scanUpToString:@"-" intoString:&month]; [label1Scanner scanString:@"-" intoString:nil];
        actualDate = [NSString stringWithFormat:@"%@/%@",day,month];
        [label1Scanner scanUpToString:@"-" intoString:&cleanName]; [label1Scanner scanString:@"-" intoString:nil];
        [label1Scanner scanUpToString:@" " intoString:&lastDigits];
    } else if ([label1Scanner scanString:@"CHEQUE NC " intoString:nil]) {
        type = @"cheque";
        cleanName = [label1Scanner.string substringFromIndex:label1Scanner.scanLocation];
    } else if ([label1Scanner scanString:@"VIR SEPA " intoString:nil]) {
        type = @"prelevement";
        [label1Scanner scanString:@"EMET : " intoString:nil];
        cleanName = [label1Scanner.string substringFromIndex:label1Scanner.scanLocation];
    } else if ([label1Scanner scanString:@"PRLV SEPA " intoString:nil]) {
        type = @"prelevement";
        cleanName = [label1Scanner.string substringFromIndex:label1Scanner.scanLocation];
    } else if ([label1Scanner scanString:@"FRAIS " intoString:nil]) {
        type = @"frais";
        cleanName = [label1Scanner.string substringFromIndex:label1Scanner.scanLocation];
    }
    
    cleanName = [cleanName stringByTrimmingCharactersInSet:NSCharacterSet.alphanumericCharacterSet.invertedSet];
    if(cleanName && [self.label2.lowercaseString hasPrefix:cleanName.lowercaseString]) {
        cleanName = self.label2;
    }
    
    
    //
    NSString * originalAmount;
    NSString * originalCurrency;
    NSString * originalCountry;

    NSScanner * label2Scanner = [NSScanner scannerWithString:self.label2];
    if([label2Scanner scanString:@"MT ORIGINE"  intoString:nil]) {
        [label2Scanner scanUpToString:@" " intoString:&originalAmount]; [label2Scanner scanString:@" " intoString:nil];
        [label2Scanner scanUpToString:@" " intoString:&originalCurrency]; [label2Scanner scanString:@" " intoString:nil];
        [label2Scanner scanUpToString:@" " intoString:&originalCountry];
    }

    self.attributes = [NSEntityDescription insertNewObjectForEntityForName:@"OperationAttributes" inManagedObjectContext:self.managedObjectContext];
    self.attributes.type = type;
    self.attributes.actualDate = actualDate;
    self.attributes.lastDigits = lastDigits;
    self.attributes.cleanName = cleanName;
    self.attributes.originalAmount = originalAmount;
    self.attributes.originalCurrency = originalCurrency;
    self.attributes.originalCountry = originalCountry;
}
@end
