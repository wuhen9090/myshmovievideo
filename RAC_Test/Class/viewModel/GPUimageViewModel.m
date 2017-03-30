//
//  GPUimageViewModel.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/30.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "GPUimageViewModel.h"

@implementation GPUimageViewModel
- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
    }
    return self;
}
- (void)initialize{
    self.importImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *alertSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"选取图像" message:@"你喜欢的图像" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:action1];
            [alertView addAction:action2];
            [subscriber sendNext:alertView];
            [subscriber sendCompleted];

            return nil;
        }];
        return alertSignal;
    }];
}
@end
