//
//  FRCVC.h
//
//
//  Created by Nicolas on 03/12/12.
//  
//


// A UIViewController with a table view, backed by a FRC.
// Implements the FRC/TableView plumbing
@interface FRCVC : UIViewController <UITableViewDataSource>

- (void) setEntityName:(NSString*)entityName_
               context:(NSManagedObjectContext*)context_
             predicate:(NSPredicate*)predicate_
       sortDescriptors:(NSArray*)sortDescriptors_
             cellClass:(Class)cellClass_
   cellReuseIdentifier:(NSString*)cellReuseIdentifier_;

- (void) setEntityName:(NSString*)entityName_
               context:(NSManagedObjectContext*)context_
             predicate:(NSPredicate*)predicate_
       sortDescriptors:(NSArray*)sortDescriptors_
               cellNib:(UINib*)cellNib_
   cellReuseIdentifier:(NSString*)cellReuseIdentifier_;

@property (readonly) NSFetchedResultsController * frc;

@end

@protocol FRCVC // Subclasses must conform to this protocol
- (UITableView*) tableView; // The tableview to feed with the frc
- (void) configureCell:(UITableViewCell*)cell withObject:(id)object;
@end
