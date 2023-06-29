//
//  JKUrlConst.m
//  YCJieJiGame
//
//  Created by John on 2023/5/18.
//

#import "JKUrlConst.h"



/***************  Api 地址大合集  **************/

///基本后台 url key
NSString * const JKBaseApiURLKey = @"BaseApiURLKey";
///Web url  key
NSString * const JKWebURLKey = @"WebURLKey";

///默认基础api 地址
NSString * const JKDefaultBaseApiURL = @"https://jjdwc-api.5iwanquan.com/api";
///默认Web 地址
NSString * const JKDefaultWebURL = @"";
// 服务端地址
NSString * const JKBaseUrlKey = @"BaseUrlKey";
// 用户协议
NSString * const JKUserAgreementUrlKey = @"http://jjdwc-site.5iwanquan.com/user.html";
NSString * const JKUserAgreement_ENUrlKey = @"http://jjdwc-site.5iwanquan.com/user_en.html";
// 隐私政策
NSString * const JKPrivacyPolicyUrlKey = @"http://jjdwc-site.5iwanquan.com/policy.html";
NSString * const JKPrivacyPolicy_ENUrlKey = @"http://jjdwc-site.5iwanquan.com/policy_en.html";


// 签到列表
NSString * const JKSigninListUrlKey = @"signList/v2";
// 确认签到
NSString * const JKSigninUrlKey = @"sign/v2";


// 积分排行榜
NSString * const JKJifenRankUrlKey = @"summary/rank/point/v2";
// 充值排行榜
NSString * const JKChongzhiRankUrlKey = @"summary/rank/diamond/v2";

// 积分兑换金币列表
NSString * const JKJifen2JBListUrlKey = @"pm/option";
// 积分兑换金币
NSString * const JKJifen2JBUrlKey = @"pm/exchange/coin";
// 钻石兑换金币
NSString * const JKZuanshi2JBUrlKey = @"member/exchange/gold";

// 游戏记录
NSString * const JKGameListUrlKey = @"doll/log";
// 抓取记录
NSString * const JKFetchListUrlKey = @"doll/log";

// 街机记录明细
NSString * const JKJieJISettleListUrlKey = @"doll/settle/info";
// 推币机娃娃机记录明细
NSString * const JKTuiBiJiSettleListUrlKey = @"doll/log/info";

// 申诉列表
NSString * const JKGameShensuListUrlKey = @"doll/appeal/log";
// 申诉明细
NSString * const JKGameShensuDetailUrlKey = @"doll/appeal/info";

// 街机申诉
NSString * const JKJieJiGameShensuUrlKey = @"doll/settle/appeal";
// 推币机娃娃机申诉
NSString * const JKTuiBiJiGameShensuUrlKey = @"doll/appeal/v15";

// 消费明细
NSString * const JKDollMoneyListUrlKey = @"doll/money/source/list";

// 游戏攻略
NSString * const JKGameIntroListUrlKey = @"game/intro/list";
// 游戏攻略详情
NSString * const JKGameIntroDetailUrlKey = @"game/intro/info";

// 会员详情
NSString * const JKHuiyuanDetailUrlKey = @"user/info/v2";
// 输入邀请码
NSString * const JKInputInviteCodeUrlKey = @"invite/code";
// 邀请信息
NSString * const JKInviteCodeInfoUrlKey = @"invite/v2";
// 账号注销
NSString * const JKAccountCancelUrlKey = @"member/cancel/v2";
// 用户信息修改
NSString * const JKAccountModifyUrlKey = @"user/edit";
// 实名认证
NSString * const JKAccountAuthUrlKey = @"user/name/auth";

// 阿里云认证，获取手机号
NSString * const JKALYPhoneGetUrlKey = @"user/aliyun/one_key_login";
// 手机号一键登录
NSString * const JKOneKeyLoginUrlKey = @"user/mobile/one_key_login";
// Apple登录
NSString * const JKAppleLoginUrlKey = @"apple/login";

// 充值选项
NSString * const JKChargeListUrlKey = @"charge/list/channel/v3";
// IOS创建订单
NSString * const JKIOSChongZhiDingDanUrlKey = @"charge/ios/create/order";
// IOS充值
NSString * const JKIOSChongZhiUrlKey = @"charge/ios/pay/v3";

// 房间分类
NSString * const JKGameRoomCategoryUrlKey = @"room/group/list";
// 房间分类
NSString * const JKGameRoomListUrlKey = @"room/list";
// 进入房间
NSString * const JKGameRoomEnterUrlKey = @"room/enter/v2";
// 房间分类
NSString * const JKGameRoomCategoryDetailUrlKey = @"room/category/info";
