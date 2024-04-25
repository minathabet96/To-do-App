//
//  TodoViewController.m
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import "TodoViewController.h"
#import "AddViewController.h"
#import "Task.h"
#import "CustomTableViewCell.h"
#import "Utilities.h"

@interface TodoViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImage;
@property (weak, nonatomic) IBOutlet UITableView *todoTable;
@property NSMutableArray<Task*> *allTasks;
@property NSMutableArray<Task*> *todo;
@property AddViewController *add;
@end

@implementation TodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _add = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    _searchBar.delegate = self;
    _todoTable.delegate = self;
    _todoTable.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationItem.title = @"To do";
    self.tabBarController.navigationItem.rightBarButtonItems[0].hidden = NO;
    self.tabBarController.navigationItem.rightBarButtonItems[1].hidden = YES;
    
    _todo = [Utilities readDataFromUserDefaults];
    _allTasks = _todo;
    _todo = [Utilities filterDataFromArray:_todo AndFilter:@"todo"];
     [_todoTable reloadData];
    if(_todo.count == 0){
        _todoTable.hidden = true;
        _emptyImage.hidden = false;
    }
    else {
        _todoTable.hidden = false;
        _emptyImage.hidden = true;
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _todo = [Utilities readDataFromUserDefaults];
    _todo = [Utilities filterDataFromArray:_todo AndFilter:@"todo"];
    
    if(searchText.length != 0)
        _todo = [Utilities filterSearchFromArray:_todo AndSearchText:searchText];
    
    [_todoTable reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];
    CustomTableViewCell *customCell = [self initializeTableViewCell:(CustomTableViewCell*) cell ForIndexPath:indexPath];
    
    return customCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return _todo.count;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
 
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteTaskForIndexPath:indexPath];
            [tableView reloadData];
        }];
        
        
            
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        
        [Utilities showAlertWithTitle:@"Delete task"
                           AndMessage:@"Are you sure you want to delete this task?" AndActions:@[deleteAction, cancel] AndView:self];
        
    }];
    delete.backgroundColor = [UIColor redColor];
    
    __block UIContextualAction *edit = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Edit" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        self->_add.addOrEdit = 0;
        self->_add.index = (int)indexPath.row;
        self-> _add.taskState = 0;
        
    Task *selected = self->_todo[indexPath.row];
    for(int i = 0; i<self->_allTasks.count; i++){
        if([selected.name isEqual:self->_allTasks[i].name]){
            self->_add.index = i;
        }
    }
            [self.navigationController pushViewController:self->_add animated:YES];
        }];
    
    edit.backgroundColor = [UIColor purpleColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[delete, edit]];
    return config;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(CustomTableViewCell*) initializeTableViewCell: (CustomTableViewCell*) cell ForIndexPath: (NSIndexPath*) indexPath{
    Task *task = [Task new];
    task = [_todo objectAtIndex:indexPath.row];
    cell.cellLabel.text = task.name;
    if([task.priority isEqual:@"low"])
        cell.cellImage.image = [UIImage imageNamed:@"green"];
    else if([task.priority isEqual:@"medium"])
        cell.cellImage.image = [UIImage imageNamed:@"yellow"];
    if([task.priority isEqual:@"high"])
        cell.cellImage.image = [UIImage imageNamed:@"red"];
    
    return cell;
}

- (void) deleteTaskForIndexPath: (NSIndexPath*) indexPath{
    Task *selected = self->_todo[indexPath.row];
    [self->_todo removeObjectAtIndex:indexPath.row];
    
    for(int i = 0; i<self->_allTasks.count; i++){
        if([selected.name isEqual:self->_allTasks[i].name]){
            [self->_allTasks removeObjectAtIndex:i];
            break;
        }
    }
    [Utilities writeDataToUserDefaults:self->_allTasks];
}


@end



