//
//  WwCodeDef.h
//  WawaSDK
//
//  Copyright © 2017年 杭州阿凡达网络科技有限公司 All rights reserved.
//

#ifndef WwCodeDef_h
#define WwCodeDef_h


typedef NS_ENUM(NSInteger, WwCode) {
    WwCodeSuccess = 0,
    WwCodeErrorNotFound  = -50000,                      /**< 目标不存在*/
    WwCodeErrorParamIllegal = -50001,                   /**< 非法参数*/
    WwCodeErrorInChecking = -50002,                     /**< SDK正在进行注册请求*/
    WwCodeErrorRegisterServerExcep = -50003,            /**< 注册服务异常*/
    WwCodeErrorLoginServerExcep    = -50004,            /**< 登陆服务异常*/
    
    WwCodeErrorInRoom   = -50100,                       /**< 房间内错误*/
    WwCodeErrorUploadingPortrait = -50201,              /**< 正在上传头像*/
};

typedef NS_ENUM(NSInteger, WwRtmpPush) {
    WwRtmpPushSuccess = 0,                              /**< 推流成功*/
    WwRtmpPushFail = 1,                                 /**< 推流失败*/
};

typedef NS_ENUM(NSInteger, WWRtmpPlay) {
    WWRtmpPlaySuccess = 0,                              /**< 拉流成功*/
    WWRtmpPlayFail = 1,                                 /**< 拉流失败*/
};

typedef NS_ENUM (NSInteger, PlayerErrorCode) {
    Ww_DEVICE_CONNECT_COUNT_LIMIT = 380045,             //设备直连取流连接数量过大
    Ww_DEVICE_COMMAND_NOT_SUPPORT = 380047,             //设备不支持该命令
    Ww_DEVICE_CAS_PARSE_ERROR = 380205,                 //设备检测入参异常
    Ww_PLAY_TIMEOUT = 380209,                           //网络连接超时
    Ww_DEVICE_TIMEOUT = 380212,                         //设备端网络连接超时
    Ww_STREAM_CLIENT_TIMEOUT = 390038,                  //同时`390037`手机网络引起的取流超时
    Ww_STREAM_CLIENT_OFFLINE = 395404,                  //设备不在线
    Ww_STREAM_CLIENT_DEVICE_COUNT_LIMIT = 395410,       //设备连接数过大
    Ww_STREAM_CLIENT_NOT_FIND_FILE = 395402,            //回放找不到录像文件，检查传入的回放文件是否正确
    Ww_STREAM_CLIENT_TOKEN_INVALID = 395406,            //取流token验证失效
    Ww_STREAM_CLIENT_CAMERANO_ERROR = 395415,           //设备通道错
    /**
     *  HTTP 错误码
     */
    Ww_HTTPS_PARAM_ERROR = 110001,                      //请求参数错误
    Ww_HTTPS_CAMERA_NOT_EXISTS = 120001,                //通道不存在，请检查摄像头设备是否重新添加过
    Ww_HTTPS_DEVICE_NOT_EXISTS = 120002,                //设备不存在
    Ww_HTTPS_DEVICE_NETWORK_ANOMALY = 120006,           //网络异常
    Ww_HTTPS_DEVICE_OFFLINE = 120007,                   //设备不在线
    Ww_HTTPS_DEIVCE_RESPONSE_TIMEOUT = 120008,          //设备请求响应超时异常
    Ww_HTTPS_ILLEGAL_DEVICE_SERIAL = 120014,            //不合法的序列号
    Ww_HTTPS_DEVICE_STORAGE_FORMATTING = 120016,        //设备正在格式化磁盘
    Ww_HTTPS_DEVICE_ONLINE_NOT_ADDED = 120021,          //设备在线，未被用户添加
    Ww_HTTPS_DEVICE_ONLINE_IS_ADDED = 120022,           //设备在线，已经被别的用户添加
    Ww_HTTPS_DEVICE_OFFLINE_NOT_ADDED = 120023,         //设备不在线，未被用户添加
    Ww_HTTPS_DEVICE_OFFLINE_IS_ADDED = 120024,          //设备不在线，已经被别的用户添加
    Ww_HTTPS_DEVICE_OFFLINE_IS_ADDED_MYSELF = 120029,   //设备不在线，但是已经被自己添加
    Ww_HTTPS_SERVER_DATA_ERROR = 149999,                //数据异常
    Ww_HTTPS_SERVER_ERROR = 150000,                     //服务器异常
    Ww_HTTPS_DEVICE_PTZ_NOT_SUPPORT = 160000,           //设备不支持云台控制
    Ww_HTTPS_DEVICE_COMMAND_NOT_SUPPORT = 160020,       //设备不支持该命令
    
    /**
     *  接口 错误码(SDK本地校验)
     */
    Ww_SDK_PARAM_ERROR = 400002,                        //接口参数错误
    Ww_SDK_NOT_SUPPORT_TALK = 400025,                   //设备不支持对讲
    Ww_SDK_TIMEOUT = 400034,                            //无播放token，请stop再start播放器
    Ww_SDK_NEED_VALIDATECODE = 400035,                  //需要设备验证码
    Ww_SDK_VALIDATECODE_NOT_MATCH = 400036,             //设备验证码不匹配
    Ww_SDK_DECODE_TIMEOUT = 400041,                     //解码超时，可能是验证码错误
    Ww_SDK_STREAM_TIMEOUT = 400015,                     //取流超时,请检查手机网络
    Ww_SDK_PLAYBACK_STREAM_TIMEOUT = 400409,            //回放取流超时,请检查手机网络
};

typedef NS_ENUM (NSInteger, WwComplainResultType) {
    WwComplainResultTypeNone = -1001,                   //没有申述
    WwComplainResultTypeRefuse = -1,                    //申诉已被拒绝
    WwComplainResultTypeAuditing = 1,                   //申诉正在处理
    WwComplainResultTypeAudited = 2,                    //申诉已结束
    WwComplainResultTypeRefund = 3,                     //申述已退款
};

typedef NS_ENUM(NSInteger, WwReportType) {
    WwReportTypeOther = 0,                              //其他内容
    WwReportTypePorno = 1,                              //色情低俗
    WwReportTypePolitical = 2,                          //政治敏感
    WwReportTypeAD = 3,                                 //广告欺诈
    WwReportTypeAbuse = 4,                              //骚扰谩骂
};


#endif /* WwCodeDef_h */
