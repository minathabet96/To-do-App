//
//  DoneViewController.m
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//
#import "Task.h"
#import "DoneViewController.h"
#import "MyTabBarController.h"
#import "CustomTableViewCell.h"
#import "AddViewController.h"
#import "Utilities.h"
@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *emptyImage;
@property (weak, nonatomic) IBOutlet UITableView *doneTable;
@property NSMutableArray<Task*> *done;
@property NSDate *savedData;
@property MyTabBarController *tabBar;
@property bool filtering;
@property NSMutableArray *lowArr;
@property NSMutableArray *mediumArr;
@property NSMutableArray *highArr;
@property AddViewController *add;
@property NSMutableArray<Task*> *allTasks;
@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _doneTable.delegate = self;
    _doneTable.dataSource = self;
    _tabBar = (MyTabBarController*)self.tabBarController;
    _add = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationItem.title = @"Done";
    _tabBar.myDelegate1 = self;
    if(_filtering)
    self.tabBarController.navigationItem.rightBarButtonItems[0].hidden = YES;
    self.tabBarController.navigationItem.rightBarButtonItems[1].hidden = NO;
    _done = [Utilities readDataFromUserDefaults];
    _allTasks = _done;
    _done = [Utilities filterDataFromArray:_done AndFilter:@"done"];
    [_doneTable reloadData];
    
    if((_done).count == 0){
        _doneTable.hidden = true;
        _emptyImage.hidden = false;
    }
    else{
        _doneTable.hidden = false;
        _emptyImage.hidden = true;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"doneCell" forIndexPath:indexPath];
    Task *task = [Task new];
    if(_filtering){
        if(indexPath.section == 0)
            task = [_lowArr objectAtIndex:indexPath.row];
        if(indexPath.section == 1)
            task = [_mediumArr objectAtIndex:indexPath.row];
        if(indexPath.section == 2)
            task = [_highArr objectAtIndex:indexPath.row];
    }
    else
        task = [_done objectAtIndex:indexPath.row];
        
    cell.cellLabel.text = task.name;
    if([task.priority isEqual:@"low"])
        cell.cellImage.image = [UIImage imageNamed:@"green"];
    else if([task.priority isEqual:@"medium"])
        cell.cellImage.image = [UIImage imageNamed:@"yellow"];
    if([task.priority isEqual:@"high"])
        cell.cellImage.image = [UIImage imageNamed:@"red"];
    return cell;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_filtering){
            _lowArr = [NSMutableArray new];
            _mediumArr = [NSMutableArray new];
            _highArr = [NSMutableArray new];
            
        for(Task *task in _done){
            if ([task.priority isEqual:@"low"]) {
                [_lowArr addObject:task];
            }
            else if ([task.priority isEqual:@"medium"]) {
                [_mediumArr addObject:task];
            }
            else {
                [_highArr addObject:task];
            }
        }
        if(section == 0)
            return _lowArr.count;
        else if(section == 1)
            return _mediumArr.count;
        else
            return _highArr.count;
    }
    else
    return _done.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_filtering)
        return 3;
    else return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(_filtering){
        if(section==0)
            return @"low";
        if(section==1)
            return @"medium";
        else
            return @"high";
        }
    else
        return @"";

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (void)filter { 
    printf("%d", _filtering);
    _filtering = !_filtering;
    [_doneTable reloadData];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            Task *selected = self->_done[indexPath.row];
            [self->_done removeObjectAtIndex:indexPath.row];
            
            delete.backgroundColor = [UIColor redColor];
            
            for(int i = 0; i<self->_allTasks.count; i++){
                if([selected.name isEqual:self->_allTasks[i].name]){
                    [self->_allTasks removeObjectAtIndex:i];
                    break;
                }
            }
            [Utilities writeDataToUserDefaults:self->_allTasks];
            [tableView reloadData];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [Utilities showAlertWithTitle:@"Delete task" AndMessage:
         @"Are you sure you want to delete this task?"AndActions:@[deleteAction, cancel] AndView:self];
        
    }];
    
    __block UIContextualAction *edit = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Edit" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        self->_add.addOrEdit = 0;
        self->_add.taskState = 2;
        Task *selected = self->_done[indexPath.row];
        for(int i = 0; i<self->_allTasks.count; i++){
            if([selected.name isEqual:self->_allTasks[i].name]){
                self->_add.index = i;
                break;
            }
        }
        [self.navigationController pushViewController:self->_add animated:YES];
        }];
    
    edit.backgroundColor = [UIColor purpleColor];
    [tableView reloadData];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[delete, edit]];
    return config;
}
@end
