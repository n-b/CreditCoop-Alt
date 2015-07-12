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

@interface AccountOperationsVC () <NSFetchedResultsControllerDelegate>
@end

@implementation AccountOperationsVC
{
    NSFetchedResultsController * _frc;
}

- (void)setAccount:(COOAccount *)account_
{
    if (nil==account_) {
        return;
    }
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Operation"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"account", account_];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO],
                                     [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:NO]];
    
    _frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:account_.managedObjectContext
            sectionNameKeyPath:@"date"
            cacheName:nil];
    _frc.delegate = self;
    
    NSError * error;
    __unused BOOL ok = [_frc performFetch:&error];
    NSAssert(ok, @"Fetch failed : %@",error);
    
    [self.tableView reloadData];
}

/****************************************************************************/
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller_
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert: [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade]; break;
        default: break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller_ didChangeObject:(id)anObject_
       atIndexPath:(NSIndexPath *)indexPath_ forChangeType:(NSFetchedResultsChangeType)type_
      newIndexPath:(NSIndexPath *)newIndexPath_
{
    switch(type_) {
        case NSFetchedResultsChangeInsert: [self.tableView insertRowsAtIndexPaths:@[newIndexPath_] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [self.tableView deleteRowsAtIndexPaths:@[indexPath_] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeUpdate: [self configureCell:(AccountOperationCell*)[self.tableView cellForRowAtIndexPath:indexPath_] withObject:[_frc objectAtIndexPath:indexPath_]]; break;
        case NSFetchedResultsChangeMove: [self.tableView moveRowAtIndexPath:indexPath_ toIndexPath:newIndexPath_]; break;
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section_
{
    return [_frc.sections[section_] name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView_
{
    return [_frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section_
{
    return [_frc.sections[section_] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath_
{
    AccountOperationCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"AccountOperationCell" forIndexPath:indexPath_];
    [self configureCell:cell withObject:[_frc objectAtIndexPath:indexPath_]];
    return cell;
}

- (void)configureCell:(AccountOperationCell *)cell_ withObject:(COOOperation*)operation_
{
    cell_.amountLabel.text = [operation_.amount description];
    cell_.label1Label.text = operation_.label1;
    cell_.label2Label.text = operation_.label2;
    cell_.dateLabel.text = [operation_.date description];
}

@end
