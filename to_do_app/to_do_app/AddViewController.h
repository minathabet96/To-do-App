//
//  AddViewController.h
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController <UITextFieldDelegate>
@property NSMutableArray *todo;
@property int addOrEdit;
@property int taskState;
@property int index;
@property Task *task;
@end

NS_ASSUME_NONNULL_END
