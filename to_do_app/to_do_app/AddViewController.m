//
//  AddViewController.m
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import "AddViewController.h"
#import "Task.h"
#import "Utilities.h"

@interface AddViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UITextField *nametxt;
@property (weak, nonatomic) IBOutlet UITextField *descriptiontxt;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *state;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property NSUserDefaults *userDefaults;
@property NSMutableArray<Task*> *tasksArray;

@end

@implementation AddViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _date.minimumDate = [NSDate date];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    //_date.minimumDate = [NSDate date];
    self.nametxt.delegate = self;
    self.descriptiontxt.delegate = self;
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    _tasksArray = [NSMutableArray new];
    if(self.addOrEdit == 1){
        _nametxt.text = @"";
        _descriptiontxt.text = @"";
        _priority.selectedSegmentIndex = 0;
        _state.selectedSegmentIndex = 0;
        _date.date = [NSDate date];
        _addButton.hidden = false;
        _editButton.hidden = true;
        [_state setEnabled:NO forSegmentAtIndex:1];
        [_state setEnabled:NO forSegmentAtIndex:2];
    }
    else{
        _addButton.hidden = true;
        _editButton.hidden = false;
        printf("%s%d", "\n\nstate is: ", _taskState);
        switch(_taskState) {
            case 1: {
                [_state setEnabled:NO forSegmentAtIndex:0];
                _state.selectedSegmentIndex = 1;
                break;
            }
            case 2:{
                [_priority setEnabled:NO forSegmentAtIndex:0];
                [_priority setEnabled:NO forSegmentAtIndex:1];
                [_priority setEnabled:NO forSegmentAtIndex:2];
                _state.selectedSegmentIndex = 2;
                [_state setEnabled:NO forSegmentAtIndex:0];
                [_state setEnabled:NO forSegmentAtIndex:1];
                _addButton.hidden = true;
                _editButton.hidden = true;
                break;
            }
            case 0: {
                [_state setEnabled:YES forSegmentAtIndex:1];
                [_state setEnabled:YES forSegmentAtIndex:2];
                break;
            }
        }
        
        printf("%s%d", "indexxx is: ", _index);
        NSData *savedData = [_userDefaults objectForKey:@"tasks"];
        NSSet *set = [NSSet setWithObjects:[NSArray class], [Task class], nil];
        _tasksArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:nil];
        
        _nametxt.text = _tasksArray[_index].name;
        _descriptiontxt.text = _tasksArray[_index].desc;
        if([_tasksArray[_index].priority isEqual:@"low"])
           _priority.selectedSegmentIndex = 0;
        if([_tasksArray[_index].priority isEqual:@"medium"])
           _priority.selectedSegmentIndex = 1;
        if([_tasksArray[_index].priority isEqual:@"high"])
           _priority.selectedSegmentIndex = 2;
        _date.date = _tasksArray[_index].date;
        if([_tasksArray[_index].state isEqual:@"todo"])
           _state.selectedSegmentIndex = 0;
        if([_tasksArray[_index].state isEqual:@"inprogress"])
           _state.selectedSegmentIndex = 1;
        if([_tasksArray[_index].state isEqual:@"done"])
           _state.selectedSegmentIndex = 2;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)edit:(id)sender {
    NSData *savedData = [_userDefaults objectForKey:@"tasks"];
    NSSet *set = [NSSet setWithObjects:[NSArray class], [Task class], nil];
    NSString *priority = [NSString new];
    NSString *state = [NSString new];
    switch (_priority.selectedSegmentIndex) {
        case 0:
            priority = @"low";
            break;
        case 1:
            priority = @"medium";
            break;
        case 2:
            priority = @"high";
    }
    switch (_state.selectedSegmentIndex) {
        case 0:
            state = @"todo";
            break;
        case 1:
            state = @"inprogress";
            break;
        case 2:
            state = @"done";
    }
    _tasksArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:nil];
    Task *task = [[Task alloc] initWithName:_nametxt.text andDesc:_descriptiontxt.text andPriority:priority andState:state andDate:_date.date];
    _tasksArray[_index] = task;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_tasksArray requiringSecureCoding:YES error:nil];
    
    [_userDefaults setObject:data forKey:@"tasks"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)addTask:(id)sender {
    if(_nametxt.text.length == 0){
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [Utilities showAlertWithTitle:@"Empty name" AndMessage:@"You must add a task name" AndActions:@[action] AndView:self];
    }
    else {
        NSString *priority = [NSString new];
        NSString *state = [NSString new];
        
        switch (_priority.selectedSegmentIndex) {
            case 0:
                priority = @"low";
                break;
            case 1:
                priority = @"medium";
                break;
            case 2:
                priority = @"high";
        }
        switch (_state.selectedSegmentIndex) {
            case 0:
                state = @"todo";
                break;
            case 1:
                state = @"inprogress";
                break;
            case 2:
                state = @"done";
        }
        
        _tasksArray = [Utilities readDataFromUserDefaults];
        
        Task *task = [[Task alloc] initWithName:_nametxt.text andDesc:_descriptiontxt.text andPriority:priority andState:state andDate:_date.date];
        [_tasksArray addObject:task];
        
        [Utilities writeDataToUserDefaults:_tasksArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
