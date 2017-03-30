//
//  firstViewModel.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/23.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "firstViewModel.h"
@interface firstViewModel()
@property (nonatomic, strong) id<MRCViewModelServices> services;
@end
@implementation firstViewModel

- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        [self setUpSingal];
    }
    return self;
}
//- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
//    self = [super init];
//    if (self) {
//        self.title    = params[@"title"];
//        self.services = services;
//        self.params   = params;
//    }
//    return self;
//}

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
    
    self.arrayData = @[@"RACTest",@"GPUImage"];
    self.title = @"firstView";
    self.dataSource = @[self.arrayData];
    self.shouldPullToRefresh = YES;
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        NSUInteger index = indexPath.row;
        switch (index) {
            case 0:
//                [self.]
                break;
                
            default:
                break;
        }
        return [RACSignal empty];
    }];
}
@end
