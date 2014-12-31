//
//  Constants.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 27/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#ifndef _HugMoment_Constants_h
#define _HugMoment_Constants_h

#pragma mark - ALl Pages
/*All Page*/
#define SYSTEM_PASSWORD @"Gfix0hVBUCNPf9wyKGiQ"
#define UPLOAD_VIDEO @"http://ws.9hug.com/api/message/update"
#define URL_GET_FOLLOW_ENDPOINT @"http://ws.9hug.com/api/client/login"
#define HALF_OF(x) (x/2)

#import <AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManagement.h"
#import "BaseServices.h"

#import "Utilities.h"
#import "AppDelegate.h"
#import "NavigationView.h"
#import <MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <GPUImage.h>

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+AutoLayout.h"

#import "UIView+Utils.h"
#import "UIAlertView+Helpers.h"
#import "UIView+AutoLayout.h"
#import "NSString+Helpers.h"

#define PUSH_CAPTURE_VIDEOVIEWCONTROLLER @"pushCaptureVideoViewController"
#define PRESENT_TRENDING @"trending"

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define APP_SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height

#define IS_IPHONE (([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location ==  NSNotFound)?FALSE:TRUE)
#define IS_HEIGHT_GTE_480 (([[UIScreen mainScreen ] bounds].size.height < 568)?TRUE:FALSE)
#define IS_IPHONE_4 (IS_IPHONE && IS_HEIGHT_GTE_480)
//320
#define IS_HEIGHT_GTE_568 ( (([[UIScreen mainScreen ] bounds].size.height >= 500) & ([[UIScreen mainScreen ] bounds].size.height < 600))?TRUE:FALSE)
#define IS_IPHONE_5 (IS_IPHONE && IS_HEIGHT_GTE_568)
//375
#define IS_HEIGHT_GTE_667 ( (([[UIScreen mainScreen ] bounds].size.height >= 600) & ([[UIScreen mainScreen ] bounds].size.height < 700))?TRUE:FALSE)
#define IS_IPHONE_6 (IS_IPHONE && IS_HEIGHT_GTE_667)
//414
#define IS_HEIGHT_GTE_736 (([[UIScreen mainScreen ] bounds].size.height >= 700)?TRUE:FALSE)
#define IS_IPHONE_6_PLUS (IS_IPHONE && IS_HEIGHT_GTE_736)

#pragma mark - Enums
//Enum
typedef NS_ENUM (NSInteger, MessageType){
    MessageTypeComment = 1,
    MessageTypePhoto,
    MessageTypeVote,
    MessageTypeVoice
};

typedef NS_ENUM(NSInteger, MomentDetailCellType)
{
    MomentDetailCellTypePlayer = 0,
    MomentDetailCellTypeUserInfo,
    MomentDetailCellTypeUpvoteMessage,
    MomentDetailCellTypeCommentHeader,
    MomentDetailCellTypeCommentMessage
};

#pragma mark - KEYS
// KEYS
#define KEY_TOKEN @"token"
#define KEY_ID @"id"
#define KEY_AGENT_ID @"agentid"
#define KEY_TYPE @"type"
#define KEY_STYLE @"style"
#define KEY_NOTIFICATION @"notification"
#define KEY_KEY @"key"
#define KEY_CODE @"code"
#define KEY_LENGTH @"length"
#define KEY_THUMB @"thumb"
#define KEY_ATTACHEMENT_1 @"attachement1"
#define KEY_ATTACHEMENT_2 @"attachement2"
#define KEY_TEXT @"text"
#define KEY_USER_ID @"userid"
#define KEY_FRAME_ID @"frameid"
#define KEY_CATEGORY @"category"
#define KEY_GENERATED_DATE @"generateddate"
#define KEY_CREATE_DATED @"createdated"
#define KEY_SCHEDULED @"scheduled"
#define KEY_SENT_DATE @"sentdate"
#define KEY_SENT_DATE_2 @"sent_date"
#define KEY_RECEIVER_ID @"receiverid"
#define KEY_RECEIVER_DATE @"receiveddate"
#define KEY_READS @"reads"
#define KEY_FULL_NAME @"fullname"
#define KEY_S_ECHO @"sEcho"
#define KEY_I_TOTAL_RECORDS @"iTotalRecords"
#define KEY_I_TOTAL_DISPLAY_RECORDS @"iTotalDisplayRecords"
#define KEY_AA_DATA @"aaData"
#define KEY_MESSAGE_ID @"message_id"
#define KEY_MESSAGE_STRING @"message"
#define KEY_MEDIA_LINK @"media_link"
#define KEY_VOTES @"votes"
#define KEY_TOTAL_VOTES @"totalvotes"
#define KEY_VOICES @"voices"
#define KEY_PHOTOS @"photos"
#define KEY_COMMENTS @"comments"
#define KEY_NICK_NAME @"nickname"
#define KEY_FACEBOOK_ID @"facebookid"
#define KEY_FACEBOOK_TOKEN @"facebook_token"
#define KEY_MOBILE @"mobile"
#define KEY_EMAIL @"email"
#define KEY_PASSWORD @"password"
#define KEY_CREATED_DATE @"createddate"
#define KEY_REFRESH_REQUEST @"refresh"
#define KEY_LATITUDE @"latitude"
#define KEY_LONGITUDE @"longitude"
#define KEY_LOCATION @"location"
//User setting key
#define KEY_USER_SETTING_LOGGED_IN_ID @"userSettingLoggedInID"
#define KEY_USER_SETTING_LOGGED_IN_TOKEN @"userSettingLoggedInToken"

#pragma mark - Services
// Services
#define URL_MESSAGE_GRCODE_BY_KEY @"http://ws.9hug.com/api/message/qrcode?key="

#pragma mark - Images Name
// Images Name
#define IMAGE_NAME_THUMB_PLACE_HOLDER @"icon_circle_gray"
#define IMAGE_NAME_ATTACHMENT_2_DEFAULT @"attachment_2_default"

#pragma mark - Identifier TableViewCell
// Identifier TableViewCell
#define IDENTIFIER_MOMENTS_MESSAGE_TABLE_VIEW_CELL @"identifierMomentsMessageTableViewCell"
#define IDENTIFIER_PLAYER_VIEW_TABLE_VIEW_CELL @"identifierPlayerViewTableViewCell"
#define IDENTIFIER_UP_VOTE_MESSAGE_TABLE_VIEW_CELL @"identifierUpvoteMessageTableViewCell"
#define IDENTIFIER_COMMENT_HEADER_TABLE_VIEW_CELL @"identifierCommentHeaderTableViewCell"
#define IDENTIFIER_COMMENT_MESSAGE_TABLE_VIEW_CELL @"identifierCommentMessageTableViewCell"
#define IDENTIFIER_USER_INFO_TABLE_VIEW_CELL @"identifierUserInfoTableViewCell"

#pragma mark - Fonts & Sizes
#define FONT_SIZE_DEFAULT_HUD [UIFont fontWithName:@"HelveticaNeue" size:14.0];

#pragma mark - FBConnectViewController
/*FBConnectViewController*/
#define objectLogin @"objectlogin"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import "UserData.h"
#import "FacebookManager.h"

#pragma mark - Categories
/*Categories*/
#import "UIView+Utils.h"
#import "UIAlertView+Helpers.h"
#import "MixEngine.h"
#import "NSString+Helpers.h"
#import "NSDictionary+Helpers.h"
#import "NSDate+Helpers.h"
#import "NSUserDefaults+Helpers.h"
#import "UIColor+Helpers.h"

#pragma mark - MixVideoViewController
/*MixVideoViewController*/
#define BG_COLOR_PROCESS_MIX_VIDEO [UIColor colorWithRed:224.0/255.0 green:100.0/255.0 blue:176.0/255.0 alpha:1.0]

#pragma mark - CaptureVideoViewController
/*CaptureVideoViewController*/
#define PointX 80
#define COLOR_PROCESS [UIColor colorWithRed:224.0/255.0 green:100.0/255.0 blue:176.0/255.0 alpha:1.0]
#define BG_COLOR_PROCESS [UIColor colorWithRed:43.0/255.0 green:42.0/255.0 blue:50.0/255.0 alpha:1.0]
#define KEY_DISTANCE @"key_distance"

#pragma mark - NavigationView
/*NavigationView*/
#define NAVIGATION_BAR_CUSTOM_DEFAULT_HEIGHT 44

#pragma mark - MomentsViewController
// MomentsViewController
#define HEIGHT_ROW_TABLE_VIEW_MOMENTS_VIEW_CONTROLLER 272
#define NUMBER_OF_SECTION_TABLE_VIEW_MOMENTS_VIEW_CONTROLLER 1
#define TITLE_BUTTON_NEW_MOMENTS @"New Moments"
#define CORNER_RADIUS 10
#define TITLE_BUTTON_NEW_MOMENTS_FONT_SIZE 12
#define HIGHT_BUTTON_NEW_MOMENTS 30
#define WIDTH_BUTTON_NEW_MOMENTS 50
#define CALL_PUSH_NOTIFICATIONS @"songsongsong"

#pragma mark - MomentsDetailViewController
// MomentsDetailViewController
#define SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER CGSizeMake(280, 200)
#define HEIGHT_USER_INFO_CELL_MOMENT_DETAIL_VIEW_CONTROLLER 90
#define HEIGHT_UP_VOTE_MESSAGE_DEFAULT_CELL_MOMENT_DETAIL_VIEW_CONTROLLER 70
#define HEIGHT_UP_VOTE_MESSAGE_NO_VOTE_CELL_MOMENT_DETAIL_VIEW_CONTROLLER 20
#define HEIGHT_COMMENT_HEADER_CELL_MOMENT_DETAIL_VIEW_CONTROLLER 30
#define HEIGHT_COMMENT_MESSAGE_CELL_MOMENT_DETAIL_VIEW_CONTROLLER 80

#define TIME_TO_SHOW_ENTER_MESSAGE_VIEW 0.3

#pragma mark - MomentsMessageTableViewCell
// MomentsMessageTableViewCell
#define WIGHT_RESET_BUTTON_MOMENTS_MESSAGE_TABLE_VIEW_CELL 65
#define TIME_TO_SHOW_RESET_BUTTON_MOMENTS_MESSAGE_TABLE_VIEW_CELL 0.3
#define NUMBER_OF_TOUCH_SWIPE_MOMENTS_MESSAGE_TABLE_VIEW_CELL 1

#pragma mark - UpvoteMessageTableViewCell
// UpvoteMessageTableViewCell
#define MARGIN_LEFT_DEFAULT_UP_VOTE_MESSAGE_TABLE_VIEW_CELL 20

#pragma mark - UserPhotoView
// UserPhotoView
#define HEIGHT_DEFAULT_USER_PHOTO_VIEW 40
#define WIDTH_DEFAULT_USER_PHOTO_VIEW 40
#define MARGIN_RIGHT_DEFAULT_USER_PHOTO_VIEW 5
#define MARGIN_TOP_DEFAULT_USER_PHOTO_VIEW 5

#pragma mark - MyMomentsViewController
// My Moments
#define TITLES_MYMOMENTS @"My Moments"
#define TRENDING_STORY_BOARD @"Trending"
#define MOMENTS_DETAILS_TRENDING_INDENTIFIER @"momentDetailsTrending"
#define CAPTURE_VIDEO_TRENDING_INDENTIFIER @"captureVideoTrending"

#endif
