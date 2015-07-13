#import "AccountOperationsVC.h"
#import "CreditCoop+Model.h"

#pragma mark AccountOperationCell

@interface AccountOperationCell : UITableViewCell
@property IBOutlet UILabel * amountLabel;
@property IBOutlet UILabel * label1Label;
@property IBOutlet UILabel * label2Label;
@property IBOutlet UILabel * dateLabel;
@end

@implementation AccountOperationCell
@end

#pragma mark AccountOperationsVC

@implementation AccountOperationsVC

- (void)setAccount:(COOAccount *)account_
{
    if (nil==account_) {
        return;
    }
    
    [self setEntityName:@"Operation"
                context:account_.managedObjectContext
              predicate:[NSPredicate predicateWithFormat:@"%K == %@",@"account", account_]
        sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO],
                          [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:NO]]
     sectionNameKeyPath:@"date"
    cellReuseIdentifier:@"AccountOperationCell"];
}

- (void)configureCell:(AccountOperationCell *)cell_ withObject:(COOOperation*)operation_
{
    cell_.amountLabel.text = operation_.amount.description;
    cell_.label1Label.text = operation_.label1;
    cell_.label2Label.text = operation_.label2;
    cell_.dateLabel.text = operation_.date.description;
}

@end
