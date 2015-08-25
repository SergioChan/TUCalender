//
//  TUCalendarDataCache.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarDataCache.h"
#import "TUCalendarView.h"

@interface TUCalendarDataCache(){
    NSMutableDictionary *events;
    NSDateFormatter *dateFormatter;
};
@end

@implementation TUCalendarDataCache

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    events = [NSMutableDictionary new];
    
    return self;
}

- (void)reloadData
{
    [events removeAllObjects];
}

- (BOOL)haveCheckedin:(NSDate *)date
{
    if(!self.calendar.dataSource){
        return NO;
    }
    
    if(!self.calendar.useCacheSystem){
        return [self.calendar.dataSource calendarHaveEvent:self.calendar date:date];
    }
    
    BOOL haveEvent;
    NSString *key = [dateFormatter stringFromDate:date];
    
    if(events[key] != nil){
        haveEvent = [events[key] boolValue];
    }
    else{
        haveEvent = [self.calendar.dataSource calendarHaveEvent:self.calendar date:date];
        events[key] = [NSNumber numberWithBool:haveEvent];
    }
    
    return haveEvent;
}


@end
