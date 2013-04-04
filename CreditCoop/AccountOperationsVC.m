//
//  AccountDetailVC.m
//  CreditCoop
//
//  Created by Nicolas on 02/12/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "AccountOperationsVC.h"
#import "COOOperation.h"

@interface AccountOperationCell : UITableViewCell
@property IBOutlet UILabel * amountLabel;
@property IBOutlet UILabel * label1Label;
@property IBOutlet UILabel * label2Label;
@property IBOutlet UILabel * dateLabel;
@end
@implementation AccountOperationCell
@end

#pragma mark -

@interface AccountOperationsVC () <NSFetchedResultsControllerDelegate>
@end

@implementation AccountOperationsVC
{
    NSFetchedResultsController * _frc;
}

- (void) setAccount:(COOAccount *)account_
{
    if (nil==account_) {
        return;
    }
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[COOOperation entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@",COOOperationRelationships.account, account_];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:COOOperationAttributes.date ascending:NO],
                                     [[NSSortDescriptor alloc] initWithKey:COOOperationAttributes.amount ascending:NO]];
    
    _frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:account_.managedObjectContext
            sectionNameKeyPath:COOOperationAttributes.date
            cacheName:nil];
    _frc.delegate = self;
    
    NSError * error;
    __unused BOOL ok = [_frc performFetch:&error];
    NSAssert(ok, @"Fetch failed : %@",error);
    
    [self.tableView reloadData];
}

/****************************************************************************/
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert: [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade]; break;
    }
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert: [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeUpdate: [self configureCell:(AccountOperationCell*)[self.tableView cellForRowAtIndexPath:indexPath] withObject:[_frc objectAtIndexPath:indexPath]]; break;
        case NSFetchedResultsChangeMove: [[self tableView] moveRowAtIndexPath:indexPath toIndexPath:newIndexPath]; break;
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}

/****************************************************************************/
#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_frc.sections[section] name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_frc.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountOperationCell" forIndexPath:indexPath];
    [self configureCell:cell withObject:[_frc objectAtIndexPath:indexPath]];
    return cell;
}

- (void) configureCell:(AccountOperationCell *)cell withObject:(COOOperation*)operation
{
    cell.amountLabel.text = [operation.amount description];
    cell.label1Label.text = operation.label1;
    cell.label2Label.text = operation.label2;
    cell.dateLabel.text = [operation.date description];
}

@end
