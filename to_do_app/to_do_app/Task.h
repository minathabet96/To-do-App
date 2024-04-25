//
//  Task.h
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding, NSSecureCoding>

@property BOOL supportsSecureCoding;
@property NSString *name;
@property NSString *desc;
@property NSString *priority;
@property NSString *state;
@property NSDate *date;

-(instancetype) initWithName: (NSString*) name andDesc: (NSString*) desc andPriority: (NSString*) priority andState: (NSString*) state andDate: (nullable NSDate*) date;
@end

NS_ASSUME_NONNULL_END
