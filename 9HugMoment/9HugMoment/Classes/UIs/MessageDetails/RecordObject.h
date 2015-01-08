//
//  RecordObject.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

typedef void (^UploadBlock)(id response, NSError *error);

@class RecordObject;
@protocol RecordObjectDelegate <NSObject>
- (void)updateCurrentTimeRecord:(NSString *)timeRecord withRecorObject:(RecordObject *)recordObject;

@end

@interface RecordObject : NSObject<AVAudioRecorderDelegate>
{
    NSTimer *_recordTimmer;
    
}

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (assign, nonatomic) BOOL isRecordSuccess;
@property (weak, nonatomic) id<RecordObjectDelegate> delegate;

- (void)showRecordView:(UIView *)recordView withParentView:(UIView *)parentView;
- (void)hideRecordView:(UIView *)recordView;
- (void)uploadAudioMessageWithMessageID:(NSString *)messageID completed:(UploadBlock)finished;

@end
