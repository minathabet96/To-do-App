//
//  TabBarController.m
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import "MyTabBarController.h"
#import "AddViewController.h"
@interface MyTabBarController ()
@property AddViewController *add;
@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _add = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
}
 
- (void)viewWillAppear:(BOOL)animated {
    self.viewControllers[0].title = @"To do";
    self.viewControllers[1].title = @"In progress";
    self.viewControllers[2].title = @"Done";
}

- (IBAction)add:(id)sender {
    _add.addOrEdit = 1;
    _add.taskState = 9;
    [self.navigationController pushViewController:_add animated:YES];
}
- (IBAction)filter:(id)sender {
    [_myDelegate1 filter];
    [_myDelegate filter];
}

@end
