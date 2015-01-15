//
//  ScheduleView.m
//  9hug
//
//  Created by setacinq on 6/30/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "ScheduleView.h"

@interface ScheduleView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)controlTapped:(id)sender;
- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;

@end

@implementation ScheduleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _datePicker.minimumDate = [NSDate date];
}

- (IBAction)controlTapped:(id)sender {
    [self hideWithAnimation];
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
}

-(NSDate*)getSelectedDate
{
    return _datePicker.date;
}
@end
