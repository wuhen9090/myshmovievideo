//
//  RACNetWorkManager.h
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/23.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kTimeOutInterval 30 // 请求超时的时间
typedef NS_ENUM(NSInteger, HttpMethodType) {
    HttpMethodGet = 1 , //Http Get 方法
    HttpMethodPost      //Http Post 方法
};
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block
typedef void (^AFNErrorBlock)(NSError *error); // 访问失败block
@interface RACNetWorkManager : NSObject

+ (instancetype)shareNetWorkManage;
-(void)requestSoureDataFromUrlUsingGET:(HttpMethodType)httpType url:(NSString *)url paramData:(NSDictionary *)param successBlock:(SuccessBlock)success fialBlock:(AFNErrorBlock)fail;

/**
 get 方式请求数据

 @param url 基础url
 @param param 参数
 */
-(void)requestSoureDataFromUrlUsingGET:(NSString *)url paramData:(NSDictionary *)param successBlock:(SuccessBlock)success fialBlock:(AFNErrorBlock)fail;

/**
 post 请求数据

 @param url 基础uri
 @param param 参数
 */
-(void)requestSoureDataFromUrlUsingPOST:(NSString *)url paramData:(NSDictionary *)param successBlock:(SuccessBlock)success fialBlock:(AFNErrorBlock)fail;
@end
