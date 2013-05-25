//
//  ContactsTableViewController.m
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import "YContactTableViewController.h"

@interface YContactTableViewController ()

@end

@implementation YContactTableViewController

@synthesize addressbook;

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) setAllowsMultipleSelection:(BOOL)allow
{
    self.tableView.allowsMultipleSelection = allow;
    [self.tableView setEditing:allow animated:YES];
}

-(BOOL) getAllowsMultipleSelection
{
    return self.tableView.allowsMultipleSelection;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSInteger character = section;
    NSArray* people = (NSArray *)[group objectAtIndex:section];
    if (0 == [people count]) {
        return nil;
    }
    if (25 < section) {
        character = -30;
    }
    return [NSString stringWithFormat: @"%c", (character + 65)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 27;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[group objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"%d-%d",
                      [indexPath section], [indexPath row]];
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
    }
    
    RHPerson *person = [[group objectAtIndex:[indexPath section]]
                        objectAtIndex:[indexPath row]];
    cell.textLabel.text = [person getFullName];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return letters;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
