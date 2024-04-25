//
//  Task.m
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import "Task.h"

@implementation Task

- (instancetype)initWithName:(NSString *)name andDesc:(NSString *)desc andPriority:(NSString *)priority andState:(NSString *)state andDate:(NSDate *)date {
    self = [super init];
    _name = name;
    _desc = desc;
    _priority = priority;
    _state = state;
    _date = date;
    return self;
}
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_desc forKey:@"desc"];
    [coder encodeObject:_priority forKey:@"priority"];
    [coder encodeObject:_state forKey:@"state"];
    [coder encodeObject:_date forKey:@"date"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder { 
    _name = [coder decodeObjectForKey:@"name"];
    _desc = [coder decodeObjectForKey:@"desc"];
    _priority = [coder decodeObjectOfClass: [NSString class] forKey:@"priority"];
    _state = [coder decodeObjectOfClass: [NSString class] forKey:@"state"];
    _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    
    return self;
}
+(BOOL)supportsSecureCoding {
    return true;
}

@end
