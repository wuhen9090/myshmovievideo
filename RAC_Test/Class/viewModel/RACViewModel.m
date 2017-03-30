//
//  RACViewModel.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/29.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "RACViewModel.h"

@implementation RACViewModel
- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        [self setUpSignal];
    }
    return self;
}
- (void)setUpSignal {
    self.loginSingal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *param = @{@"phoneNumber":@"13456789001", @"password":@"f379eaf3c831b04de153469d1bec345e"};
        [[RACNetWorkManager shareNetWorkManage] requestSoureDataFromUrlUsingGET:@"" paramData:param successBlock:^(NSDictionary *dict, BOOL success) {
            [subscriber sendNext:dict];
            [subscriber sendCompleted];
        } fialBlock:^(NSError *error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"test");
        return [RACSignal empty];
        //        return self.loginSingal;
    }];
}
@end
