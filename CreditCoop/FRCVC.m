#import "FRCVC.h"

@interface FRCVC () <NSFetchedResultsControllerDelegate>
@end

@interface FRCVC (FRCVC) <FRCVC> // Allow me to call methods implemented by subclasses
@end

@implementation FRCVC
{
    NSFetchedResultsController * _frc;
    NSString* _cellReuseIdentifier;
}

- (void)setEntityName:(NSString*)entityName_
              context:(NSManagedObjectContext*)context_
            predicate:(NSPredicate*)predicate_
      sortDescriptors:(NSArray<NSSortDescriptor*>*)sortDescriptors_
   sectionNameKeyPath:(NSString*)sectionNameKeyPath_
  cellReuseIdentifier:(NSString*)cellReuseIdentifier_
{
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName_];
    fetchRequest.predicate = predicate_;
    fetchRequest.sortDescriptors = sortDescriptors_;
    
    _frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:context_
            sectionNameKeyPath:sectionNameKeyPath_
            cacheName:nil];
    _frc.delegate = self;
    
    NSError * error;
    __unused BOOL ok = [_frc performFetch:&error];
    NSAssert(ok, @"Fetch failed : %@",error);
    
    _cellReuseIdentifier = cellReuseIdentifier_;

    if(self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller_
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller_ didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo_
           atIndex:(NSUInteger)sectionIndex_ forChangeType:(NSFetchedResultsChangeType)type_
{
    switch(type_) {
        case NSFetchedResultsChangeInsert: [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex_] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex_] withRowAnimation:UITableViewRowAnimationFade]; break;
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
        case NSFetchedResultsChangeUpdate: [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath_] withObject:[_frc objectAtIndexPath:indexPath_]]; break;
        case NSFetchedResultsChangeMove: [self.tableView moveRowAtIndexPath:indexPath_ toIndexPath:newIndexPath_]; break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section_
{
    return _frc.sections[section_].name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView_
{
    return _frc.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section_
{
    return _frc.sections[section_].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath_
{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier forIndexPath:indexPath_];
    [self configureCell:cell withObject:[_frc objectAtIndexPath:indexPath_]];
    return cell;
}

@end
