//
//  UserDetailsObject.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

@interface UserDetailsObject : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *facebookToken;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *createdDate;

+ (UserDetailsObject *)createUserByDictionnary:(NSDictionary *)dict;

@end
