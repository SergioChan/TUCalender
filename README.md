# TUCalender

## Brief Intro

This is a custom calendar view based on [JTCalendar](https://github.com/jonathantribouharet/JTCalendar). Customize and localize to meet other requirements of our own. Will not be updated with JTCalendar.

## Screenshots
![image](https://raw.githubusercontent.com/tataUFO/TUCalender/master/screenShots.png)

## Features
* Weekend day special appearance
* custom selected state


## Usage
If you are using storyboard or xib file , add constraints to make it work as the demo shows.

If you are using code initialization , add following constraint to make it work:


```Objective-C
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.TUcalendarHeaderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.TUcalendarHeaderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.TUcalendarContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.TUcalendarContentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
```

## License

TUCalendar is released under the MIT license. See the LICENSE file for more info.