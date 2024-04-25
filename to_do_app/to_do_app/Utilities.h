//
//  Utilities.h
//  to_do_app
//
//  Created by Mina on 19/04/2024.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface Utilities : NSObject

+(void) showAlertWithTitle: (NSString*) title AndMessage: (NSString*) message AndActions: (NSArray*) actions AndView: (UIViewController*) view;

+(NSMutableArray*) readDataFromUserDefaults;
+(void) writeDataToUserDefaults: (NSMutableArray*) tasksArray;

+(NSMutableArray*) filterDataFromArray:(NSMutableArray<Task*> *) tasksArray AndFilter: (NSString*) filter;

+(NSMutableArray*) filterSearchFromArray:(NSMutableArray<Task*> *) tasksArray AndSearchText: (NSString*) searchText;
@end

NS_ASSUME_NONNULL_END
