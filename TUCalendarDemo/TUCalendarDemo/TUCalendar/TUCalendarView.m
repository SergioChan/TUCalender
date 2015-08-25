//
//  TUCalendarView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarView.h"

@implementation TUCalendarView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.dayFormat = @"dd";
    self.currentDate = [NSDate date];
    self->_dataCache = [TUCalendarDataCache new];
    self.dataCache.calendar = self;
    return self;
}

- (NSCalendar *)defaultCalendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
#ifdef __IPHONE_8_0
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

@end
