// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: msg.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class LPBData;
@class LPBPrivilege;
@class LPBRule;
@class LPBUser;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - LPBMsgRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface LPBMsgRoot : GPBRootObject
@end

#pragma mark - LPBUser

typedef GPB_ENUM(LPBUser_FieldNumber) {
  LPBUser_FieldNumber_UserId = 1,
  LPBUser_FieldNumber_Name = 2,
  LPBUser_FieldNumber_Gender = 3,
  LPBUser_FieldNumber_Role = 4,
  LPBUser_FieldNumber_Level = 5,
  LPBUser_FieldNumber_Hao = 6,
  LPBUser_FieldNumber_MedalsArray = 7,
  LPBUser_FieldNumber_Avatar = 8,
  LPBUser_FieldNumber_FanId = 9,
};

@interface LPBUser : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

@property(nonatomic, readwrite, copy, null_resettable) NSString *gender;

@property(nonatomic, readwrite) int32_t role;

@property(nonatomic, readwrite) int32_t level;

@property(nonatomic, readwrite) int32_t hao;

@property(nonatomic, readwrite, strong, null_resettable) GPBInt32Array *medalsArray;
/** The number of items in @c medalsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger medalsArray_Count;

@property(nonatomic, readwrite, copy, null_resettable) NSString *avatar;

@property(nonatomic, readwrite) int32_t fanId;

@end

#pragma mark - LPBData

typedef GPB_ENUM(LPBData_FieldNumber) {
  LPBData_FieldNumber_Message = 1,
  LPBData_FieldNumber_Amount = 2,
  LPBData_FieldNumber_RewardName = 3,
  LPBData_FieldNumber_RewardImage = 4,
  LPBData_FieldNumber_Id_p = 5,
  LPBData_FieldNumber_IsBarrage = 6,
  LPBData_FieldNumber_ShowCountList = 7,
  LPBData_FieldNumber_AnimationURL = 8,
  LPBData_FieldNumber_ComboId = 9,
  LPBData_FieldNumber_ComboAmount = 10,
  LPBData_FieldNumber_SystemMessage = 11,
  LPBData_FieldNumber_RewardIndex = 12,
  LPBData_FieldNumber_BarrageType = 13,
  LPBData_FieldNumber_RewardName1 = 14,
  LPBData_FieldNumber_RewardImage1 = 15,
  LPBData_FieldNumber_LiveshowURL = 16,
  LPBData_FieldNumber_PodcasterName = 17,
  LPBData_FieldNumber_Template_p = 18,
  LPBData_FieldNumber_StreamType = 19,
  LPBData_FieldNumber_HlsPlayURL = 20,
  LPBData_FieldNumber_Mp3PlayURL = 21,
  LPBData_FieldNumber_Event = 23,
  LPBData_FieldNumber_RewardId = 24,
  LPBData_FieldNumber_Level = 25,
  LPBData_FieldNumber_NextLevel = 26,
  LPBData_FieldNumber_PrivilegesArray = 27,
  LPBData_FieldNumber_NextPrivilegesArray = 28,
  LPBData_FieldNumber_EndTime = 29,
  LPBData_FieldNumber_UserId = 30,
  LPBData_FieldNumber_ImgURL = 31,
  LPBData_FieldNumber_Title = 32,
  LPBData_FieldNumber_RedirectURL = 33,
  LPBData_FieldNumber_R = 34,
  LPBData_FieldNumber_T = 35,
  LPBData_FieldNumber_N = 36,
  LPBData_FieldNumber_Reco = 37,
  LPBData_FieldNumber_Status = 38,
  LPBData_FieldNumber_ProgramId = 39,
  LPBData_FieldNumber_AgoraKey = 40,
  LPBData_FieldNumber_AgoraKeyTtl = 41,
  LPBData_FieldNumber_Enter = 42,
  LPBData_FieldNumber_Notice = 43,
  LPBData_FieldNumber_RulesArray = 44,
  LPBData_FieldNumber_RedPacketId = 45,
  LPBData_FieldNumber_Shares = 46,
  LPBData_FieldNumber_EmptyAt = 47,
  LPBData_FieldNumber_ExpiresAt = 48,
  LPBData_FieldNumber_ClaimedAmount = 49,
  LPBData_FieldNumber_NickName = 50,
  LPBData_FieldNumber_Popup = 51,
  LPBData_FieldNumber_WaitLeftMs = 52,
};

@interface LPBData : GPBMessage

/** type message */
@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

/** type reward message */
@property(nonatomic, readwrite) int32_t amount;

@property(nonatomic, readwrite, copy, null_resettable) NSString *rewardName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *rewardImage;

@property(nonatomic, readwrite) int32_t id_p;

@property(nonatomic, readwrite) BOOL isBarrage;

@property(nonatomic, readwrite) BOOL showCountList;

@property(nonatomic, readwrite, copy, null_resettable) NSString *animationURL;

@property(nonatomic, readwrite) int64_t comboId;

@property(nonatomic, readwrite) int32_t comboAmount;

@property(nonatomic, readwrite, copy, null_resettable) NSString *systemMessage;

@property(nonatomic, readwrite) int32_t rewardIndex;

@property(nonatomic, readwrite) int32_t barrageType;

/** type horn reward message */
@property(nonatomic, readwrite, copy, null_resettable) NSString *rewardName1;

@property(nonatomic, readwrite, copy, null_resettable) NSString *rewardImage1;

@property(nonatomic, readwrite, copy, null_resettable) NSString *liveshowURL;

@property(nonatomic, readwrite, copy, null_resettable) NSString *podcasterName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *template_p;

/** type stream switch event */
@property(nonatomic, readwrite, copy, null_resettable) NSString *streamType;

@property(nonatomic, readwrite, copy, null_resettable) NSString *hlsPlayURL;

@property(nonatomic, readwrite, copy, null_resettable) NSString *mp3PlayURL;

@property(nonatomic, readwrite, copy, null_resettable) NSString *event;

/** type commbo End message */
@property(nonatomic, readwrite) int32_t rewardId;

/** type level upgrade message */
@property(nonatomic, readwrite) int32_t level;

@property(nonatomic, readwrite) int32_t nextLevel;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<LPBPrivilege*> *privilegesArray;
/** The number of items in @c privilegesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger privilegesArray_Count;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<LPBPrivilege*> *nextPrivilegesArray;
/** The number of items in @c nextPrivilegesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger nextPrivilegesArray_Count;

/** speak deny message */
@property(nonatomic, readwrite, copy, null_resettable) NSString *endTime;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

/** room image message */
@property(nonatomic, readwrite, copy, null_resettable) NSString *imgURL;

@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

@property(nonatomic, readwrite, copy, null_resettable) NSString *redirectURL;

/** type room rank message */
@property(nonatomic, readwrite) int32_t r;

@property(nonatomic, readwrite) int32_t t;

/** room online message */
@property(nonatomic, readwrite) int32_t n;

/** hostin_call event */
@property(nonatomic, readwrite) int32_t reco;

/** hostin_quit event */
@property(nonatomic, readwrite) int32_t status;

/** hostin_reco_update event */
@property(nonatomic, readwrite) int32_t programId;

/** hostin_accept event */
@property(nonatomic, readwrite, copy, null_resettable) NSString *agoraKey;

@property(nonatomic, readwrite) int32_t agoraKeyTtl;

/** welcome message */
@property(nonatomic, readwrite) int32_t enter;

/** notice update event */
@property(nonatomic, readwrite, copy, null_resettable) NSString *notice;

/** for link in notice and message */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<LPBRule*> *rulesArray;
/** The number of items in @c rulesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger rulesArray_Count;

/** for red packet messages */
@property(nonatomic, readwrite, copy, null_resettable) NSString *redPacketId;

@property(nonatomic, readwrite) int32_t shares;

@property(nonatomic, readwrite, copy, null_resettable) NSString *emptyAt;

@property(nonatomic, readwrite, copy, null_resettable) NSString *expiresAt;

@property(nonatomic, readwrite) int32_t claimedAmount;

@property(nonatomic, readwrite, copy, null_resettable) NSString *nickName;

@property(nonatomic, readwrite) BOOL popup;

@property(nonatomic, readwrite) int32_t waitLeftMs;

@end

#pragma mark - LPBRule

typedef GPB_ENUM(LPBRule_FieldNumber) {
  LPBRule_FieldNumber_Title = 1,
  LPBRule_FieldNumber_Link = 2,
};

@interface LPBRule : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

@property(nonatomic, readwrite, copy, null_resettable) NSString *link;

@end

#pragma mark - LPBPrivilege

typedef GPB_ENUM(LPBPrivilege_FieldNumber) {
  LPBPrivilege_FieldNumber_Icon = 1,
  LPBPrivilege_FieldNumber_Name = 2,
  LPBPrivilege_FieldNumber_Level = 3,
};

@interface LPBPrivilege : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *icon;

@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

@property(nonatomic, readwrite) int32_t level;

@end

#pragma mark - LPBBody

typedef GPB_ENUM(LPBBody_FieldNumber) {
  LPBBody_FieldNumber_Type = 1,
  LPBBody_FieldNumber_Data_p = 2,
  LPBBody_FieldNumber_User = 3,
};

@interface LPBBody : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *type;

/** google.protobuf.Struct data = 2; */
@property(nonatomic, readwrite, strong, null_resettable) LPBData *data_p;
/** Test to see if @c data_p has been set. */
@property(nonatomic, readwrite) BOOL hasData_p;

@property(nonatomic, readwrite, strong, null_resettable) LPBUser *user;
/** Test to see if @c user has been set. */
@property(nonatomic, readwrite) BOOL hasUser;

@end

#pragma mark - LPBMessage

typedef GPB_ENUM(LPBMessage_FieldNumber) {
  LPBMessage_FieldNumber_Type = 1,
  LPBMessage_FieldNumber_Data_p = 2,
  LPBMessage_FieldNumber_User = 3,
};

@interface LPBMessage : GPBMessage

/** Body body = 6; */
@property(nonatomic, readwrite, copy, null_resettable) NSString *type;

/** google.protobuf.Struct data = 2; */
@property(nonatomic, readwrite, strong, null_resettable) LPBData *data_p;
/** Test to see if @c data_p has been set. */
@property(nonatomic, readwrite) BOOL hasData_p;

@property(nonatomic, readwrite, strong, null_resettable) LPBUser *user;
/** Test to see if @c user has been set. */
@property(nonatomic, readwrite) BOOL hasUser;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
