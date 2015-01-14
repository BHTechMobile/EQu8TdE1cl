//
//  VideoFilterActionView.m
//  9hug
//
//  Created by Tommy on 10/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "VideoFilterActionView.h"

@interface VideoFilterActionView ()

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *downloadFilterImageView;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;

@end

@implementation VideoFilterActionView

- (void)awakeFromNib{
    [super awakeFromNib];
}


#pragma mark - Custom Methods

-(void)setFilterName:(NSString *)filterName{
    self.filterNameLabel.text = filterName;
}
-(void)setThumbnailImage:(UIImage *)thumbnailImage{
    self.thumbnailImageView.image = thumbnailImage;
}

- (void)hideDownloadImageView:(BOOL)yesOrNo{
    self.downloadFilterImageView.hidden = yesOrNo;
}

- (void)showSelectionView:(BOOL)yesOrNo{
    self.selectedImage.hidden = !yesOrNo;
}

#pragma mark - Actions

- (IBAction)filterAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickFilter:)]) {
        [_delegate performSelector:@selector(didClickFilter:) withObject:self];
    }
}

@end
