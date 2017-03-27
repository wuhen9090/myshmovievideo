//
//  RACNetWorkManager.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/23.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "RACNetWorkManager.h"
#import <AFNetworking/AFNetworking.h>
@interface RACNetWorkManager()
@property (nonatomic, strong) AFHTTPSessionManager *afManager;
@end
@implementation RACNetWorkManager
+ (instancetype)shareNetWorkManage
{
    static RACNetWorkManager *shareNetWorkManage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetWorkManage = [[RACNetWorkManager alloc] init];
    });
    return shareNetWorkManage;
}
-(instancetype)init {
    self = [super init];
    if (self) {
        _afManager = [AFHTTPSessionManager manager];
        // 超时时间
        _afManager.requestSerializer.timeoutInterval = kTimeOutInterval;
        
        // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
        _afManager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
        //    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
        
        // 声明获取到的数据格式
        _afManager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
        //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
        // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
        
//        [self setRequestHeaderParam:[self GlobalHeaders]];
    }
    return self;
}
-(void)requestSoureDataFromUrlUsingGET:(NSString *)url paramData:(NSDictionary *)param successBlock:(SuccessBlock)success fialBlock:(AFNErrorBlock)fail
{
    [self.afManager GET:@"http://pm.yunhan-china.com/index.php/Api_sale/sales_get" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(dict,YES);
        } else {
            success(@{@"msg":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        fail(error);
    }];
}
-(void)requestSoureDataFromUrlUsingPOST:(NSString *)url paramData:(NSDictionary *)param successBlock:(SuccessBlock)success fialBlock:(AFNErrorBlock)fail{
    [self.afManager POST:@"http://pm.yunhan-china.com/index.php/api_common/login" parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(dict,YES);
        } else {
            success(@{@"msg":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        fail(error);
    }];
}
- (void)setRequestHeaderParam:(NSDictionary *)headData
{
    for (NSString* key in headData.allKeys) {
        id object = [headData objectForKey:key];
        if ([object isKindOfClass:[NSString class]]) {
            [_afManager.requestSerializer setValue:object forHTTPHeaderField:key];
        }else if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber* number = (NSNumber*)object;
            [_afManager.requestSerializer setValue:number.description forHTTPHeaderField:key];
        }
    }
}
-(NSDictionary *)GlobalHeaders {
NSDictionary *requestHeaders = @{
                                  @"api_key": @"0c79c28d69b5e0bbb982607d185e3dca",
                                  @"enCode" : @"1166f2ddfbfde6bc023a8e80b1706e18",
                                  @"gid" : @"0101011074100081fa7ec41d21379f785434b6db11faac",
                                  @"mfo" : @"Apple",
                                  @"mfov" : @"iPhone 6 Plus",
                                  @"partner" : @"1",
                                  @"plat" : @"3",
                                  @"pn" : @"1",
                                  @"poid" : @"31",
                                  @"sver" : @"5.3.0",
                                  @"sys" : @"ios",
                                  @"sysver" : @"9.2.1",
                                  @"uid" : @"F647FA87-18F9-422C-A822-3D02375E56C0personal"
                                };
    return requestHeaders;
}

@end
