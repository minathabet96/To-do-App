//
//  TabBarController.h
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import <UIKit/UIKit.h>
#import "MyDelegate.h"
#import "MyDelegate1.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyTabBarController : UITabBarController 
@property (nonatomic, weak) id<MyDelegate> myDelegate;
@property (nonatomic, weak) id<MyDelegate1> myDelegate1;
@end

NS_ASSUME_NONNULL_END
