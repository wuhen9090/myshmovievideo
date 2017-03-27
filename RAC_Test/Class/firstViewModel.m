//
//  firstViewModel.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/23.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "firstViewModel.h"

@implementation firstViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpSingal];
    }
    return self;
}
- (void)setUpSingal {
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
