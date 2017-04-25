//
//  firstViewModel.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/23.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "firstViewModel.h"
#import "RACViewModel.h"
#import "GPUimageViewModel.h"
#import "VideoEditModel.h"
#import "CalculationViewModel.h"
@interface firstViewModel()
@end
@implementation firstViewModel

- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        [self setUpSingal];
    }
    return self;
}

- (void)setUpSingal {    
    self.arrayData = @[@"RACTest",@"GPUImage",@"Camera",@"Automatic calculation"];
    self.title = @"firstView";
    self.dataSource = @[self.arrayData];
    self.shouldPullToRefresh = YES;
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        NSUInteger index = indexPath.row;
        switch (index) {
            case 0:
            {
                NSDictionary *paramRAC = @{@"title":@"RAC"};
                RACViewModel *viewModel = [[RACViewModel alloc] initWithServices:self.services params:paramRAC];
                [self.services pushViewModel:viewModel animated:YES];
                break;
            }
            case 1:
            {
                NSDictionary *paramGPU = @{@"title":@"GPUImage"};
                GPUimageViewModel *viewModel = [[GPUimageViewModel alloc] initWithServices:self.services params:paramGPU];
                [self.services pushViewModel:viewModel animated:YES];
                break;
            }
            case 2:
            {
                NSDictionary *paramGPU = @{@"title":@"Camera"};
                VideoEditModel *viewModel = [[VideoEditModel alloc] initWithServices:self.services params:paramGPU];
                [self.services pushViewModel:viewModel animated:YES];
                break;
            }
            case 3:
            {
                NSDictionary *paramGPU = @{@"title":@"Automatic calculation"};
                CalculationViewModel *viewModel = [[CalculationViewModel alloc] initWithServices:self.services params:paramGPU];
                [self.services pushViewModel:viewModel animated:YES];
                break;
            }
            default:
                break;
        }
        return [RACSignal empty];
    }];
}
@end
