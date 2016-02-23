//
//  RongUIKit.h
//  RongIMKit
//
//  Created by xugang on 15/1/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RongUIKit
#define __RongUIKit
#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>
#import "RCConversationViewController.h"
#import "RCThemeDefine.h"
/**
 *  收到消息的Notification，接收到消息后会通知。
 */
FOUNDATION_EXPORT NSString *const RCKitDispatchMessageNotification;

FOUNDATION_EXPORT NSString
    *const RCKitDispatchConnectionStatusChangedNotification;
/**
 *  获取用户信息。
 */
@protocol RCIMUserInfoDataSource <NSObject>

/**
 *  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion;
@end
/**
 *  获取群组信息。
 */
@protocol RCIMGroupInfoDataSource <NSObject>

/**
 *  获取群组信息。
 *
 *  @param groupId  群组ID.
 *  @param completion 获取完成调用的BLOCK.
 */

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion;

@end

/**
 *  获取用户在群组中的用户信息。可用于实现群名片功能.
 */
@protocol RCIMGroupUserInfoDataSource <NSObject>

/**
 *  获取用户在群组中的用户信息。
 *  如果该用户在该群组中没有设置群名片，请注意：1，不要调用别的接口返回全局用户信息，直接回调给我们nil就行，SDK会自己调用普通用户信息提供者获取用户信息；2一定要调用completion(nil)，这样SDK才能继续往下操作。
 *
 *  @param userId     用户 Id。
 *  @param groupId  群组ID.
 *  @param completion 获取完成调用的BLOCK.
 */
- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId
                     completion:(void (^)(RCUserInfo *userInfo))completion;

@end

/**
 @protocol RCIMReceiveMessageDelegate.
 接收消息的监听器。
 */
@protocol RCIMReceiveMessageDelegate <NSObject>

/**
 *  接收消息到消息后执行。
 *
 *  @param message 接收到的消息。
 *  @param left    剩余消息数.
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left;

@optional
/**
 *  App处于后台时，收到消息Notifiction处理。用户可以自定义通知，不实现SDK会处理。
 *
 *  @param message    收到的消息实体。
 *  @param senderName 发送者的名字
 *
 *  @return 返回NO，SDK处理通知；返回YES，App自定义通知栏，SDK不再展现通知。
 */
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message withSenderName:(NSString *)senderName;

/**
 *  App处于前台时，收到消息铃声处理。用户可以自定义新消息铃声，不实现SDK会处理。
 *
 *  @param message 收到的消息实体。
 *
 *  @return 返回NO，SDK处理铃声；返回YES，App自定义通知音，SDK不再播放铃音。
 */
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message;
@end

/**
 *  连接状态监听器，以获取连接相关状态。
 */
@protocol RCIMConnectionStatusDelegate <NSObject>

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status;
@end

/**
 *  融云UIKit核心单例
 */
@interface RCIM : NSObject
/**
 *  默认45*45
 */
@property(nonatomic) CGSize globalMessagePortraitSize;

/**
 *   导航按钮字体颜色
 */
@property(nonatomic) UIColor *globalNavigationBarTintColor;

/**
 *   头像边角，只有在头像样式为矩形时有效（矩形样式即默认样式）
 */
@property(nonatomic) CGFloat portraitImageViewCornerRadius;
/**
 *  默认45*45，高度最小只能为36
 */
@property(nonatomic) CGSize globalConversationPortraitSize;
/**
 *  默认RC_USER_AVATAR_RECTANGLE
 */
@property(nonatomic) RCUserAvatarStyle globalMessageAvatarStyle;
/**
 *  默认RC_USER_AVATAR_RECTANGLE
 */
@property(nonatomic) RCUserAvatarStyle globalConversationAvatarStyle;
/**
 *  自己的用户信息，开发者自己组装用户信息设置
 */
@property(nonatomic, strong) RCUserInfo *currentUserInfo;
/**
 *  默认NO，如果YES，发送消息会包含自己用户信息。
 */
@property(nonatomic, assign) BOOL enableMessageAttachUserInfo;
/**
 *  用户信息提供者
 */
@property(nonatomic, weak) id<RCIMUserInfoDataSource> userInfoDataSource;
/**
 *  群组信息提供者
 */
@property(nonatomic, weak) id<RCIMGroupInfoDataSource> groupInfoDataSource;
/**
 *  群组内用户信息提供者。可用于群名片等功能
 */
@property(nonatomic, weak) id<RCIMGroupUserInfoDataSource> groupUserInfoDataSource;
/**
 * 接收消息的监听器。如果使用IMKit，使用此方法，不再使用RongIMLib的同名方法。
 */
@property(nonatomic, weak)
    id<RCIMReceiveMessageDelegate> receiveMessageDelegate;
/**
 *  状态监听
 */
@property(nonatomic, weak)
    id<RCIMConnectionStatusDelegate> connectionStatusDelegate;
/**
 *  消息免通知，默认是NO
 */
@property(nonatomic, assign) BOOL disableMessageNotificaiton;
/**
 *  关闭新消息提示音，默认值是NO，新消息有提示音.
 */
@property(nonatomic, assign) BOOL disableMessageAlertSound;

/**
 *  显示未注册的消息，默认值是NO。
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  会话界面开发者可以通过rcUnkownConversationCollectionView:cellForItemAtIndexPath:和rcUnkownConversationCollectionView:layout:sizeForItemAtIndexPath:方法定制
 *  会话列表界面可以通过修改unknown_message_cell_tip字符串资源进行定制
 */
@property(nonatomic, assign) BOOL showUnkownMessage;

/**
 *  未知的消息显示本地通知，默认值是NO。
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  可以通过修改unknown_message_notification_tip字符串资源进行定制
 */
@property(nonatomic, assign) BOOL showUnkownMessageNotificaiton;

/**
 获取界面组件的核心类单例。

 @return 界面组件的核心类单例。
 */
+ (instancetype)sharedRCIM;

/**
 初始化 SDK。如果使用IMKit，使用此方法，不再使用RongIMLib的同名方法。

 @param appKey   从开发者平台申请的应用 appKey。
 */
- (void)initWithAppKey:(NSString *)appKey;

/**
 *  注册消息类型，如果使用IMKit，使用此方法，不再使用RongIMLib的同名方法。如果对消息类型进行扩展，可以忽略此方法。
 *
 *  @param messageClass   消息类型名称，对应的继承自 RCMessageContent
 *的消息类型。
 */

- (void)registerMessageType:(Class)messageClass;

/**
 建立连接，注意该方法回调在非调用线程，如果需要UI操作，请切换主线程，如果使用IMKit，使用此方法，不再使用RongIMLib的同名方法。

 @param token               从服务端获取的用户身份令牌（Token）。
 @param successBlock        调用完成的处理。
 @param errorBlock          调用返回的错误信息。
 @param tokenIncorrectBlock token错误或者过期。需要重新换取token，但需要注意避免出现无限循环。
 */
- (void)connectWithToken:(NSString *)token
                 success:(void (^)(NSString *userId))successBlock
                   error:(void (^)(RCConnectErrorCode status))errorBlock
          tokenIncorrect:(void (^)())tokenIncorrectBlock;

/**
 *  断开连接。如果使用IMKit，使用此方法，不再使用RongIMLib的同名方法。
 *
 *  @param isReceivePush 是否接收push消息。
 */
- (void)disconnect:(BOOL)isReceivePush;

/**
 *  断开连接。如果使用IMKit，使用此方法，不再使用RongIMLib的同名方法。
 */
- (void)disconnect;

/**
 *  Log out。不会接收到push消息。
 */
- (void)logout;

/**
 *  拨打VoIP电话
 *  @param targetId 对方userId
 */
- (void)startVoIPCallWithTargetId:(NSString *)targetId;

/**
 * 本地用户信息改变，调用此方法更新kit层用户缓存信息
 * @param userInfo 要更新的用户实体
 * @param userId  要更新的用户Id
 */
- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
                 withUserId:(NSString *)userId;

/**
 * 本地群组信息改变，调用此方法更新kit层群组缓存信息
 * @param groupInfo 要更新的群组实体
 * @param groupId  要更新的群组Id
 */
- (void)refreshGroupInfoCache:(RCGroup *)groupInfo
                 withGroupId:(NSString *)groupId;

/**
 * 本地群组内用户信息改变，调用此方法更新kit层群组缓存信息
 * @param userInfo 要更新的用户实体
  * @param userId  要更新的用户Id
 * @param groupId  要更新的群组Id
 */
- (void)refreshGroupUserInfoCache:(RCUserInfo *)userInfo withUserId:(NSString *)userId withGroupId:(NSString *)groupId;
/**
 *  清除所有本地用户信息的缓存。
 */
- (void)clearUserInfoCache;

/**
 *  清除所有本地群组信息的缓存。
 */
- (void)clearGroupInfoCache;

/**
 *  发送消息，可以发送任何类型的消息，会自动更新UI。
 *  注：如果通过该接口发送图片消息，需要自己实现上传图片，把imageUrl传入content（注意它将是一个RCImageMessage）。
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          消息内容。
 *  @param pushContent      推送消息内容
 *  @param pushData         推送消息附加信息
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 *
 *  @return 发送的消息实体。
 */
- (RCMessage *)sendMessage:(RCConversationType)conversationType
                  targetId:(NSString *)targetId
                   content:(RCMessageContent *)content
               pushContent:(NSString *)pushContent
                  pushData:(NSString *)pushData
                   success:(void (^)(long messageId))successBlock
                     error:(void (^)(RCErrorCode nErrorCode,
                                     long messageId))errorBlock;

/**
 *  发送图片消息，上传图片并且发送，会自动更新UI。
 *  使用该方法，默认原图会上传到融云的服务，并且发送消息,如果使用普通的sendMessage方法，
 *  需要自己实现上传图片，并且添加ImageMessage的URL之后发送
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          消息内容
 *  @param pushContent      推送消息内容
 *  @param pushData         推送消息附加信息
 *  @param progressBlock    进度块
 *  @param successBlock     成功处理块
 *  @param errorBlock       失败处理块
 *
 *  @return 发送的消息实体。
 */
- (RCMessage *)sendImageMessage:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                        content:(RCMessageContent *)content
                    pushContent:(NSString *)pushContent
                       pushData:(NSString *)pushData
                       progress:(void (^)(int progress, long messageId))progressBlock
                        success:(void (^)(long messageId))successBlock
                          error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock;

/**
 *  发送图片消息，由APP实现上传图片。
 *  请在uploadPrepareBlock中上传图片，并通知融云上传进度和结果
 *
 *  @param conversationType   会话类型。
 *  @param targetId           目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content            消息内容
 *  @param pushContent        推送消息内容
 *  @param pushData         推送消息附加信息
 *  @param uploadPrepareBlock 应用上传图片Block
 *  @param progressBlock      进度块
 *  @param successBlock       成功处理块
 *  @param errorBlock         失败处理块
 *
 *  @return 发送的消息实体。
 */
- (RCMessage *)sendImageMessage:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                        content:(RCMessageContent *)content
                    pushContent:(NSString *)pushContent
                       pushData:(NSString *)pushData
                  uploadPrepare:(void (^)(RCUploadImageStatusListener *uploadListener))uploadPrepareBlock
                       progress:(void (^)(int progress, long messageId))progressBlock
                        success:(void (^)(long messageId))successBlock
                          error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock;

@end

#endif