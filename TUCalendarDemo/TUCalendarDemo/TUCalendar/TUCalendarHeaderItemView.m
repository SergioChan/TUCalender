//
//  TUCalendarHeaderItemView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarHeaderItemView.h"

@interface TUCalendarHeaderItemView(){
    UILabel *monthLabel;
    UILabel *yearLabel;
    UIButton *prevButton;
    UIButton *nextButton;
}

@end

@implementation TUCalendarHeaderItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    monthLabel = [UILabel new];
    [self addSubview:monthLabel];
    
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.numberOfLines = 1;
    
    yearLabel = [UILabel new];
    [self addSubview:yearLabel];
    
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.numberOfLines = 1;
    
    prevButton = [UIButton new];
    [prevButton addTarget:self action:@selector(prevPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:prevButton];
    
    nextButton = [UIButton new];
    [nextButton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    NSDateFormatter *tmp= [[NSDateFormatter alloc] init];
    tmp.dateFormat = @"M yyyy";
    NSString *dateStr = [tmp stringFromDate:currentDate];
    NSInteger indexSep = [dateStr rangeOfString:@" "].location;
    
    monthLabel.text = [dateStr substringToIndex:indexSep];
    yearLabel.text = [dateStr substringFromIndex:indexSep];
}

- (void)layoutSubviews
{
    monthLabel.frame = CGRectMake(HEADER_MONTH_LABEL_LEFT, self.height - HEADER_MONTH_LABEL_HEIGHT - 5.0f - HEADER_YEAR_LABEL_HEIGHT, self.width - HEADER_MONTH_LABEL_LEFT * 2.0f , HEADER_MONTH_LABEL_HEIGHT);
    yearLabel.frame = CGRectMake(HEADER_MONTH_LABEL_LEFT, self.height - 5.0f - HEADER_YEAR_LABEL_HEIGHT, self.width - HEADER_MONTH_LABEL_LEFT * 2.0f, HEADER_YEAR_LABEL_HEIGHT);
    prevButton.frame = CGRectMake(HEADER_ARROW_LABEL_LEFT, monthLabel.top + 5.0f, 12.0f, 19.0f);
    nextButton.frame = CGRectMake(self.width - HEADER_ARROW_LABEL_LEFT - 12.0f,  monthLabel.top + 5.0f, 12.0f, 19.0f);
}

- (void)prevPage:(id)sender
{
    if(self.transferButtonPressed)
    {
        self.transferButtonPressed(0);
    }
}

- (void)nextPage:(id)sender
{
    if(self.transferButtonPressed)
    {
        self.transferButtonPressed(1);
    }
}

- (void)reloadLayout
{
    yearLabel.textColor = TUCalendar_GlobalTextColor;
    yearLabel.font = [UIFont systemFontOfSize:12.0f];
    monthLabel.textColor = [UIColor blackColor];
    monthLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    
    [prevButton setImage:[UIImage imageNamed:@"Backward"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"Forward"] forState:UIControlStateNormal];
}

@end
