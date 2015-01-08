//
//  SlideImageViewController.m
//  DepVD
//
//  Created by Quynh Nguyen on 7/17/14.
//  Copyright (c) 2014 Quynh Nguyen. All rights reserved.
//

#import "SlideImageViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <FacebookSDK/FacebookSDK.h>

#define kImageBack                      [UIImage imageNamed:@"back_btn.png"]
#define kImageDownload                  [UIImage imageNamed:@"SacveImage.png"]
#define kImageShare                     [UIImage imageNamed:@"share.png"]
#define kImageBackgroundNavigation      [UIImage imageNamed:@"nav_bar_bg.png"]
#define IS_IOS_7_OR_LATER       SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define MAIN_SCREEN_HEIGHT          (SYSTEM_VERSION_LESS_THAN(@"7.0") ? [[UIScreen mainScreen] bounds].size.height - 20 : [[UIScreen mainScreen] bounds].size.height)

#define kHeightNavigationBar    44
#define kBgColorOverlay                 [UIColor colorWithWhite:0. alpha:0.3f]
#define MAIN_SCREEN_WIDTH           [[UIScreen mainScreen] bounds].size.width
#define MAIN_SCREEN_ORIGIN_Y        (IS_IOS_7_OR_LATER ? 20 : 0)

#define kTagShare               1

CGFloat const kMinZoomScale = 0.5f;
CGFloat const kMaxZoomScale = 2.2f;
CGFloat const kInitialZoomScale = 0.5f;

@interface SlideImageViewController () <UIScrollViewDelegate,UIActionSheetDelegate>
{
    // background
    UIImageView *_backgroundView;
    
    //  scroll
    UIScrollView        *_scrollView;
    
    // overlayTop
    UIView          *_overlayTopView;
    UIButton        *_backButton;
    UIButton        *_downloadButton;
    UIButton        *_shareButton;
    
    // overlayBottom
    UIView          *_overlayBottomView;
    UILabel         *_indexOfTotalImage;
    
    //  source
    NSInteger           _index;
    
    CGFloat             _lastOffset;
    CGPoint             mPreviousTouchPoint;
    
    //
}
@property (strong, atomic) ALAssetsLibrary* library;
@end

@implementation SlideImageViewController

#pragma mark - memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (id)initWithIndex:(NSInteger)index
{
    if (self = [super init]) {
        _index = index;
        [self initBase];
    }
    return self;
}

#pragma mark - viewcontroller life-cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_backgroundView];
	
    [self loadContentview];
    [self loadOverlayTop];
    [self loadOverlayBottom];
    [self loadData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)loadOverlayTop
{
    
    // nếu là iOS7 thì để navigationbar có frame = {0 0, 320 44+20}
    // nếu là iOS6 thì để navigationbar có frame = {0 0, 320 44}
    CGFloat delta = 0;
    if (IS_IOS_7_OR_LATER) {
        delta = 20;
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = kHeightNavigationBar + delta;
    
    _overlayTopView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _overlayTopView.backgroundColor = kBgColorOverlay;
    [self.view addSubview:_overlayTopView];
    
    //
    w = h = 54;
    x = 5;
    y = delta + (kHeightNavigationBar - h) / 2;
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [_backButton setTitle:@"Close" forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_overlayTopView addSubview:_backButton];
    
    //
    w = h = 28;
    x = (_overlayTopView.bounds.size.width - w) - 28;
    y = delta + (kHeightNavigationBar - h) / 2;
    _downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [_downloadButton setBackgroundImage:kImageDownload forState:UIControlStateNormal];
//    [_downloadButton setBackgroundColor:[UIColor redColor]];
    [_downloadButton addTarget:self action:@selector(downloadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_overlayTopView addSubview:_downloadButton];
    
    //
    w = h = 34;
    x = _overlayTopView.bounds.size.width - w - 5;
    y = delta + (kHeightNavigationBar - h) / 2;
    _downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [_downloadButton setBackgroundImage:kImageShare forState:UIControlStateNormal];
    [_downloadButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_overlayTopView addSubview:_downloadButton];
    
}



- (void)loadOverlayBottom
{
    
    CGFloat x = 0;
    CGFloat y = MAIN_SCREEN_HEIGHT - kHeightNavigationBar;
    CGFloat w = MAIN_SCREEN_WIDTH;
    CGFloat h = kHeightNavigationBar;
    _overlayBottomView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _overlayBottomView.backgroundColor = kBgColorOverlay;
    [self.view addSubview:_overlayBottomView];
    
    //
    _indexOfTotalImage = [[UILabel alloc] initWithFrame:_overlayBottomView.bounds];
    _indexOfTotalImage.backgroundColor = [UIColor clearColor];
    _indexOfTotalImage.textAlignment = NSTextAlignmentCenter;
    _indexOfTotalImage.textColor = [UIColor whiteColor];
    _indexOfTotalImage.text = [self getTextIndexOfTotal];
    _indexOfTotalImage.font = [UIFont systemFontOfSize:15];
    [_overlayBottomView addSubview:_indexOfTotalImage];
    
}

- (void)loadContentview
{
    
    CGFloat x = 0;
    CGFloat y = MAIN_SCREEN_ORIGIN_Y;
    CGFloat w = MAIN_SCREEN_WIDTH;
    CGFloat h = MAIN_SCREEN_HEIGHT - y;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = kMaxZoomScale;
    _scrollView.minimumZoomScale = kMinZoomScale;
    _scrollView.zoomScale = 1.;
    _scrollView.tag = 1000;
    [self.view addSubview:_scrollView];
    
}


#pragma mark - methods
- (void)initBase
{
    
    
    
}

- (void)loadData
{
    
    //  remove all subview
    for (UIView *subview in _scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    //  add image to view
    for (int i=0 ; i<_arrImages.count ; i++) {
        //  add scrollImage to scroll main
        CGFloat x = i * _scrollView.bounds.size.width;
        CGFloat y = 0;
        CGFloat w = _scrollView.bounds.size.width;
        CGFloat h = _scrollView.bounds.size.height;
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        imageScrollView.backgroundColor = [UIColor clearColor];
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.maximumZoomScale = 2.f;
        imageScrollView.minimumZoomScale = 1.f;
        imageScrollView.tag = i+100;
        [_scrollView addSubview:imageScrollView];
        
        //  add image to scrollImage
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageScrollView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSURL *imageURL = [NSURL URLWithString:[_arrImages objectAtIndex:i]];
        NSString *key = [imageURL.absoluteString MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            imageView.image = image;
        } else {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
            });
        }
        imageView.tag = i;
        [imageScrollView addSubview:imageView];
        
    }
    
    //  set contentSize + contentOffset
    _scrollView.contentSize = CGSizeMake(_arrImages.count * _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    _scrollView.contentOffset = CGPointMake(_index * _scrollView.bounds.size.width, 0);
    
}

- (NSString*)getTextIndexOfTotal
{
    return [NSString stringWithFormat:@"%d/%d", (int)_index + 1, (int)_arrImages.count];
}

- (NSInteger)pendingPage
{
    CGFloat offsetX = _scrollView.contentOffset.x;
    CGFloat pageWidth = _scrollView.bounds.size.width;
    
    NSInteger page = ceilf(offsetX / pageWidth);
    
    NSLog(@"%d", page);
    return page;
}

- (void)shareAlbum
{
  
}

- (void)shareImageActive
{
   
}

#pragma mark - events
- (void)tapView:(UITapGestureRecognizer*)sender
{
    [UIView animateWithDuration:0.35 animations:^{
        _overlayTopView.alpha = _overlayTopView.alpha == 1.f ? 0.f : 1.f;
        _overlayBottomView.alpha = _overlayBottomView.alpha == 1.f ? 0.f : 1.f;
    }];
}

- (void)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)downloadButtonPressed:(id)sender
{
        UIImageWriteToSavedPhotosAlbum((UIImage *)[_arrImages objectAtIndex:_index], nil, nil, nil);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)shareButtonPressed:(id)sender
{
   
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case kTagShare:
        {
            switch (buttonIndex) {
                case 0:
                {
                    [self shareAlbum];
                    break;
                }
                case 1:
                {
                    [self shareImageActive];
                    break;
                }
            }
            break;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    mPreviousTouchPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth) / pageWidth) + 1;
    if (sender.contentOffset.x >= 0) {
        _index = page;  // index image current
        _indexOfTotalImage.text = [NSString stringWithFormat:@"%d/%d", page + 1, _arrImages.count];
    }
    //Mapping values from 0-1024(subview frame) to 0-1(alpha range)
    float NewMax = 1;
    float NewMin = 0;
    float OldMax = pageWidth * (page+1);
    float OldMin = pageWidth * page;
    
    int OldValue = sender.contentOffset.x;//doubth
    float newValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin;
    
    //If it is scrolling to right applying animation to next page
    page = page+1;
    
    //If it is scrolling to left applying animation to previous page
    if(mPreviousTouchPoint.x > sender.contentOffset.x)
        page = page - 1;
    
    if(page < 0 || page >= _arrImages.count)
        return;
    
    //Applying alpha to the subview, where mSubviewsArray contains all the subviews of a       //scrollview
    UIView *nextPage = [[_scrollView subviews] objectAtIndex:page];
    if(nextPage)
    {
        if(mPreviousTouchPoint.x > sender.contentOffset.x)
            nextPage.alpha = 1. - newValue;
        else
            nextPage.alpha = newValue;
    }
    
}


@end
