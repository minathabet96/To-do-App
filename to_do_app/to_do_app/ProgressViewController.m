//
//  ProgressViewController.m
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import "ProgressViewController.h"
#import "CustomTableViewCell.h"
#import "MyTabBarController.h"
#import "AddViewController.h"
#import "Utilities.h"
#import "Task.h"
@interface ProgressViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *emptyImage;
@property (weak, nonatomic) IBOutlet UITableView *progressTable;
@property NSData *savedData;
@property NSMutableArray<Task*> *progress;
@property MyTabBarController *tabBar;
@property bool filtering;
@property NSMutableArray *lowArr;
@property NSMutableArray *mediumArr;
@property NSMutableArray *highArr;
@property AddViewController *add;
@property NSMutableArray<Task*> *allTasks;
@property NSMutableDictionary*dict;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _add = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    _progressTable.delegate = self;
    _progressTable.dataSource = self;
    _tabBar = (MyTabBarController*)self.tabBarController;
    
}

- (void)viewWillAppear:(BOOL)animated {
    _tabBar.myDelegate = self;
    self.tabBarController.navigationItem.title = @"In progress";
    self.tabBarController.navigationItem.rightBarButtonItems[0].hidden = YES;
    self.tabBarController.navigationItem.rightBarButtonItems[1].hidden = NO;
    _progress = [Utilities readDataFromUserDefaults];
    _allTasks = _progress;

    _progress = [Utilities filterDataFromArray:_progress AndFilter:@"inprogress"];
    [_progressTable reloadData];
    
    if(_progress.count == 0){
        _progressTable.hidden = true;
        _emptyImage.hidden = false;
    }
    else{
        _progressTable.hidden = false;
        _emptyImage.hidden = true;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"progressCell" forIndexPath:indexPath];
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
        task = [_progress objectAtIndex:indexPath.row];
        
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
            
        for(Task *task in _progress){
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
    return _progress.count;
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
    _filtering = !_filtering;
    [_progressTable reloadData];
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteTaskForIndexPath:indexPath];
            [tableView reloadData];
        }];
        delete.backgroundColor = [UIColor redColor];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        
        [Utilities showAlertWithTitle:@"Delete task"
                           AndMessage:@"Are you sure you want to delete this task?"AndActions:@[deleteAction, cancel] AndView:self];
    }];
    
    __block UIContextualAction *edit = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Edit" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        self->_add.addOrEdit = 0;
        self->_add.taskState = 1;
        
            self->_add.index = (int)indexPath.row;
        
        Task *selected = self->_progress[indexPath.row];
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

- (void) deleteTaskForIndexPath: (NSIndexPath*) indexPath{
    Task *selected = self->_progress[indexPath.row];
    [self->_progress removeObjectAtIndex:indexPath.row];
    
    for(int i = 0; i<self->_allTasks.count; i++){
        if([selected.name isEqual:self->_allTasks[i].name]){
            [self->_allTasks removeObjectAtIndex:i];
            break;
        }
    }
    [Utilities writeDataToUserDefaults:self->_allTasks];
}
@end
