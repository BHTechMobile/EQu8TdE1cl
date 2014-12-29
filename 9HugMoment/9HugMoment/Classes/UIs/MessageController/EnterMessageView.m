//
//  EnterMessageController.m
//  9hug
//
//  Created by setacinq on 6/25/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "EnterMessageView.h"
#import "QuartzCore/CALayer.h"

@interface EnterMessageView ()
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;
@end

@implementation EnterMessageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.0;
    _textView.text = @"";
}

- (IBAction)cancelButtonTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelInputMessage)]) {
        [_delegate didCancelInputMessage];
        [_textView resignFirstResponder];
    }
}

- (IBAction)doneButtonTapped:(id)sender {
    NSString *text = _textView.text;
    if (_delegate && [_delegate respondsToSelector:@selector(didEnterMessage:andMessage:)]) {
        [_delegate didEnterMessage:self andMessage:text];
        [_textView resignFirstResponder];
    }
}

@end
