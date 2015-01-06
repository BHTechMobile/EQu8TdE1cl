//
//  MessageAudioPreviewView.m
//  9HugMoment
//

#import "MessageAudioPreviewView.h"

@implementation MessageAudioPreviewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_previewUserImageView.layer setMasksToBounds:YES];
    [_previewUserImageView.layer setCornerRadius:HALF_OF(_previewUserImageView.frame.size.width)];
    [_currentAudioSelectView.layer setMasksToBounds:YES];
    [_currentAudioSelectView.layer setCornerRadius:HALF_OF(_currentAudioSelectView.frame.size.width)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)previewUserAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickPreviewUserButton:)])
    {
        [_delegate performSelector:@selector(didClickPreviewUserButton:) withObject:self];
    }
}

- (void)updateAudioData
{
    //TODO: update Data
    [MessageDetailsModel getUserAvatarWithUserFacebookID:_commentObject.facebookID forImageView:_previewUserImageView];
}

@end
