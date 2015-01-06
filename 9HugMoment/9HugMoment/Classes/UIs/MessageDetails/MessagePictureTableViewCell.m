//
//  MessagePictureTableViewCell.m
//  9HugMoment
//

#import "MessagePictureTableViewCell.h"

@implementation MessagePictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showPictures
{
    [_picturesScrollView removeAllSubviews];
    if ((_pictureCommentObjectArray != (id)[NSNull null] && [_pictureCommentObjectArray isKindOfClass:[NSArray class]])) {
        int numberOfPicturePreview = (int)_pictureCommentObjectArray.count;
        int numberOfEmptyPicturePreview = 0;
        if (numberOfPicturePreview < NUMBER_DEFAULT_PICTURE_PREVIEW) {
            numberOfEmptyPicturePreview = NUMBER_DEFAULT_PICTURE_PREVIEW - numberOfPicturePreview;
            numberOfPicturePreview += numberOfEmptyPicturePreview;
        }
        for (int i = 0; i < numberOfPicturePreview; i++) {
            MessagePicturePreviewView *messagePicturePreviewView = [[MessagePicturePreviewView alloc] initWithFrame:CGRectZero];
            CGRect picturePreviewViewFrame = CGRectMake((i * WIGHT_MESSAGE_PICTURE_PREVIEW_VIEW) + (i * PADDING_LEFT_MESSAGE_PICTURE_PREVIEW_VIEW), 0, WIGHT_MESSAGE_PICTURE_PREVIEW_VIEW, HEIGHT_MESSAGE_PICTURE_PREVIEW_VIEW);
            messagePicturePreviewView.frame = picturePreviewViewFrame;
            if (i < (int)_pictureCommentObjectArray.count) {
                messagePicturePreviewView.commentObject = [_pictureCommentObjectArray objectAtIndex:i];
                [messagePicturePreviewView updatePictureData];
                messagePicturePreviewView.pictureIndex = [NSNumber numberWithInt:i];
            }
            else
            {
                messagePicturePreviewView.pictureIndex = [NSNumber numberWithInt:-1];
            }
            messagePicturePreviewView.delegate = self;
            [_picturesScrollView addSubview:messagePicturePreviewView];
        }
        _picturesScrollView.contentSize = CGSizeMake((numberOfPicturePreview * WIGHT_MESSAGE_PICTURE_PREVIEW_VIEW) + (INDEX_START_FROM_1_TO_0(numberOfPicturePreview) * PADDING_LEFT_MESSAGE_PICTURE_PREVIEW_VIEW), HEIGHT_MESSAGE_PICTURE_PREVIEW_VIEW);
    }
}

#pragma mark - MessageAudioPreviewView delegate
- (void)didClickPreviewImageButton:(MessagePicturePreviewView *)messagePicturePreviewView pictureIndex:(NSNumber *)pictureIndex
{
    if ((pictureIndex) && ([pictureIndex integerValue] != -1)
        && ((_pictureCommentObjectArray != (id)[NSNull null])
        && [_pictureCommentObjectArray isKindOfClass:[NSArray class]])) {
        SlideImageViewController *slideVC = [[SlideImageViewController alloc] initWithIndex:[pictureIndex integerValue]];
            NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
            for (CommentObject *comment in _pictureCommentObjectArray) {
                [imagesArray addObject:comment.mediaLink];
            }
            slideVC.arrImages = imagesArray;
            if (_delegate && [_delegate respondsToSelector:@selector(willShowSlideImageView:withCell:)])
            {
                [_delegate willShowSlideImageView:slideVC withCell:self];
            }
    }
}


@end
