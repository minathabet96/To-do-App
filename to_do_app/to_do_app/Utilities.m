//
//  Utilities.m
//  to_do_app
//
//  Created by Mina on 19/04/2024.
//

#import "Utilities.h"
#import <UIKit/UIKit.h>
#import "Task.h"
@implementation Utilities

+ (nonnull NSMutableArray *)readDataFromUserDefaults {
    NSUserDefaults *uDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedData = [uDefaults objectForKey:@"tasks"];
    if(savedData != nil) {
        
        NSSet *set = [NSSet setWithObjects:[NSArray class], [Task class], nil];
        return [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:nil];
    }
    else {
        [self writeDataToUserDefaults:[NSMutableArray new]];
        return [self readDataFromUserDefaults];
    }
    
}

+ (void)writeDataToUserDefaults: (NSMutableArray*) tasksArray {
    NSUserDefaults *uDefaults = [NSUserDefaults standardUserDefaults];
    
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:&error];
    [uDefaults setObject:data forKey:@"tasks"];
}

+ (NSMutableArray *)filterDataFromArray:(NSMutableArray<Task*> *)tasksArray AndFilter:(NSString *)filter {
    NSMutableArray *filteredArr = [NSMutableArray new];
    for(int i = 0; i<tasksArray.count; i++){
        if([tasksArray[i].state isEqual:filter])
            [filteredArr addObject:tasksArray[i]];
    }
    return filteredArr;
}

+ (nonnull NSMutableArray *)filterSearchFromArray:(nonnull NSMutableArray<Task *> *)tasksArray AndSearchText:(nonnull NSString *)searchText {
    NSMutableArray* filteredSearchArray = [NSMutableArray new];
    for(int i = 0; i<tasksArray.count; i++){
        if([tasksArray[i].name localizedCaseInsensitiveContainsString:searchText]){
            [filteredSearchArray addObject:tasksArray[i]];
        }
    }
    return filteredSearchArray;
}




+ (void)showAlertWithTitle:(nonnull NSString *)title AndMessage:(nonnull NSString *)message AndActions:(nonnull NSArray *)actions AndView:(nonnull UIViewController *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for(UIAlertAction *action in actions)
        [alert addAction:action];
    [view presentViewController:alert animated:YES completion:nil];
}

@end
