//
//  MessagePicturePreviewView.m
//  9HugMoment
//

#import "MessagePicturePreviewView.h"

@implementation MessagePicturePreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeBorderView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Actions

- (IBAction)previewAction:(id)sender {
    //TODO: Click Preview
    if (_delegate && [_delegate respondsToSelector:@selector(didClickPreviewImageButton:pictureIndex:)])
    {
        [_delegate didClickPreviewImageButton:self pictureIndex:_pictureIndex];
    }
}

#pragma mark - Custom Methods

- (void)makeBorderView
{
    self.layer.cornerRadius = CORNER_RADIUS_MESSAGE_PICTURE_PREVIEW_VIEW;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = BORDER_COLOR_MESSAGE_PICTURE_PREVIEW_VIEW.CGColor;
    self.layer.borderWidth = BORDER_MESSAGE_PICTURE_PREVIEW_VIEW;
}

- (void)updatePictureData
{
    //TODO: updatePicture Data
    [_previewImageView sd_setImageWithURL:[NSURL URLWithString:_commentObject.mediaLink] placeholderImage:nil options:SDWebImageProgressiveDownload completed:NULL];
}

@end
